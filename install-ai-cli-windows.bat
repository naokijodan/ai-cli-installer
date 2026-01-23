@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ============================================================
::  AI CLI 統合インストーラー for Windows
::  Claude Code / Codex CLI / Gemini CLI を簡単インストール
:: ============================================================

title AI CLI 統合インストーラー

:: 管理者権限チェック
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo ============================================================
    echo   管理者権限が必要です
    echo ============================================================
    echo.
    echo このインストーラーを右クリックして
    echo 「管理者として実行」を選択してください。
    echo.
    pause
    exit /b 1
)

:: 変数初期化
set INSTALL_CLAUDE=0
set INSTALL_CODEX=0
set INSTALL_GEMINI=0

:: メイン処理開始
call :main
goto :eof

:: ============================================================
:: メイン処理
:: ============================================================
:main
    cls
    call :print_header

    echo このインストーラーは、AI CLI ツールを
    echo 簡単にインストールするためのものです。
    echo.
    echo 以下のツールをインストールできます：
    echo   - Claude Code CLI (Anthropic)
    echo   - Codex CLI (OpenAI)
    echo   - Gemini CLI (Google)
    echo.
    pause

    call :show_current_status
    pause

    call :show_menu

    :: 確認
    echo.
    echo 以下をインストールします：
    if %INSTALL_CLAUDE%==1 echo   - Claude Code CLI
    if %INSTALL_CODEX%==1 echo   - Codex CLI
    if %INSTALL_GEMINI%==1 echo   - Gemini CLI
    echo.
    set /p confirm="続行しますか？ (y/n): "
    if /i not "%confirm%"=="y" (
        echo インストールをキャンセルしました。
        pause
        exit /b 0
    )

    :: Node.js のインストール確認
    call :check_node
    if %errorlevel% neq 0 (
        call :install_node
    ) else (
        echo [OK] Node.js は既にインストールされています
    )

    :: 各CLI のインストール
    if %INSTALL_CLAUDE%==1 (
        call :check_claude
        if !errorlevel! neq 0 (
            call :install_claude_cli
        ) else (
            echo [OK] Claude Code CLI は既にインストールされています
        )
    )

    if %INSTALL_CODEX%==1 (
        call :check_codex
        if !errorlevel! neq 0 (
            call :install_codex_cli
        ) else (
            echo [OK] Codex CLI は既にインストールされています
        )
    )

    if %INSTALL_GEMINI%==1 (
        call :check_gemini
        if !errorlevel! neq 0 (
            call :install_gemini_cli
        ) else (
            echo [OK] Gemini CLI は既にインストールされています
        )
    )

    :: ショートカット作成
    call :create_shortcuts

    :: APIキー設定
    call :setup_api_keys

    :: 完了画面
    call :show_completion

    goto :eof

:: ============================================================
:: ヘッダー表示
:: ============================================================
:print_header
    cls
    echo.
    echo ╔════════════════════════════════════════════════════════╗
    echo ║                                                        ║
    echo ║      🤖 AI CLI 統合インストーラー for Windows 🤖       ║
    echo ║                                                        ║
    echo ║   Claude Code / Codex CLI / Gemini CLI                 ║
    echo ║   を簡単にインストールできます                         ║
    echo ║                                                        ║
    echo ╚════════════════════════════════════════════════════════╝
    echo.
    goto :eof

:: ============================================================
:: 現在の状態を表示
:: ============================================================
:show_current_status
    echo.
    echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo  現在の環境をチェック中...
    echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo.
    echo 【インストール状況】
    echo.

    call :check_node
    if %errorlevel%==0 (
        for /f "tokens=*" %%v in ('node --version 2^>nul') do echo [OK] Node.js: インストール済み ^(%%v^)
    ) else (
        echo [  ] Node.js: 未インストール → インストールします
    )

    call :check_claude
    if %errorlevel%==0 (
        echo [OK] Claude Code CLI: インストール済み
    ) else (
        echo [  ] Claude Code CLI: 未インストール
    )

    call :check_codex
    if %errorlevel%==0 (
        echo [OK] Codex CLI: インストール済み
    ) else (
        echo [  ] Codex CLI: 未インストール
    )

    call :check_gemini
    if %errorlevel%==0 (
        echo [OK] Gemini CLI: インストール済み
    ) else (
        echo [  ] Gemini CLI: 未インストール
    )

    echo.
    goto :eof

