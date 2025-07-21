# osbase

基於 Ubuntu 和 Alpine Linux 的 Docker 基礎映像，預裝了常用的開發和部署工具。

## 描述

osbase 提供了兩個版本的 Docker 基礎映像：

- **Ubuntu 版本**：基於最新的 Ubuntu 映像
- **Alpine 版本**：基於輕量級的 Alpine Linux 映像

兩個版本都預裝了以下工具：

- AWS CLI v2
- Docker
- kubectl
- Git
- SSH 客戶端
- 常用的網路和系統工具（curl, jq, htop, nettools 等）

## 功能特色

- 🐳 支援 Docker-in-Docker
- ☁️ 預配置 AWS ECR 登入
- ⚡ 輕量化的 Alpine 版本可供選擇
- 🔧 預裝開發和運維常用工具
- 🌏 設定為台北時區
- 🔐 支援 SSH 金鑰配置

## 建構映像

### Ubuntu 版本

```bash
docker build -t osbase:ubuntu \
  --build-arg EC2_KEY="$(cat ~/.ssh/id_ed25519 | base64)" \
  --build-arg KUBECTL_CONFIG="$(cat ~/.kube/config | base64)" \
  --build-arg ECR_URL="your-ecr-url" \
  --build-arg AWS_DEFAULT_REGION="ap-southeast-1" \
  --build-arg AWS_ACCESS_KEY_ID="your-access-key" \
  --build-arg AWS_SECRET_ACCESS_KEY="your-secret-key" \
  -f Dockerfile .
```

### Alpine 版本

```bash
docker build -t osbase:alpine \
  --build-arg EC2_KEY="$(cat ~/.ssh/id_ed25519 | base64)" \
  --build-arg KUBECTL_CONFIG="$(cat ~/.kube/config | base64)" \
  --build-arg ECR_URL="your-ecr-url" \
  --build-arg AWS_DEFAULT_REGION="ap-southeast-1" \
  --build-arg AWS_ACCESS_KEY_ID="your-access-key" \
  --build-arg AWS_SECRET_ACCESS_KEY="your-secret-key" \
  -f Dockerfile.alpine .
```

## 使用方式

### 作為基礎映像

```dockerfile
FROM your-registry/osbase:ubuntu
# 或
FROM your-registry/osbase:alpine

# 您的應用程式配置
COPY . /app
WORKDIR /app
```

### 直接執行

```bash
# 啟動容器
docker run -it osbase:ubuntu bash

# 驗證工具安裝
aws --version
docker --version
kubectl version --client
```

## 環境變數

建構時需要設定以下參數：

| 參數                    | 描述                           | 範例                                     |
| ----------------------- | ------------------------------ | ---------------------------------------- |
| `EC2_KEY`               | SSH 私鑰（Base64 編碼）        | `$(cat ~/.ssh/id_ed25519 \| base64)`     |
| `KUBECTL_CONFIG`        | Kubernetes 配置（Base64 編碼） | `$(cat ~/.kube/config \| base64)`        |
| `ECR_URL`               | AWS ECR 登錄網址               | `123456789.dkr.ecr.region.amazonaws.com` |
| `AWS_DEFAULT_REGION`    | AWS 預設區域                   | `ap-southeast-1`                         |
| `AWS_ACCESS_KEY_ID`     | AWS 存取金鑰 ID                | -                                        |
| `AWS_SECRET_ACCESS_KEY` | AWS 秘密存取金鑰               | -                                        |

## 預裝工具

### Ubuntu 基礎映像

- Docker
- AWS CLI v2
- kubectl
- Git
- SSH 客戶端/伺服器
- 系統工具：curl, sudo, telnet, gnupg, net-tools, ca-certificates, jq, htop, iputils-ping, dnsutils, unzip, rsync

### Alpine 基礎映像

- K6 效能測試工具
- Python 3.12.6
- Docker
- AWS CLI
- kubectl
- Git
- SSH 客戶端
- 系統工具：curl, bash, jq, git, zip, unzip, gnupg

## GitLab CI/CD

此專案包含 `.gitlab-ci.yml` 配置檔，支援自動化建構和部署流程。

## 貢獻

歡迎提交 Issue 和 Pull Request 來改善此專案。

## 授權

請參閱 LICENSE 檔案了解授權詳情。
