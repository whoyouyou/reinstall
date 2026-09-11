# reinstall

## Debian / Ubuntu

以 `root` 用户执行。

### 1. 安装 curl

```bash
apt-get update && apt-get install -y curl ca-certificates
```

### 2. 下载并运行脚本

```bash
curl -fL --retry 3 'https://raw.githubusercontent.com/whoyouyou/reinstall/main/reinstall.sh' -o reinstall.sh && bash reinstall.sh
```
