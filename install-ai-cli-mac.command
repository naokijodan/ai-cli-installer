#!/bin/bash
# ============================================================
#  AI CLI 統合インストーラー for Mac
#  Claude Code / Codex CLI / Gemini CLI を簡単インストール
# ============================================================

# 色の定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# グローバル変数
INSTALL_CLAUDE=false
INSTALL_CODEX=false
INSTALL_GEMINI=false

# ============================================================
# ユーティリティ関数
# ============================================================

print_header() {
    clear
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                        ║${NC}"
    echo -e "${CYAN}║${NC}      ${YELLOW}🤖 AI CLI 統合インストーラー for Mac 🤖${NC}         ${CYAN}║${NC}"
    echo -e "${CYAN}║                                                        ║${NC}"
    echo -e "${CYAN}║${NC}   Claude Code / Codex CLI / Gemini CLI              ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}   を簡単にインストールできます                      ${CYAN}║${NC}"
    echo -e "${CYAN}║                                                        ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_step() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}📌 $1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

press_enter() {
    echo ""
    read -p "Enterキーを押して続行..." _ < /dev/tty
}

# ============================================================
# インストール確認関数
# ============================================================

check_homebrew() {
    if command -v brew &> /dev/null; then
        return 0
    else
        return 1
    fi
}

check_node() {
    if command -v node &> /dev/null; then
        return 0
    else
        return 1
    fi
}

check_npm() {
    if command -v npm &> /dev/null; then
        return 0
    else
        return 1
    fi
}

check_claude() {
    if command -v claude &> /dev/null || [ -f "$HOME/.npm-global/bin/claude" ]; then
        return 0
    else
        return 1
    fi
}

check_codex() {
    if command -v codex &> /dev/null || [ -f "$HOME/.npm-global/bin/codex" ]; then
        return 0
    else
        return 1
    fi
}

check_gemini() {
    if command -v gemini &> /dev/null || [ -f "$HOME/.npm-global/bin/gemini" ]; then
        return 0
    else
        return 1
    fi
}

# ============================================================
# インストール関数
# ============================================================

install_homebrew() {
    print_step "Homebrew をインストール中..."

    echo "Homebrewはmacのパッケージ管理ツールです。"
    echo "インストール中にパスワードを求められる場合があります。"
    echo ""

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/tty

    # Apple Silicon Mac の場合のPATH設定
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    if check_homebrew; then
        print_success "Homebrew のインストールが完了しました"
    else
        print_error "Homebrew のインストールに失敗しました"
        exit 1
    fi
}

install_node() {
    print_step "Node.js をインストール中..."

    brew install node

    if check_node && check_npm; then
        print_success "Node.js のインストールが完了しました"
        echo "  Node.js: $(node --version)"
        echo "  npm: $(npm --version)"
    else
        print_error "Node.js のインストールに失敗しました"
        exit 1
    fi
}

setup_npm_global() {
    print_step "npm のグローバル設定中..."

    # グローバルインストール用ディレクトリを作成
    mkdir -p ~/.npm-global
    npm config set prefix '~/.npm-global'

    # PATHに追加（まだ追加されていない場合）
    if ! grep -q 'npm-global/bin' ~/.zshrc 2>/dev/null; then
        echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.zshrc
    fi
    if ! grep -q 'npm-global/bin' ~/.bash_profile 2>/dev/null; then
        echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bash_profile
    fi

    # 現在のセッションにも適用
    export PATH=~/.npm-global/bin:$PATH

    print_success "npm グローバル設定が完了しました"
}

install_claude_cli() {
    print_step "Claude Code CLI をインストール中..."

    npm install -g @anthropic-ai/claude-code

    if check_claude; then
        print_success "Claude Code CLI のインストールが完了しました"
    else
        print_error "Claude Code CLI のインストールに失敗しました"
    fi
}

install_codex_cli() {
    print_step "Codex CLI をインストール中..."

    npm install -g @openai/codex

    if check_codex; then
        print_success "Codex CLI のインストールが完了しました"
    else
        print_error "Codex CLI のインストールに失敗しました"
    fi
}

install_gemini_cli() {
    print_step "Gemini CLI をインストール中..."

    npm install -g @anthropic-ai/claude-code  # 仮。実際のパッケージ名に要修正
    npm install -g @google/gemini-cli

    if check_gemini; then
        print_success "Gemini CLI のインストールが完了しました"
    else
        print_error "Gemini CLI のインストールに失敗しました"
    fi
}

# ============================================================
# ショートカット作成関数
# ============================================================

create_shortcuts() {
    print_step "デスクトップにショートカットを作成中..."

    DESKTOP="$HOME/Desktop"
    NPM_BIN="$HOME/.npm-global/bin"

    # Claude Code ショートカット
    if $INSTALL_CLAUDE && check_claude; then
        cat > "$DESKTOP/Claude Code.command" << 'SCRIPT'
#!/bin/bash
cd ~
export PATH=~/.npm-global/bin:$PATH
~/.npm-global/bin/claude
SCRIPT
        chmod +x "$DESKTOP/Claude Code.command"
        print_success "Claude Code.command を作成しました"
    fi

    # Codex CLI ショートカット
    if $INSTALL_CODEX && check_codex; then
        cat > "$DESKTOP/Codex CLI.command" << 'SCRIPT'
#!/bin/bash
cd ~
export PATH=~/.npm-global/bin:$PATH
~/.npm-global/bin/codex
SCRIPT
        chmod +x "$DESKTOP/Codex CLI.command"
        print_success "Codex CLI.command を作成しました"
    fi

    # Gemini CLI ショートカット
    if $INSTALL_GEMINI && check_gemini; then
        cat > "$DESKTOP/Gemini CLI.command" << 'SCRIPT'
#!/bin/bash
cd ~
export PATH=~/.npm-global/bin:$PATH
~/.npm-global/bin/gemini
SCRIPT
        chmod +x "$DESKTOP/Gemini CLI.command"
        print_success "Gemini CLI.command を作成しました"
    fi
}

# ============================================================
# APIキー設定関数
# ============================================================

setup_api_keys() {
    print_step "APIキーの設定"

    echo "各AIサービスを使用するにはAPIキーが必要です。"
    echo "今すぐ設定するか、後で設定するか選択してください。"
    echo ""

    # Claude API Key
    if $INSTALL_CLAUDE; then
        echo ""
        echo -e "${YELLOW}【Claude Code】${NC}"
        echo "APIキー取得先: https://console.anthropic.com/"
        echo ""
        read -p "Claude APIキーを今すぐ設定しますか？ (y/n): " setup_claude < /dev/tty

        if [[ "$setup_claude" == "y" || "$setup_claude" == "Y" ]]; then
            echo ""
            read -p "APIキーを入力してください: " claude_key < /dev/tty
            if [[ -n "$claude_key" ]]; then
                # .zshrc と .bash_profile に追加
                echo "export ANTHROPIC_API_KEY=\"$claude_key\"" >> ~/.zshrc
                echo "export ANTHROPIC_API_KEY=\"$claude_key\"" >> ~/.bash_profile
                export ANTHROPIC_API_KEY="$claude_key"
                print_success "Claude APIキーを設定しました"
            fi
        else
            echo ""
            echo "後で設定する場合は、ターミナルで以下を実行してください："
            echo -e "${CYAN}export ANTHROPIC_API_KEY=\"your-api-key\"${NC}"
        fi
    fi

    # OpenAI API Key
    if $INSTALL_CODEX; then
        echo ""
        echo -e "${YELLOW}【Codex CLI】${NC}"
        echo "APIキー取得先: https://platform.openai.com/"
        echo ""
        read -p "OpenAI APIキーを今すぐ設定しますか？ (y/n): " setup_openai < /dev/tty

        if [[ "$setup_openai" == "y" || "$setup_openai" == "Y" ]]; then
            echo ""
            read -p "APIキーを入力してください: " openai_key < /dev/tty
            if [[ -n "$openai_key" ]]; then
                echo "export OPENAI_API_KEY=\"$openai_key\"" >> ~/.zshrc
                echo "export OPENAI_API_KEY=\"$openai_key\"" >> ~/.bash_profile
                export OPENAI_API_KEY="$openai_key"
                print_success "OpenAI APIキーを設定しました"
            fi
        else
            echo ""
            echo "後で設定する場合は、ターミナルで以下を実行してください："
            echo -e "${CYAN}export OPENAI_API_KEY=\"your-api-key\"${NC}"
        fi
    fi

    # Google API Key
    if $INSTALL_GEMINI; then
        echo ""
        echo -e "${YELLOW}【Gemini CLI】${NC}"
        echo "APIキー取得先: https://aistudio.google.com/"
        echo "※ 初回起動時にGoogleログインで認証する方法もあります"
        echo ""
        read -p "Google APIキーを今すぐ設定しますか？ (y/n): " setup_google < /dev/tty

        if [[ "$setup_google" == "y" || "$setup_google" == "Y" ]]; then
            echo ""
            read -p "APIキーを入力してください: " google_key < /dev/tty
            if [[ -n "$google_key" ]]; then
                echo "export GOOGLE_API_KEY=\"$google_key\"" >> ~/.zshrc
                echo "export GOOGLE_API_KEY=\"$google_key\"" >> ~/.bash_profile
                export GOOGLE_API_KEY="$google_key"
                print_success "Google APIキーを設定しました"
            fi
        else
            echo ""
            echo "後で設定する場合は、ターミナルで以下を実行してください："
            echo -e "${CYAN}export GOOGLE_API_KEY=\"your-api-key\"${NC}"
        fi
    fi
}

# ============================================================
# メニュー表示
# ============================================================

show_menu() {
    print_header

    echo "インストールするAI CLIを選択してください："
    echo ""
    echo -e "  ${CYAN}[1]${NC} Claude Code CLI のみ"
    echo -e "  ${CYAN}[2]${NC} Codex CLI (OpenAI) のみ"
    echo -e "  ${CYAN}[3]${NC} Gemini CLI のみ"
    echo -e "  ${CYAN}[4]${NC} 全部インストール（おすすめ）"
    echo -e "  ${CYAN}[5]${NC} 終了"
    echo ""

    read -p "番号を入力してください (1-5): " choice < /dev/tty

    case $choice in
        1)
            INSTALL_CLAUDE=true
            ;;
        2)
            INSTALL_CODEX=true
            ;;
        3)
            INSTALL_GEMINI=true
            ;;
        4)
            INSTALL_CLAUDE=true
            INSTALL_CODEX=true
            INSTALL_GEMINI=true
            ;;
        5)
            echo ""
            echo "インストーラーを終了します。"
            exit 0
            ;;
        *)
            print_error "無効な選択です。1-5の番号を入力してください。"
            press_enter
            show_menu
            return
            ;;
    esac
}

