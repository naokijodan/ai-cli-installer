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
    elif [ -f /opt/homebrew/bin/brew ]; then
        return 0
    elif [ -f /usr/local/bin/brew ]; then
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
    print_step "Homebrew が必要です"

    echo "Homebrewはmacのパッケージ管理ツールです。"
    echo "このインストーラーを使う前に、Homebrewを先にインストールしてください。"
    echo ""
    echo -e "${YELLOW}【手順】${NC}"
    echo ""
    echo "  1. 以下のコマンドをコピーしてターミナルに貼り付けて実行："
    echo ""
    echo -e "     ${CYAN}/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"${NC}"
    echo ""
    echo "  2. Homebrewのインストールが完了したら、このインストーラーを再度実行してください。"
    echo ""
    exit 1
}

install_node() {
    print_step "Node.js が必要です"

    echo "Node.jsはJavaScript実行環境です。"
    echo "このインストーラーを使う前に、Node.jsを先にインストールしてください。"
    echo ""
    echo -e "${YELLOW}【手順】${NC}"
    echo ""
    echo "  ターミナルで以下のコマンドを実行："
    echo ""
    echo -e "     ${CYAN}brew install node${NC}"
    echo ""
    echo "  完了したら、このインストーラーを再度実行してください。"
    echo ""
    exit 1
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
    print_step "ログイン方法について"

    echo "各AI CLIは、初回起動時にブラウザでログインするだけで使えます。"
    echo ""

    if $INSTALL_CLAUDE; then
        echo -e "  🟣 ${YELLOW}Claude Code${NC}"
        echo "     → 起動すると自動的にブラウザが開きます"
        echo "     → Anthropicアカウントでログインしてください"
        echo "     → Claude Pro（\$20/月）またはMax（\$100/月）のサブスクが必要です"
        echo ""
    fi

    if $INSTALL_CODEX; then
        echo -e "  🟢 ${YELLOW}Codex CLI${NC}"
        echo "     → 起動すると自動的にブラウザが開きます"
        echo "     → ChatGPTアカウントでログインしてください"
        echo "     → 現在は無料プランでも利用可能です"
        echo ""
    fi

    if $INSTALL_GEMINI; then
        echo -e "  🔵 ${YELLOW}Gemini CLI${NC}"
        echo "     → 起動すると自動的にブラウザが開きます"
        echo "     → Googleアカウントでログインしてください"
        echo "     → 無料で利用できます"
        echo ""
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
    echo "【ログインについて】"
    echo ""
    echo "  各CLIは初回起動時にブラウザが開きます。"
    echo "  画面の指示に従ってログインしてください。"
    echo ""
    echo "  Claude: Anthropicアカウント（Pro/Maxサブスク必要）"
    echo "  Codex:  ChatGPTアカウント（無料プランでも利用可）"
    echo "  Gemini: Googleアカウント（無料）"
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

    # Homebrewのパスを自動検出して設定
    if [ -f /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

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
