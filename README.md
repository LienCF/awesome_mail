# Awesome Mail Project

這是 Awesome Mail 專案的主要 repository，包含了以下子專案：

## 子專案

- **awesome-mail**: Cloudflare Workers 後端 API
- **awesome_mail_flutter**: Flutter 前端應用程式

## 專案結構

```
awesome_mail/
├── awesome-mail/          # Cloudflare Workers 後端 (submodule)
├── awesome_mail_flutter/  # Flutter 前端應用程式 (submodule)
├── .kiro/                 # Kiro AI 助手配置和規格
└── CLAUDE.md             # 專案文檔
```

## 開發設置

### 克隆專案（包含 submodules）

```bash
git clone --recursive https://github.com/LienCF/awesome_mail.git
```

如果已經克隆了專案但沒有 submodules：

```bash
git submodule update --init --recursive
```

### 更新 submodules

```bash
git submodule update --remote
```

## 子專案說明

### awesome-mail (後端)
基於 Cloudflare Workers 的電子郵件服務 API

### awesome_mail_flutter (前端)
使用 Flutter 開發的跨平台電子郵件客戶端應用程式