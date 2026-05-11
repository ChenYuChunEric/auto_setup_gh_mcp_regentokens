---
description: Setup GitHub Toke
---

# GitHub Token 安全性處理準則 (Global Security Rules)

此文件定義了在所有自動化腳本與工作流中處理 GitHub Personal Access Token (PAT) 的安全性規範。

## 1. 禁止明碼儲存
- **絕對禁止**將 Token 以明碼 (Plain Text) 形式儲存在專案目錄下的 JSON、YAML、TXT 或環境變數設定檔中（例如 `mcp_config.json`）。
- 專案工作目錄不應包含任何持久化的敏感憑證。

## 2. 優先使用 GitHub CLI (gh) 認證
- 應優先透過 `gh auth login --with-token` 進行身分驗證。
- `gh` 工具會將憑證安全地儲存在系統層級的身分驗證管理器中，而非專案檔案中。

## 3. 輸入安全性
- 在腳本中要求輸入 Token 時，**必須**使用隱藏輸入的方法（如 Python 的 `getpass.getpass()`）。
- 嚴禁在終端機輸出 (Stdout) 中顯示完整或部分的 Token。

## 4. MCP 設定更新規範
- 若需要更新 MCP (Model Context Protocol) 伺服器的 Token，應指導使用者手動修改其系統級別的設定檔（例如 Claude Desktop Config），或透過受保護的環境變數傳遞。
- 自動化腳本不應在未經加密的情況下改寫這些設定檔。

## 5. Token 權限原則 (Principle of Least Privilege)
- 建議使用者使用 **Fine-grained Personal Access Tokens**。
- 僅授予該工作流所需的最小權限範圍（例如僅限特定的儲存庫或組織）。

---
> [!IMPORTANT]
> 違反此準則可能導致憑證外洩，若在執行過程中發現專案內含明碼 Token，應優先執行清理與移除作業。


# GitHub 環境與 Token 設定工作流 (Setup GitHub Token)

**AI 執行指示：**
當使用者輸入 `[/setup-gh-token]` 觸發此工作流時，請身為 AI 的你**自動使用 `run_command` 執行**下方的 PowerShell 腳本。
此腳本會產生一個暫存檔，並彈出一個**全新的互動式 PowerShell 終端機視窗**，讓使用者可以透過輸入選項 A 或 B 來完成相關操作。操作完成後暫存檔會自動刪除。

// turbo
```powershell
$tempScript = @"
`$Host.UI.RawUI.WindowTitle = 'GitHub Token 安全設定小幫手'
Clear-Host
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "       GitHub Token 安全設定小幫手" -ForegroundColor White
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "[A] 檢查 gh CLI 安裝與登入狀態"
Write-Host "[B] 安全更新 GitHub Token"
Write-Host "[Q] 離開"
Write-Host "==============================================" -ForegroundColor Cyan
`$choice = Read-Host "請輸入您的選擇 (A/B/Q)"

if (`$choice -match '^[Aa]$') {
    Write-Host "`n正在檢查 gh CLI..." -ForegroundColor Yellow
    if (!(Get-Command gh -ErrorAction SilentlyContinue)) {
        Write-Host "未找到 gh CLI，正在嘗試透過 winget 安裝..." -ForegroundColor Yellow
        winget install --id GitHub.cli --silent --accept-package-agreements --accept-source-agreements
    } else {
        Write-Host "gh CLI 已安裝。" -ForegroundColor Green
        gh --version
    }
    Write-Host "`n正在檢查登入狀態..." -ForegroundColor Yellow
    gh auth status
    Write-Host "`n請按任意鍵結束..." -ForegroundColor Cyan
    `$null = `$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
} elseif (`$choice -match '^[Bb]$') {
    Write-Host "`n==============================================" -ForegroundColor Yellow
    Write-Host "為了安全性，Token 輸入將被隱藏處理，不會保存在專案檔案中。"
    Write-Host "==============================================" -ForegroundColor Yellow
    `$secureToken = Read-Host "請貼上您的 GitHub Token" -AsSecureString
    `$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR(`$secureToken)
    `$token = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(`$BSTR)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR(`$BSTR)
    
    Write-Host "正在驗證..." -ForegroundColor Yellow
    `$token | gh auth login --with-token
    if (`$LASTEXITCODE -eq 0) {
        Write-Host "Token 更新成功！目前登入帳號為：" -ForegroundColor Green
        gh api user --jq .login
    } else {
        Write-Host "Token 驗證失敗，請檢查 Token 是否正確。" -ForegroundColor Red
    }
    `$token = `$null
    `$secureToken = `$null
    Write-Host "`n請按任意鍵結束..." -ForegroundColor Cyan
    `$null = `$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}
"@

$tempPath = Join-Path $env:TEMP "gh_setup_temp.ps1"
Set-Content -Path $tempPath -Value $tempScript -Encoding UTF8
Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$tempPath`"" -Wait
Remove-Item -Path $tempPath -Force
```

> [!TIP]
> 此工作流會自動呼叫新的終端機視窗，使用者只要依照畫面提示 (A、B 選項) 輸入即可完成驗證，所有敏感 Token 皆受系統安全隱藏保護。
