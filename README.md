# reinstall

> 项目主页：[https://github.com/whobit/reinstall](https://github.com/whobit/reinstall)  
> 脚本说明：通用 Linux / Debian 纯净网络自动化重装脚本（单文件便携自解压版）

---

## ⚡ 快速起步（Debian / Ubuntu 原系统）

必须以 `root` 用户执行。

### 1. 安装基础依赖
```bash
apt-get update && apt-get install -y curl ca-certificates
```

### 2. 下载并进入交互向导
```bash
curl -fL --retry 3 'https://raw.githubusercontent.com/whobit/reinstall/main/reinstall.sh' -o reinstall.sh && bash reinstall.sh
```

### 3. 取消重装 / 撤销启动项（未重启前随时可撤回）
如果在执行准备流程后不想重装，或需要恢复原系统默认引导：
```bash
bash reinstall.sh reset
```

---

## 🚀 生产环境常用一键命令（非交互）

* **指定公钥 + 35965 端口 + 全能预设 + 自动重启（推荐）**：
  ```bash
  bash reinstall.sh 13 \
    --ssh-key /root/.ssh/id_ed25519.pub \
    --profile-full \
    --non-interactive \
    --yes \
    --reboot
  ```
  *(也可直接将 `--ssh-key` 替换为公钥文本 `"ssh-ed25519 AAAA..."`，或使用 `--github YourUsername`)*

* **从私密文件读取密码（防历史泄露）**：
  ```bash
  echo "YourPassword" > /root/pwd.txt && chmod 600 /root/pwd.txt
  bash reinstall.sh 13 --password-file /root/pwd.txt --profile-full --yes --reboot
  ```

* **安全预检与审计**：
  ```bash
  bash reinstall.sh --check         # 只读预检系统环境，不修改引导
  bash reinstall.sh --extract-only  # 仅解压内嵌源码供审计，不执行安装
  ```

---

## 🔄 装机重启后：系统流程与人工操作指南

### 一、重启后系统会发生什么？（全自动，无需干预）
1. **自动网络装机（约 2 ~ 5 分钟）**：服务器自动重启进入 Debian netboot 安装器，全自动格式化磁盘、拉取纯净基础系统、写入网络与 SSH 认证。
2. **自动二次重启**：装机完毕后自动重启，正式进入全新的纯净 Debian 系统。
3. **后台初始化（开机 2 分钟拉起）**：后台 `fleet-firstboot.service` 自动按需配置 Swapfile 虚拟内存、BBR、Fail2ban、自动更新以及安装所选组件。

---

### 二、哪些地方还需要人进行操作？（关键步骤）

#### 第 1 步：本地电脑清理旧指纹并 SSH 登录
由于系统重装导致主机指纹变更，本地电脑直连会报 `REMOTE HOST IDENTIFICATION HAS CHANGED` 错误。请在**本地电脑终端**执行：

```bash
# 1. 清理本地旧主机指纹
ssh-keygen -R [<你的服务器IP>]:35965

# 2. 登录新系统（默认 SSH 端口为 35965）
ssh -i ~/.ssh/<你的私钥文件名> -p 35965 root@<你的服务器IP>
```
> **私钥存放说明**：私钥文件（无后缀，如 `id_ed25519`、`id_rsa` 或自定义名称）只需保存在自己电脑的 `.ssh` 目录（Windows: `C:\Users\<用户名>\.ssh\`；Mac/Linux: `~/.ssh/`）。

#### 第 2 步：登录后，检查装机与初始化结果
登录进入 VPS 后，执行以下命令查看后台增强模块是否全部执行成功：

```bash
cat /var/lib/fleet-firstboot/last-run.status
```
*正常输出各模块状态（如 `swap: OK`、`bbr: OK`、`fail2ban: OK` 等；已完成步骤显示 `already complete`，失败步骤显示 `FAILED`）。*  
若需查看后台详细日志：`journalctl -u fleet-firstboot.service -n 50 --no-pager`。

#### 第 3 步：按需启动与配置业务（安全待命设计）
脚本默认将业务应用设为“已安装但未启动”，避免未配置前在公网裸奔：

* **如果启用了 S-UI 面板**：
  1. 查看随机生成的 32 位初始密码：
     ```bash
     cat /root/fleet-sui-credentials.txt
     ```
  2. 启动前先确认 S-UI 的监听地址与防火墙策略。若仅通过 SSH 隧道访问，建议只绑定本机回环地址，或明确阻止公网直接访问面板端口。
  3. 启动面板服务：
     ```bash
     systemctl enable --now s-ui
     ```
  4. **本地加密隧道安全访问（避免 HTTP 明文传输）**：  
     在**本地电脑终端**执行隧道转发：
     ```bash
     ssh -i ~/.ssh/<你的私钥文件名> -L 2096:127.0.0.1:2096 -p 35965 root@<你的服务器IP>
     ```
     保持终端开启，本地浏览器打开 **`http://127.0.0.1:2096`** 即可安全登录。  
     VPS 终端输入 `s-ui` 可调出交互管理菜单（配置域名证书、修改端口等）。

* **如果启用了 Realm 转发**：
  1. 编辑转发规则：`nano /etc/realm/config.toml`
  2. 启动转发服务：`systemctl enable --now realm`
  3. 检查状态：`systemctl status realm`

---

## 🛠️ 预设与增强模块详解

| 模块参数 | 核心作用 | 底层机制与运维操作 |
| :--- | :--- | :--- |
| **`--profile-full`** | **一键全能预设** | 一次性启用以下全部 6 项功能，适合开箱即用。 |
| **`--with-bbr`** | **TCP BBR + 内存自适应缓冲与大句柄** | 开启内核 `fq + bbr` 拥塞控制；根据可见内存自动配置 TCP 最大缓冲（约 1GB 及以上使用 32MB，更小内存使用 16MB），提升高 RTT / 高带宽链路的 TCP 窗口上限，减少默认缓冲不足造成的吞吐瓶颈；系统文件句柄容量提高到 1048576，交互会话 `nofile` 为 `65535 ~ 524288`，Realm / S-UI 等高并发服务单独配置 `LimitNOFILE=524288`。<br>• 检查 BBR：`sysctl net.ipv4.tcp_congestion_control`（应显示 `bbr`）<br>• 检查 Shell：`ulimit -n`<br>• 检查服务：`systemctl show realm -p LimitNOFILE` |
| **`--with-fail2ban`** | **防暴力破解** | **识别与封禁规则**：监听 systemd 日志中实际 SSH 端口（`35965`），**10 分钟内密码输错 5 次**，底层 **nftables** 自动拉黑该 IP **1 小时**（丢包阻断，原生支持 IPv4/IPv6）。<br>• 查看被封 IP：`fail2ban-client status sshd`<br>• 解封误封 IP：`fail2ban-client set sshd unbanip <IP>`<br>• 实时拦截日志：`journalctl -u fail2ban -f` |
| **`--with-unattended-upgrades`** | **Debian 自动安全更新** | 每日后台静默修补官方高危漏洞。内置 `Automatic-Reboot "false"`，**绝不突发自动重启机器**，确保服务稳定。<br>• 检查状态：`systemctl status unattended-upgrades` |
| **`--with-tools`** | **常用系统维护套件** | 预装 `htop`, `tmux`, `git`, `jq`, `iperf3`, `dig` (`bind9-dnsutils`), `mtr-tiny`, `ncdu`, `psmisc`, `bash-completion`。<br>• 测速/排障开箱即用，iperf3 仅为客户端不常驻后台端口。 |
| **`--with-realm`** | **Realm 高性能中转** | 安装时自动获取 GitHub 最新稳定 Release，并使用 GitHub 官方 Release Asset `SHA256 digest` 校验下载文件；未提供官方 SHA256 或校验不一致则拒绝安装。服务单独配置 `LimitNOFILE=524288`。<br>• 规则路径：`/etc/realm/config.toml`（配置后 `systemctl enable --now realm` 启动）。 |
| **`--with-s-ui`** | **S-UI Web 面板** | 安装时自动获取 GitHub 最新稳定 Release，并使用 GitHub 官方 Release Asset `SHA256 digest` 校验下载文件；未提供官方 SHA256 或校验不一致则拒绝安装。服务单独配置 `LimitNOFILE=524288`。<br>• 随机密码存放于 `/root/fleet-sui-credentials.txt`；服务默认不自动启动，启动前请确认监听地址与防火墙策略。 |

---

### 第三方组件版本与校验策略

Realm、S-UI 等直接从 GitHub Release 获取的第三方二进制不固定旧版本。每次安装时读取仓库的 **latest stable release**（不使用 draft / prerelease），按当前架构选择对应资产，并读取 GitHub Release Asset 返回的官方 `digest`。只有 `digest` 为有效的 `sha256:<64位摘要>` 且下载文件本地 SHA256 完全一致时才继续安装；缺少官方 SHA256 或校验失败时安全停止该组件安装。

Debian 系统软件继续通过 Debian 官方仓库安装和更新；底层 `bin456789/reinstall` 引导引擎仍固定到已审计提交，避免上游变化导致重装行为不可复现。

---

## 🌟 核心设计特性

1. **单文件自包含与双层完整性校验**：内嵌重装引擎、适配器与补丁执行 `SHA256SUMS` 校验；Realm / S-UI 等第三方应用不固定旧版本，安装时获取 GitHub 最新稳定 Release，并强制核对 GitHub 官方 Release Asset SHA256 digest。
2. **真实出网探测（NAT64/DNS64 保护）**：通过探测官方源判定实际出网族，规避“有内网 IPv4 路由但无公网 SNAT”的假双栈卡死；纯 IPv6 环境下绝不硬编码公网 DNS，**完整保护 DNS64 域名合成**。
3. **穿透式无硬编码 DNS 发现**：优先读取 systemd-resolved / NetworkManager 的真实上游 DNS，并过滤当前地址族没有默认路由的 DNS；若没有取得可直接使用的上游 DNS，则保留安装器自动生成的 DNS，避免破坏 DNS64 等特殊环境。
4. **宿主机时区自动嗅探**：自动探测原系统的真实时区并无感继承（后备 `Asia/Hong_Kong`）。
5. **端口标准与防失联保护**：默认 SSH 端口统一为 **`35965`**；纯 IPv6 机器禁止误关 IPv6 栈。
6. **双重凭据安全保底**：启用纯公钥登录时，系统自动生成随机控制台密码保底，SSH 端口只认公钥，VNC 保留备用排障。

---

## 📋 兼容性与运行环境

| 项目 | 支持范围 | 说明 |
| :--- | :--- | :--- |
| **目标操作系统** | Debian 13 (Trixie，默认) / Debian 12 (Bookworm) | 纯净最小化安装 |
| **支持架构** | `x86_64` (amd64) / `aarch64` (arm64) | 自动识别匹配 |
| **引导方式** | UEFI / Legacy BIOS | 自动适配引导扇区 |
| **内存限制** | 标称 $\ge 256\text{MB}$（可见内存 $\ge 220\text{MiB}$） | 动态内存探测 + 安装期 Swapfile |
| **系统盘容量** | 最低 $\ge 3\text{GiB}$ 独立物理磁盘 | 3GiB 仅作为基础系统硬下限；推荐 5GiB+，使用 `--profile-full` 建议 8GiB+；100% 根分区占满整块系统盘 |

---

## ⚙️ 命令行参数完整速查表

```text
认证选项：
  --user NAME              登录用户名（默认: root）
  --port N                 SSH 监听端口（默认: 35965）
  --ssh-key FILE_OR_KEY    公钥文件路径或完整公钥字符串
  --github USER            直接从 GitHub 获取用户公钥
  --password-file FILE     从私密文件读取单行登录密码（推荐）
  --pwd PASSWORD           命令行指定明文密码（易在历史记录中泄露）
  --disable-ssh-password   有公钥时禁用 SSH 密码登录（控制台保留备用密码）
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
  --disable-ipv6           禁用系统 IPv6（仅在验证了 IPv4 真实出网时生效）
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

## 📄 开源许可证

本项目基于 [GNU General Public License v3.0 (GPL-3.0)](LICENSE) 开放源代码。  
底层引导引擎源自 [bin456789/reinstall](https://github.com/bin456789/reinstall)（固定快照提交 `5db051675101f31bbe2fb3e093432fa4d1af8dcc`）。