# ============================================================
# 現在の状態を表示
# ============================================================

show_current_status() {
    print_step "現在の環境をチェック中..."

    echo "【インストール状況】"
    echo ""

    if check_homebrew; then
        print_success "Homebrew: インストール済み"
    else
        print_warning "Homebrew: 未インストール → インストールします"
    fi

    if check_node; then
        print_success "Node.js: インストール済み ($(node --version))"
    else
        print_warning "Node.js: 未インストール → インストールします"
    fi

    if check_claude; then
        print_success "Claude Code CLI: インストール済み"
    else
        echo -e "  Claude Code CLI: 未インストール"
    fi

    if check_codex; then
        print_success "Codex CLI: インストール済み"
    else
        echo -e "  Codex CLI: 未インストール"
    fi

    if check_gemini; then
        print_success "Gemini CLI: インストール済み"
    else
        echo -e "  Gemini CLI: 未インストール"
    fi

    echo ""
}

# ============================================================
# インストール完了画面
# ============================================================

show_completion() {
    print_header

    echo -e "${GREEN}🎉 インストールが完了しました！ 🎉${NC}"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "【使い方】"
    echo ""
    echo "  デスクトップに作成されたショートカットを"
    echo "  ダブルクリックするだけで起動できます！"
    echo ""

    if $INSTALL_CLAUDE; then
        echo -e "  🟣 ${CYAN}Claude Code.command${NC} → Claude Code CLI が起動"
    fi
    if $INSTALL_CODEX; then
        echo -e "  🟢 ${CYAN}Codex CLI.command${NC} → Codex CLI が起動"
    fi
    if $INSTALL_GEMINI; then
        echo -e "  🔵 ${CYAN}Gemini CLI.command${NC} → Gemini CLI が起動"
    fi

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "【APIキーについて】"
    echo ""
    echo "  各サービスを使うにはAPIキーが必要です。"
    echo "  設定していない場合は、各サービスのサイトで"
    echo "  APIキーを取得してください。"
    echo ""
    echo "  Claude: https://console.anthropic.com/"
    echo "  OpenAI: https://platform.openai.com/"
    echo "  Gemini: https://aistudio.google.com/"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    press_enter
}

