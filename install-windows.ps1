# ============================================================
#  AI CLI 統合インストーラー for Windows (PowerShell版)
#  Claude Code / Codex CLI / Gemini CLI を簡単インストール
# ============================================================

# 管理者権限チェック
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Red
    Write-Host "  管理者権限が必要です" -ForegroundColor Red
    Write-Host "============================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "PowerShellを管理者として実行してください。" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "方法: スタートボタンを右クリック →" -ForegroundColor Cyan
    Write-Host "      「Windows PowerShell (管理者)」または" -ForegroundColor Cyan
    Write-Host "      「ターミナル (管理者)」をクリック" -ForegroundColor Cyan
    Write-Host ""
    Read-Host "Enterキーで終了"
    exit 1
}

# 変数初期化
$INSTALL_CLAUDE = $false
$INSTALL_CODEX = $false
$INSTALL_GEMINI = $false

# ============================================================
# ユーティリティ関数
# ============================================================

function Print-Header {
    Clear-Host
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                                                        ║" -ForegroundColor Cyan
    Write-Host "║      🤖 AI CLI 統合インストーラー for Windows 🤖       ║" -ForegroundColor Yellow
    Write-Host "║                                                        ║" -ForegroundColor Cyan
    Write-Host "║   Claude Code / Codex CLI / Gemini CLI                 ║" -ForegroundColor White
    Write-Host "║   を簡単にインストールできます                         ║" -ForegroundColor White
    Write-Host "║                                                        ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Print-Success { param($Message) Write-Host "✅ $Message" -ForegroundColor Green }
function Print-Error { param($Message) Write-Host "❌ $Message" -ForegroundColor Red }
function Print-Warning { param($Message) Write-Host "⚠️  $Message" -ForegroundColor Yellow }
function Print-Info { param($Message) Write-Host "ℹ️  $Message" -ForegroundColor Blue }

function Print-Step {
    param($Message)
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "📌 $Message" -ForegroundColor Yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""
}

function Press-Enter {
    Write-Host ""
    Read-Host "Enterキーを押して続行"
}

# ============================================================
# 確認関数
# ============================================================

function Check-Node {
    try {
        $null = Get-Command node -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

function Check-Claude {
    try {
        $null = Get-Command claude -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

function Check-Codex {
    try {
        $null = Get-Command codex -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

function Check-Gemini {
    try {
        $null = Get-Command gemini -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

# ============================================================
# インストール関数
# ============================================================

function Install-NodeJS {
    Print-Step "Node.js をインストール中..."

    Write-Host "winget を使用してNode.jsをインストールします..."
    Write-Host ""

    try {
        winget install OpenJS.NodeJS.LTS -e --accept-package-agreements --accept-source-agreements

        # 環境変数を再読み込み
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

        if (Check-Node) {
            Print-Success "Node.js のインストールが完了しました"
            $nodeVersion = node --version
            Write-Host "  Node.js: $nodeVersion"
        } else {
            Print-Warning "Node.jsがインストールされましたが、パスが通っていない可能性があります"
            Write-Host "  PCを再起動後に再度お試しください"
        }
    } catch {
        Print-Error "Node.js のインストールに失敗しました"
        Write-Host ""
        Write-Host "手動でインストールしてください：" -ForegroundColor Yellow
        Write-Host "https://nodejs.org/" -ForegroundColor Cyan
        Write-Host ""
    }
}

function Install-ClaudeCLI {
    Print-Step "Claude Code CLI をインストール中..."
    npm install -g @anthropic-ai/claude-code
    if ($LASTEXITCODE -eq 0) {
        Print-Success "Claude Code CLI のインストールが完了しました"
    } else {
        Print-Error "Claude Code CLI のインストールに失敗しました"
    }
}

function Install-CodexCLI {
    Print-Step "Codex CLI をインストール中..."
    npm install -g @openai/codex
    if ($LASTEXITCODE -eq 0) {
        Print-Success "Codex CLI のインストールが完了しました"
    } else {
        Print-Error "Codex CLI のインストールに失敗しました"
    }
}

function Install-GeminiCLI {
    Print-Step "Gemini CLI をインストール中..."
    npm install -g @google/gemini-cli
    if ($LASTEXITCODE -eq 0) {
        Print-Success "Gemini CLI のインストールが完了しました"
    } else {
        Print-Error "Gemini CLI のインストールに失敗しました"
    }
}

# ============================================================
# ショートカット作成
# ============================================================

function Create-Shortcuts {
    Print-Step "デスクトップにショートカットを作成中..."

    $Desktop = [Environment]::GetFolderPath("Desktop")

    if ($INSTALL_CLAUDE) {
        $batContent = @"
@echo off
title Claude Code CLI
cd /d %USERPROFILE%
claude
pause
"@
        $batContent | Out-File -FilePath "$Desktop\Claude Code.bat" -Encoding ASCII
        Print-Success "Claude Code.bat を作成しました"
    }

    if ($INSTALL_CODEX) {
        $batContent = @"
@echo off
title Codex CLI
cd /d %USERPROFILE%
codex
pause
"@
        $batContent | Out-File -FilePath "$Desktop\Codex CLI.bat" -Encoding ASCII
        Print-Success "Codex CLI.bat を作成しました"
    }

    if ($INSTALL_GEMINI) {
        $batContent = @"
@echo off
title Gemini CLI
cd /d %USERPROFILE%
gemini
pause
"@
        $batContent | Out-File -FilePath "$Desktop\Gemini CLI.bat" -Encoding ASCII
        Print-Success "Gemini CLI.bat を作成しました"
    }
}

# ============================================================
# APIキー設定
# ============================================================

function Setup-APIKeys {
    Print-Step "APIキーの設定"

    Write-Host "各AIサービスを使用するにはAPIキーが必要です。"
    Write-Host "今すぐ設定するか、後で設定するか選択してください。"
    Write-Host ""

    if ($INSTALL_CLAUDE) {
        Write-Host ""
        Write-Host "【Claude Code】" -ForegroundColor Yellow
        Write-Host "APIキー取得先: https://console.anthropic.com/"
        Write-Host ""
        $setup = Read-Host "Claude APIキーを今すぐ設定しますか？ (y/n)"

        if ($setup -eq "y" -or $setup -eq "Y") {
            Write-Host ""
            $apiKey = Read-Host "APIキーを入力してください"
            if ($apiKey) {
                [Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", $apiKey, "User")
                Print-Success "Claude APIキーを設定しました"
            }
        } else {
            Write-Host ""
            Write-Host "後で設定する場合は、環境変数に以下を設定してください：" -ForegroundColor Cyan
            Write-Host "  変数名: ANTHROPIC_API_KEY"
            Write-Host "  値: あなたのAPIキー"
        }
    }

    if ($INSTALL_CODEX) {
        Write-Host ""
        Write-Host "【Codex CLI】" -ForegroundColor Yellow
        Write-Host "APIキー取得先: https://platform.openai.com/"
        Write-Host ""
        $setup = Read-Host "OpenAI APIキーを今すぐ設定しますか？ (y/n)"

        if ($setup -eq "y" -or $setup -eq "Y") {
            Write-Host ""
            $apiKey = Read-Host "APIキーを入力してください"
            if ($apiKey) {
                [Environment]::SetEnvironmentVariable("OPENAI_API_KEY", $apiKey, "User")
                Print-Success "OpenAI APIキーを設定しました"
            }
        } else {
            Write-Host ""
            Write-Host "後で設定する場合は、環境変数に以下を設定してください：" -ForegroundColor Cyan
            Write-Host "  変数名: OPENAI_API_KEY"
            Write-Host "  値: あなたのAPIキー"
        }
    }

    if ($INSTALL_GEMINI) {
        Write-Host ""
        Write-Host "【Gemini CLI】" -ForegroundColor Yellow
        Write-Host "APIキー取得先: https://aistudio.google.com/"
        Write-Host "※ 初回起動時にGoogleログインで認証する方法もあります"
        Write-Host ""
        $setup = Read-Host "Google APIキーを今すぐ設定しますか？ (y/n)"

        if ($setup -eq "y" -or $setup -eq "Y") {
            Write-Host ""
            $apiKey = Read-Host "APIキーを入力してください"
            if ($apiKey) {
                [Environment]::SetEnvironmentVariable("GOOGLE_API_KEY", $apiKey, "User")
                Print-Success "Google APIキーを設定しました"
            }
        } else {
            Write-Host ""
            Write-Host "後で設定する場合は、環境変数に以下を設定してください：" -ForegroundColor Cyan
            Write-Host "  変数名: GOOGLE_API_KEY"
            Write-Host "  値: あなたのAPIキー"
        }
    }
}

# ============================================================
# 現在の状態を表示
# ============================================================

function Show-CurrentStatus {
    Print-Step "現在の環境をチェック中..."

    Write-Host "【インストール状況】"
    Write-Host ""

    if (Check-Node) {
        $nodeVersion = node --version
        Print-Success "Node.js: インストール済み ($nodeVersion)"
    } else {
        Print-Warning "Node.js: 未インストール → インストールします"
    }

    if (Check-Claude) {
        Print-Success "Claude Code CLI: インストール済み"
    } else {
        Write-Host "  Claude Code CLI: 未インストール"
    }

    if (Check-Codex) {
        Print-Success "Codex CLI: インストール済み"
    } else {
        Write-Host "  Codex CLI: 未インストール"
    }

    if (Check-Gemini) {
        Print-Success "Gemini CLI: インストール済み"
    } else {
        Write-Host "  Gemini CLI: 未インストール"
    }

    Write-Host ""
}

# ============================================================
# メニュー表示
# ============================================================

function Show-Menu {
    Print-Header

    Write-Host "インストールするAI CLIを選択してください："
    Write-Host ""
    Write-Host "  [1] Claude Code CLI のみ" -ForegroundColor Cyan
    Write-Host "  [2] Codex CLI (OpenAI) のみ" -ForegroundColor Cyan
    Write-Host "  [3] Gemini CLI のみ" -ForegroundColor Cyan
    Write-Host "  [4] 全部インストール（おすすめ）" -ForegroundColor Cyan
    Write-Host "  [5] 終了" -ForegroundColor Cyan
    Write-Host ""

    $choice = Read-Host "番号を入力してください (1-5)"

    switch ($choice) {
        "1" { $script:INSTALL_CLAUDE = $true }
        "2" { $script:INSTALL_CODEX = $true }
        "3" { $script:INSTALL_GEMINI = $true }
        "4" {
            $script:INSTALL_CLAUDE = $true
            $script:INSTALL_CODEX = $true
            $script:INSTALL_GEMINI = $true
        }
        "5" {
            Write-Host ""
            Write-Host "インストーラーを終了します。"
            exit 0
        }
        default {
            Print-Error "無効な選択です。1-5の番号を入力してください。"
            Press-Enter
            Show-Menu
            return
        }
    }
}

# ============================================================
# 完了画面
# ============================================================

function Show-Completion {
    Print-Header

    Write-Host "🎉 インストールが完了しました！ 🎉" -ForegroundColor Green
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host ""
    Write-Host "【使い方】"
    Write-Host ""
    Write-Host "  デスクトップに作成されたショートカットを"
    Write-Host "  ダブルクリックするだけで起動できます！"
    Write-Host ""

    if ($INSTALL_CLAUDE) {
        Write-Host "  🟣 Claude Code.bat → Claude Code CLI が起動" -ForegroundColor Magenta
    }
    if ($INSTALL_CODEX) {
        Write-Host "  🟢 Codex CLI.bat → Codex CLI が起動" -ForegroundColor Green
    }
    if ($INSTALL_GEMINI) {
        Write-Host "  🔵 Gemini CLI.bat → Gemini CLI が起動" -ForegroundColor Blue
    }

    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host ""
    Write-Host "【APIキーについて】"
    Write-Host ""
    Write-Host "  各サービスを使うにはAPIキーが必要です。"
    Write-Host "  設定していない場合は、各サービスのサイトで"
    Write-Host "  APIキーを取得してください。"
    Write-Host ""
    Write-Host "  Claude: https://console.anthropic.com/" -ForegroundColor Cyan
    Write-Host "  OpenAI: https://platform.openai.com/" -ForegroundColor Cyan
    Write-Host "  Gemini: https://aistudio.google.com/" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host ""
    Write-Host "※ 環境変数を反映するため、PCを再起動することをお勧めします。" -ForegroundColor Yellow
    Write-Host ""

    Press-Enter
}

# ============================================================
# メイン処理
# ============================================================

function Main {
    # ホームディレクトリに移動
    Set-Location $HOME

    # ヘッダー表示
    Print-Header

    Write-Host "このインストーラーは、AI CLI ツールを"
    Write-Host "簡単にインストールするためのものです。"
    Write-Host ""
    Write-Host "以下のツールをインストールできます："
    Write-Host "  • Claude Code CLI (Anthropic)"
    Write-Host "  • Codex CLI (OpenAI)"
    Write-Host "  • Gemini CLI (Google)"
    Write-Host ""

    Press-Enter

    # 現在の状態を表示
    Show-CurrentStatus
    Press-Enter

    # メニュー表示
    Show-Menu

    # 確認
    Write-Host ""
    Write-Host "以下をインストールします："
    if ($INSTALL_CLAUDE) { Write-Host "  • Claude Code CLI" }
    if ($INSTALL_CODEX) { Write-Host "  • Codex CLI" }
    if ($INSTALL_GEMINI) { Write-Host "  • Gemini CLI" }
    Write-Host ""
    $confirm = Read-Host "続行しますか？ (y/n)"

    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Host "インストールをキャンセルしました。"
        exit 0
    }

    # Node.js のインストール
    if (-not (Check-Node)) {
        Install-NodeJS
    } else {
        Print-Success "Node.js は既にインストールされています"
    }

    # 各CLI のインストール
    if ($INSTALL_CLAUDE -and -not (Check-Claude)) {
        Install-ClaudeCLI
    } elseif ($INSTALL_CLAUDE) {
        Print-Success "Claude Code CLI は既にインストールされています"
    }

    if ($INSTALL_CODEX -and -not (Check-Codex)) {
        Install-CodexCLI
    } elseif ($INSTALL_CODEX) {
        Print-Success "Codex CLI は既にインストールされています"
    }

    if ($INSTALL_GEMINI -and -not (Check-Gemini)) {
        Install-GeminiCLI
    } elseif ($INSTALL_GEMINI) {
        Print-Success "Gemini CLI は既にインストールされています"
    }

    # ショートカット作成
    Create-Shortcuts

    # APIキー設定
    Setup-APIKeys

    # 完了画面
    Show-Completion
}

# スクリプト実行
Main