:: ============================================================
:: メニュー表示
:: ============================================================
:show_menu
    call :print_header

    echo インストールするAI CLIを選択してください：
    echo.
    echo   [1] Claude Code CLI のみ
    echo   [2] Codex CLI (OpenAI) のみ
    echo   [3] Gemini CLI のみ
    echo   [4] 全部インストール（おすすめ）
    echo   [5] 終了
    echo.

    set /p choice="番号を入力してください (1-5): "

    if "%choice%"=="1" (
        set INSTALL_CLAUDE=1
    ) else if "%choice%"=="2" (
        set INSTALL_CODEX=1
    ) else if "%choice%"=="3" (
        set INSTALL_GEMINI=1
    ) else if "%choice%"=="4" (
        set INSTALL_CLAUDE=1
        set INSTALL_CODEX=1
        set INSTALL_GEMINI=1
    ) else if "%choice%"=="5" (
        echo.
        echo インストーラーを終了します。
        pause
        exit /b 0
    ) else (
        echo [エラー] 無効な選択です。1-5の番号を入力してください。
        pause
        goto :show_menu
    )
    goto :eof

:: ============================================================
:: 確認関数
:: ============================================================
:check_node
    where node >nul 2>&1
    exit /b %errorlevel%

:check_claude
    where claude >nul 2>&1
    exit /b %errorlevel%

:check_codex
    where codex >nul 2>&1
    exit /b %errorlevel%

:check_gemini
    where gemini >nul 2>&1
    exit /b %errorlevel%

:: ============================================================
:: Node.js インストール
:: ============================================================
:install_node
    echo.
    echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo  Node.js をインストール中...
    echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo.

    :: winget を使用してインストール
    winget install OpenJS.NodeJS.LTS -e --accept-package-agreements --accept-source-agreements

    if %errorlevel%==0 (
        echo [OK] Node.js のインストールが完了しました
        :: PATHを更新するために環境変数を再読み込み
        call refreshenv >nul 2>&1
    ) else (
        echo [エラー] Node.js のインストールに失敗しました
        echo.
        echo 手動でインストールしてください：
        echo https://nodejs.org/
        echo.
        pause
    )
    goto :eof

:: ============================================================
:: CLI インストール
:: ============================================================
:install_claude_cli
    echo.
    echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo  Claude Code CLI をインストール中...
    echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo.

    call npm install -g @anthropic-ai/claude-code

    if %errorlevel%==0 (
        echo [OK] Claude Code CLI のインストールが完了しました
    ) else (
        echo [エラー] Claude Code CLI のインストールに失敗しました
    )
    goto :eof

:install_codex_cli
    echo.
    echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo  Codex CLI をインストール中...
    echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo.

    call npm install -g @openai/codex

    if %errorlevel%==0 (
        echo [OK] Codex CLI のインストールが完了しました
    ) else (
        echo [エラー] Codex CLI のインストールに失敗しました
    )
    goto :eof

:install_gemini_cli
    echo.
    echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo  Gemini CLI をインストール中...
    echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo.

    call npm install -g @google/gemini-cli

    if %errorlevel%==0 (
        echo [OK] Gemini CLI のインストールが完了しました
    ) else (
        echo [エラー] Gemini CLI のインストールに失敗しました
    )
    goto :eof

:: ============================================================
:: ショートカット作成
:: ============================================================
:create_shortcuts
    echo.
    echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo  デスクトップにショートカットを作成中...
    echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo.

    set DESKTOP=%USERPROFILE%\Desktop

    :: Claude Code ショートカット
    if %INSTALL_CLAUDE%==1 (
        (
            echo @echo off
            echo title Claude Code CLI
            echo cd /d %%USERPROFILE%%
            echo claude
            echo pause
        ) > "%DESKTOP%\Claude Code.bat"
        echo [OK] Claude Code.bat を作成しました
    )

    :: Codex CLI ショートカット
    if %INSTALL_CODEX%==1 (
        (
            echo @echo off
            echo title Codex CLI
            echo cd /d %%USERPROFILE%%
            echo codex
            echo pause
        ) > "%DESKTOP%\Codex CLI.bat"
        echo [OK] Codex CLI.bat を作成しました
    )

    :: Gemini CLI ショートカット
    if %INSTALL_GEMINI%==1 (
        (
            echo @echo off
            echo title Gemini CLI
            echo cd /d %%USERPROFILE%%
            echo gemini
            echo pause
        ) > "%DESKTOP%\Gemini CLI.bat"
        echo [OK] Gemini CLI.bat を作成しました
    )

    goto :eof

