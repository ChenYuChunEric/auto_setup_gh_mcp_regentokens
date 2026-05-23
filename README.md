# GitHub MCP Token 自動設定工具 (Auto Setup GH MCP Token)

此專案提供一個 **安全、簡潔** 的方式，讓使用者在 Windows 環境下透過 **Batch (CMD)** 介面快速檢查 GitHub CLI 安裝狀態、登入資訊，並安全地更新 GitHub Personal Access Token (PAT)。

---

## 🚀 快速開始

### 前置需求

1. **GitHub CLI (`gh`)**：若未安裝，腳本會自動使用 `winget` 安裝。
2. **Windows 作業系統**（支援 PowerShell / CMD，本文以 CMD 為主）。
3. **網路連線**：需要連線到 GitHub 進行驗證。

### 使用方式

1. 開啟 **命令提示字元 (cmd)**，切換至專案根目錄：
   ```cmd
   cd "g:\我的雲端硬碟\Antigravity_Sync\global_project\auto_setup_gh_mcp_regentokens"
   ```
2. 執行腳本：
   ```cmd
   setup_gh_token_helper.cmd
   ```
3. 依畫面指示選擇：
   - **A**：檢查 `gh` CLI 安裝與登入狀態。
   - **B**：安全更新 GitHub Token（Token 會直接透過管道傳給 `gh auth login --with-token`，不會寫入檔案）。
   - **Q**：結束工具。

---

## 🔒 安全性規範 (Security Best Practices)

1. **禁止明碼儲存**：絕不在任何檔案（如 `.json`、`.txt`）中寫入 Token。腳本僅在記憶體中暫存，完成後即清除。
2. **優先使用 GitHub CLI**：透過 `gh auth login --with-token` 讓憑證安全地儲存在系統層級的認證管理器中。
3. **隱藏輸入**：Batch 本身無法隱藏輸入，使用者需確保螢幕不被旁觀。目前會提示此限制。
4. **最小權限原則**：建議使用 *Fine‑grained* PAT，只授予本工作流所需的最小權限（如 `repo`、`read:user`）。

---

## 🛠️ MCP 伺服器配置參考

完成 Token 設定後，若需在 Claude Desktop 或其他 MCP 客戶端中使用，可參考以下 JSON 結構（將 `YOUR_TOKEN` 替換為已安全儲存的 Token）：

```json
{
  "mcpServers": {
    "github-mcp-server": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "YOUR_TOKEN"
      }
    }
  }
}
```

---

## 📦 專案結構

```
auto_setup_gh_mcp_regentokens/
├─ setup_gh_token_helper.cmd   # 主批次腳本
├─ README.md                  # 本說明文件
└─ .git/                      # Git 版本控制（已初始化）
```

---

## 🤝 貢獻指南

1. Fork 本倉庫。
2. 建立新分支並完成您的修改。
3. 透過 Pull Request 提交，請務必遵守上述安全性規範。

---

## 📜 授權

本專案採用 **MIT 授權**。詳見 `LICENSE` 檔案。

---

如有任何問題或建議，請在 GitHub Issue 中提出。
