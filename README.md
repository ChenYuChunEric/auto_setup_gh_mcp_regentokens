# GitHub MCP Token 自動設定工具 (Auto Setup GH MCP Token)

此專案旨在提供一個安全、簡便的方式來更新與管理 GitHub Personal Access Token (PAT)，特別是針對 Model Context Protocol (MCP) 伺服器的整合使用。透過自動化指令，協助使用者在不洩漏敏感資訊的前提下完成身分驗證。

## 🚀 快速開始

本工具整合於 AI 助手的工作流中，您可以透過以下方式啟動：

### 1. 使用工作流指令 (推薦)
在與 AI 助手的對話中輸入以下指令即可啟動互動式設定小幫手：

```text
[/setup-gh-token]
```

### 2. 選單功能說明
啟動後，系統會跳出一個安全的 PowerShell 視窗，提供以下功能：
- **[A] 檢查並安裝 GitHub CLI**：初次使用時，腳本會自動檢查系統是否已安裝 `gh` 工具，若無則透過 `winget` 進行靜默安裝。
- **[B] 安全更新 GitHub Token**：直接貼上您的 GitHub Token，腳本會透過加密通道進行身份驗證，確保 Token 不會儲存在純文字檔案中。
- **[Q] 結束**：關閉工具。

---

## 🔒 安全性規範 (Security Best Practices)

為了保護您的 GitHub 帳號安全，本專案嚴格遵守以下安全性規範：

1. **禁止明碼儲存**：絕對不要將 Token 直接寫在任何 `.json`、`.txt` 或環境變數設定檔中。
2. **優先使用 CLI 認證**：本工具透過 `gh auth login` 進行認證，憑證會安全地儲存在系統層級的身分驗證管理員中（而非專案目錄內）。
3. **隱藏輸入處理**：在執行更新時，Token 輸入會被隱藏，避免出現在 AI 的對話歷史或終端機日誌中。
4. **權限最小化**：建議使用 **Fine-grained Personal Access Tokens**，並僅授予所需的最小權限（例如 `repo` 或 `read:user`）。

---

## 🛠️ MCP 伺服器配置參考

完成設定後，若您需要更新 Claude Desktop 或其他 MCP 客戶端的配置，請參考以下結構：

```json
{
  "mcpServers": {
    "github-mcp-server": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "您的_TOKEN_已透過本工具安全儲存於系統"
      }
    }
  }
}
```

---

## 📦 依賴需求
- **作業系統**：Windows 10/11
- **GitHub CLI (gh)**：本工具會嘗試自動安裝。
- **終端機環境**：支援 UTF-8 之終端機（如 PowerShell）。

---
> [!IMPORTANT]
> **安全性警示**：若您曾不慎在對話中以明碼形式貼出 Token，請務必在完成設定後立即前往 [GitHub Token 設定頁面](https://github.com/settings/tokens) 撤銷 (Revoke) 該 Token。
