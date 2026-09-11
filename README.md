# reinstall

> 项目主页：[https://github.com/whobit/reinstall](https://github.com/whobit/reinstall)  
> 脚本说明：通用 Linux / Debian 纯净网络自动化重装脚本（单文件便携自解压版）

---

## ⚡ 快速开始（Debian / Ubuntu 原系统）

必须以 `root` 用户执行。

### 1. 安装基础依赖
```bash
apt-get update && apt-get install -y curl ca-certificates
```

### 2. 一键下载并进入交互向导
```bash
curl -fL --retry 3 'https://raw.githubusercontent.com/whobit/reinstall/main/reinstall.sh' -o reinstall.sh && bash reinstall.sh
```

---

## 🛑 常用快捷操作（置顶必读）

### 1. 取消重装 / 撤销启动项（未重启前随时可退）
如果在执行完准备流程后不想重装，或准备出错需要恢复原系统默认引导：
```bash
# 方式一：直接运行重置
bash reinstall.sh reset

# 方式二：在解压目录中直接重置
bash fleet-reinstall.*/vendor/reinstall.sh reset
```
> [!NOTE]
> 该命令会安全清理注入的安装内核与 GRUB/EFI 启动序列，恢复原系统的默认启动项。

### 2. 只读安全预检（不修改系统、不写入引导）
```bash
bash reinstall.sh --check
```

### 3. 生产环境静默一行流（常用场景）

* **指定公钥 + 35965 端口 + 全能预设 + 自动重启**：
  ```bash
  bash reinstall.sh 13 \
    --ssh-key /root/.ssh/id_ed25519.pub \
    --profile-full \
    --non-interactive \
    --yes \
    --reboot
  ```

* **从 GitHub 用户名自动拉取公钥**：
  ```bash
  bash reinstall.sh 13 \
    --github YourGitHubUsername \
    --profile-full \
    --yes \
    --reboot
  ```

* **从独立私密文件读取登录密码（防 Shell 历史泄露）**：
  ```bash
  echo "YourStrongPassword" > /root/pwd.txt && chmod 600 /root/pwd.txt
  bash reinstall.sh 13 \
    --password-file /root/pwd.txt \
    --profile-full \
    --yes \
    --reboot
  ```

* **仅解压审计源码（不执行安装）**：
  ```bash
  bash reinstall.sh --extract-only
  ```

---

## 🌟 核心设计特性

1. **单文件自包含（Zero External Fetching）**
   * 内嵌全部模块与补丁，自动执行 `SHA256SUMS` 校验，绝不半路缺失文件。
2. **真实出网能力探测（`probe_effective_network`）**
   * 不盲目听信 `ip route` 路由表，而是针对官方源真实连通性测试 `-4` 与 `-6`；
   * 彻底规避类似“有内网 IPv4 网关但无公网 SNAT 出网能力”导致的假双栈卡死问题。
3. **穿透式无硬编码 DNS 发现**
   * 穿透扫描 `/run/systemd/resolve/resolv.conf`、`/run/NetworkManager/no-stub-resolv.conf`，穿透 `127.0.0.53` 本地 Stub 缓存；
   * 纯 IPv6 环境自动剔除不可达的 IPv4 DNS，避免安装期解析超时；
   * 绝不硬编码公网 DNS，**完整保护纯 IPv6 环境下的 DNS64/NAT64 前缀合成**。
4. **宿主机时区自动嗅探与继承**
   * 自动探测宿主机实际时区（`timedatectl` / `/etc/timezone` / `/etc/localtime`），默认无感继承，后备 `Asia/Hong_Kong`。
5. **统一标准端口与防失联锁**
   * 默认 SSH 端口统一为 **`35965`**；
   * 纯 IPv6 机器强制锁定，禁止禁用 IPv6，避免失联。
6. **双重登录凭据安全**
   * 启用“仅公钥登录”时，自动生成 16 位随机强密码保底；
   * SSH 端口只认公钥（防暴力破解），VNC / 物理控制台保留该备用密码供紧急排障。
7. **首次启动优雅容错（Graceful Degradation）**
   * 纯 IPv6 若未配置 NAT64，自动跳过 GitHub Releases 下载（Realm / S-UI），保证 Debian 基础系统与 SSH 100% 顺利交付。

---

## 📋 兼容性与运行环境

| 项目 | 支持范围 | 说明 |
| :--- | :--- | :--- |
| **目标操作系统** | Debian 13 (Trixie，默认) / Debian 12 (Bookworm) | 纯净最小化安装 |
| **支持架构** | `x86_64` (amd64) / `aarch64` (arm64) | 自动适配 |
| **引导方式** | UEFI / Legacy BIOS | 自动识别匹配引导项 |
| **内存限制** | 标称 $\ge 256\text{MB}$（可见内存 $\ge 220\text{MiB}$） | 动态内存探测 + 安装期 Swapfile |
| **系统盘容量** | $\ge 3\text{GiB}$ 独立物理磁盘 | 100% 根分区占满，清空整块系统盘 |
| **宿主环境** | 正常运行的 Linux（非容器/非 LiveCD） | 自动补齐 curl, cpio 等必要工具 |

---

## ⚙️ 命令行参数完整速查表

```text
通用 Debian 重装封装 / Fleet Reinstall
  bash reinstall.sh --check                    只读检查
  bash reinstall.sh                           交互向导，默认 Debian 13
  bash reinstall.sh 12|13 [options]

认证选项：
  --user NAME              登录用户名（默认: root）
  --port N                 SSH 监听端口（默认: 35965）
  --ssh-key FILE_OR_KEY    公钥文件路径或完整公钥字符串
  --github USER            直接从 GitHub 获取用户公钥
  --password-file FILE     从私密文件读取单行登录密码（推荐）
  --pwd PASSWORD           命令行指定明文密码（易在历史记录中泄露）
  --disable-ssh-password   有公钥时禁用 SSH 密码登录（控制台仍保留备用密码）
  --enable-ssh-password    有公钥时仍开放 SSH 密码登录

预设与模块：
  --profile-full           一键启用全套预设（BBR + Fail2ban + 自动更新 + 工具包 + Realm + S-UI）
  --with-bbr               开启 TCP BBR 拥塞控制（fq + bbr）
  --with-fail2ban          开启 Fail2ban 防暴力破解服务（适配 systemd + nftables）
  --with-unattended-upgrades 启用 Debian 自动安全更新（禁止突发自动重启）
  --with-tools             预装常用维护套件（htop, tmux, git, jq, iperf3, bind9-dnsutils 等）
  --with-realm             预装 Realm 高性能中转转发服务（默认待配置不启动）
  --with-s-ui              预装 S-UI (Sing-box Web 面板，生成随机管理员凭据）

网络与硬件参数：
  --dns-server IP          显式指定上游 DNS（可重复指定）
  --disable-ipv6           禁用系统 IPv6（仅在验证了 IPv4 真实公网出网时生效）
  --disk /dev/DEVICE       指定重装目标磁盘（严格匹配根系统所在物理盘）
  --timezone AREA/CITY     设置目标时区（默认自动继承原系统时区，后备: Asia/Hong_Kong）
  --region global          软件源镜像区域（默认: global 官方 CDN 源）

执行控制：
  --non-interactive        非交互无人值守执行（需配合认证参数及 --yes）
  --yes                    确认格式化整块目标磁盘
  --reboot                 装机就绪后立即自动重启开始装机
  --help                   显示帮助说明
```

---

## 📦 首次启动任务（`fleet-firstboot`）与运维

装机完成后，系统首次启动 2 分钟将拉起后台配置服务：

* **持久化 Swap 分配**：根据机器物理内存自动在根分区上分配 1G/2G/4G 的 `/swapfile` 并优化 swappiness；
* **S-UI 面板初始凭据**：
  ```bash
  cat /root/fleet-sui-credentials.txt
  ```
* **Realm 转发配置**：配置文件位于 `/etc/realm/config.toml`，配置后执行 `systemctl enable --now realm` 启动。

### 常用排查命令
```bash
# 查看首次配置执行状态
systemctl status fleet-firstboot.service

# 查看详细初始化日志
journalctl -u fleet-firstboot.service -n 100 --no-pager

# 查看各模块完成状态
cat /var/lib/fleet-firstboot/last-run.status

# 手动重新触发未完成步骤
systemctl start fleet-firstboot.service
```

---

## 📄 开源许可证

本项目基于 [GNU General Public License v3.0 (GPL-3.0)](LICENSE) 开放源代码。  
上游底层引导引擎源自 [bin456789/reinstall](https://github.com/bin456789/reinstall)（固定快照提交 `5db051675101f31bbe2fb3e093432fa4d1af8dcc`）。