:: ============================================================
:: APIキー設定
:: ============================================================
:setup_api_keys
    echo.
    echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo  APIキーの設定
    echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo.
    echo 各AIサービスを使用するにはAPIキーが必要です。
    echo 今すぐ設定するか、後で設定するか選択してください。
    echo.

    :: Claude API Key
    if %INSTALL_CLAUDE%==1 (
        echo.
        echo 【Claude Code】
        echo APIキー取得先: https://console.anthropic.com/
        echo.
        set /p setup_claude="Claude APIキーを今すぐ設定しますか？ (y/n): "

        if /i "!setup_claude!"=="y" (
            echo.
            set /p claude_key="APIキーを入力してください: "
            if not "!claude_key!"=="" (
                setx ANTHROPIC_API_KEY "!claude_key!" >nul
                echo [OK] Claude APIキーを設定しました
            )
        ) else (
            echo.
            echo 後で設定する場合は、環境変数に以下を設定してください：
            echo   変数名: ANTHROPIC_API_KEY
            echo   値: あなたのAPIキー
        )
    )

    :: OpenAI API Key
    if %INSTALL_CODEX%==1 (
        echo.
        echo 【Codex CLI】
        echo APIキー取得先: https://platform.openai.com/
        echo.
        set /p setup_openai="OpenAI APIキーを今すぐ設定しますか？ (y/n): "

        if /i "!setup_openai!"=="y" (
            echo.
            set /p openai_key="APIキーを入力してください: "
            if not "!openai_key!"=="" (
                setx OPENAI_API_KEY "!openai_key!" >nul
                echo [OK] OpenAI APIキーを設定しました
            )
        ) else (
            echo.
            echo 後で設定する場合は、環境変数に以下を設定してください：
            echo   変数名: OPENAI_API_KEY
            echo   値: あなたのAPIキー
        )
    )

    :: Google API Key
    if %INSTALL_GEMINI%==1 (
        echo.
        echo 【Gemini CLI】
        echo APIキー取得先: https://aistudio.google.com/
        echo ※ 初回起動時にGoogleログインで認証する方法もあります
        echo.
        set /p setup_google="Google APIキーを今すぐ設定しますか？ (y/n): "

        if /i "!setup_google!"=="y" (
            echo.
            set /p google_key="APIキーを入力してください: "
            if not "!google_key!"=="" (
                setx GOOGLE_API_KEY "!google_key!" >nul
                echo [OK] Google APIキーを設定しました
            )
        ) else (
            echo.
            echo 後で設定する場合は、環境変数に以下を設定してください：
            echo   変数名: GOOGLE_API_KEY
            echo   値: あなたのAPIキー
        )
    )

    goto :eof

:: ============================================================
:: 完了画面
:: ============================================================
:show_completion
    call :print_header

    echo 🎉 インストールが完了しました！ 🎉
    echo.
    echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo.
    echo 【使い方】
    echo.
    echo   デスクトップに作成されたショートカットを
    echo   ダブルクリックするだけで起動できます！
    echo.

    if %INSTALL_CLAUDE%==1 echo   🟣 Claude Code.bat → Claude Code CLI が起動
    if %INSTALL_CODEX%==1 echo   🟢 Codex CLI.bat → Codex CLI が起動
    if %INSTALL_GEMINI%==1 echo   🔵 Gemini CLI.bat → Gemini CLI が起動

    echo.
    echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo.
    echo 【APIキーについて】
    echo.
    echo   各サービスを使うにはAPIキーが必要です。
    echo   設定していない場合は、各サービスのサイトで
    echo   APIキーを取得してください。
    echo.
    echo   Claude: https://console.anthropic.com/
    echo   OpenAI: https://platform.openai.com/
    echo   Gemini: https://aistudio.google.com/
    echo.
    echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo.
    echo ※ 環境変数を反映するため、PCを再起動することをお勧めします。
    echo.

    pause
    goto :eof
