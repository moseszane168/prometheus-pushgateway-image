#!/bin/bash

# Pushgateway 安装和服务配置脚本

SERVICE_NAME="pushgateway"
IMAGE_NAME="prom/pushgateway"
CONTAINER_NAME="pushgateway"
PORT="9091"

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo "Docker 未安装，请先安装 Docker"
    exit 1
fi

# 检查镜像是否存在
if ! docker images --format "{{.Repository}}" | grep -q "^${IMAGE_NAME}$"; then
    echo "拉取 Pushgateway 镜像..."
    docker pull ${IMAGE_NAME}
else
    echo "Pushgateway 镜像已存在，跳过拉取"
fi

# 检查容器是否在运行
if ! docker ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    echo "启动 Pushgateway 容器..."
    if docker ps -a --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
        echo "发现已停止的 Pushgateway 容器，启动它..."
        docker start ${CONTAINER_NAME}
    else
        docker run -d \
            --name ${CONTAINER_NAME} \
            -p ${PORT}:9091 \
            --restart unless-stopped \
            ${IMAGE_NAME}
    fi
else
    echo "Pushgateway 容器已在运行"
fi

# 创建 systemd 服务文件
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

cat <<EOF | sudo tee ${SERVICE_FILE} > /dev/null
[Unit]
Description=Pushgateway Docker Container
After=docker.service
Requires=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker start -a ${CONTAINER_NAME}
ExecStop=/usr/bin/docker stop -t 2 ${CONTAINER_NAME}

[Install]
WantedBy=multi-user.target
EOF

# 重载 systemd
sudo systemctl daemon-reload

# 启用并启动服务
sudo systemctl enable ${SERVICE_NAME}
sudo systemctl start ${SERVICE_NAME}

echo "Pushgateway 已安装并配置为系统服务"
echo "管理命令:"
echo "启动服务: sudo systemctl start ${SERVICE_NAME}"
echo "停止服务: sudo systemctl stop ${SERVICE_NAME}"
echo "查看状态: sudo systemctl status ${SERVICE_NAME}"
echo "查看日志: journalctl -u ${SERVICE_NAME} -f"