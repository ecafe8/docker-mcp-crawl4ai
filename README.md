# Crawl4AI Docker 启动脚本

使用 `docker.sh` 启动或停止 `unclecode/crawl4ai:latest` 容器。

## 环境要求

- 已安装 Docker，并且 Docker 服务正在运行。
- 本机的 `11235` 端口未被其他程序占用。

## 启动

```bash
bash docker.sh
```

也可以显式指定操作：

```bash
bash docker.sh start
```

脚本会创建名为 `crawl4ai` 的容器；如果该容器已存在，则启动已有容器。服务启动后可通过以下地址访问：

## 健康检查：
http://127.0.0.1:11235/health/

## 预览：
http://127.0.0.1:11235/playground/

## 控制台：
http://127.0.0.1:11235/dashboard/

## MCP:
```json
{
  "mcpServers": {
    "crawl4ai": {
      "transport": "sse",
      "url": "http://127.0.0.1:11235/mcp/sse",
      "headers": {
        "Authorization": "Bearer benana"
      }
    }
  }
}
```


局域网内的其他设备应使用运行 Docker 主机的局域网 IP：

```text
http://<主机局域网IP>:11235
```

在 Docker 主机上可用以下命令查看本机 IP：

```bash
hostname -I
```

例如主机局域网 IP 是 `192.168.2.99`，其他设备访问 `http://192.168.2.99:11235`。请确保设备与主机处于可互通的局域网，并允许主机防火墙接收 TCP `11235` 端口连接。当前 Docker 端口映射会监听主机的所有网络接口；若主机也连接了不可信网络，请使用防火墙限制该端口仅允许局域网访问。

## 开机自启

容器使用 Docker 的 `unless-stopped` 重启策略。执行一次启动命令后，Docker 守护进程启动时会自动启动容器；对于已有容器，启动脚本也会自动设置该策略：

```bash
bash docker.sh start
```

Docker 服务本身也必须配置为随系统启动。在使用 systemd 的 Linux 主机上可执行：

```bash
sudo systemctl enable --now docker
```

通过 `bash docker.sh stop` 手动停止的容器不会在下次开机时自动启动；需要恢复时再次运行 `bash docker.sh start`。

如果本地没有对应镜像，Docker 会尝试拉取。也可以提前手动拉取：

```bash
docker pull unclecode/crawl4ai:latest
```

## 停止

```bash
bash docker.sh stop
```

停止操作会保留容器；再次执行启动命令即可重新启动。

## API Token

默认 API Token 为 `benana`。建议通过环境变量设置自己的 token：

```bash
CRAWL4AI_API_TOKEN="your-token" bash docker.sh start
```

启动时设置的 token 会传入新创建的容器。若容器已经存在，脚本会直接启动该容器，不会更新其配置；需要更换 token 时，请先移除旧容器，再重新启动：

```bash
docker rm -f crawl4ai
CRAWL4AI_API_TOKEN="your-token" bash docker.sh start
```


测试

```bash
curl -X POST http://127.0.0.1:11235/crawl \
  -H "Authorization: Bearer benana" \
  -H "Content-Type: application/json" \
  -d '{
    "urls": ["https://www.qq.com"],
    "crawler_config": {
      "type": "CrawlerRunConfig",
      "params": {
        "cache_mode": "bypass"
      }
    }
  }'
```