# ============================================================
# メイン処理
# ============================================================

main() {
    # ホームディレクトリに移動
    cd ~

    # ヘッダー表示
    print_header

    echo "このインストーラーは、AI CLI ツールを"
    echo "簡単にインストールするためのものです。"
    echo ""
    echo "以下のツールをインストールできます："
    echo "  • Claude Code CLI (Anthropic)"
    echo "  • Codex CLI (OpenAI)"
    echo "  • Gemini CLI (Google)"
    echo ""

    press_enter

    # 現在の状態を表示
    show_current_status
    press_enter

    # メニュー表示
    show_menu

    # 確認
    echo ""
    echo "以下をインストールします："
    $INSTALL_CLAUDE && echo "  • Claude Code CLI"
    $INSTALL_CODEX && echo "  • Codex CLI"
    $INSTALL_GEMINI && echo "  • Gemini CLI"
    echo ""
    read -p "続行しますか？ (y/n): " confirm < /dev/tty

    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "インストールをキャンセルしました。"
        exit 0
    fi

    # Homebrew のインストール
    if ! check_homebrew; then
        install_homebrew
    else
        print_success "Homebrew は既にインストールされています"
    fi

    # Node.js のインストール
    if ! check_node; then
        install_node
    else
        print_success "Node.js は既にインストールされています"
    fi

    # npm グローバル設定
    setup_npm_global

    # 各CLI のインストール
    if $INSTALL_CLAUDE && ! check_claude; then
        install_claude_cli
    elif $INSTALL_CLAUDE; then
        print_success "Claude Code CLI は既にインストールされています"
    fi

    if $INSTALL_CODEX && ! check_codex; then
        install_codex_cli
    elif $INSTALL_CODEX; then
        print_success "Codex CLI は既にインストールされています"
    fi

    if $INSTALL_GEMINI && ! check_gemini; then
        install_gemini_cli
    elif $INSTALL_GEMINI; then
        print_success "Gemini CLI は既にインストールされています"
    fi

    # ショートカット作成
    create_shortcuts

    # APIキー設定
    setup_api_keys

    # 完了画面
    show_completion
}

# スクリプト実行
main
