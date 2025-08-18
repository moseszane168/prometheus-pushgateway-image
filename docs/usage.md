# Pushgateway 使用指南

# 商品链接

[Pushgateway-Prometheus推送网关]()

# 商品说明

‌Pushgateway 是 Prometheus 生态中的 ‌中间代理组件‌，用于接收短期任务（如定时作业、临时服务）主动推送的监控指标数据，再由 Prometheus 定期拉取。

# 商品购买

您可以在云商店搜索 **Pushgateway**。

其中，地域、规格、推荐配置使用默认，购买方式根据您的需求选择按需/按月/按年，短期使用推荐按需，长期使用推荐按月/按年，确认配置后点击“立即购买”。

# 商品资源配置

商品支持 **ECS 控制台配置**，下面对资源配置的方式进行介绍。

## <a id="ECS控制台配置"></a>ECS 控制台配置

### 准备工作

在使用ECS控制台配置前，需要您提前配置好 **安全组规则**。

> **安全组规则的配置如下：**
> - 入方向规则放通端口 `9091`，**源地址内必须包含您的客户端 ip**，否则无法访问
> - 入方向规则放通 CloudShell 连接实例使用的端口 `22`，以便在控制台登录调试
> - 出方向规则一键放通

### 创建ECS

前提工作准备好后，选择 ECS 控制台配置跳转到购买 ECS 页面，ECS 资源的配置如下图所示：

![](images/img1.png)

![](images/img2.png)

![](images/img3.png)

> **值得注意的是：**
> - VPC 您可以自行创建
> - 安全组选择 [**准备工作**](#准备工作) 中配置的安全组；
> - 弹性公网IP选择现在购买，推荐选择“按流量计费”，带宽大小可设置为5Mbit/s；
> - 高级配置需要在高级选项支持注入自定义数据，所以登录凭证不能选择“密码”，选择创建后设置；
> - 其余默认或按规则填写即可。

# 商品使用

## Pushgateway 使用

### 查看Pushgateway服务端状态

systemctl status harbor
![](images/img4.png)

### 查看Pushgateway容器状态

docker ps -a
![](images/img5.png)

### 查看当前指标

http://ip:9091
![](images/img6.png)

### 参考文档

[Pushgateway官网](https://prometheus.io/docs/practices/pushing/)