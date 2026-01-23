# AI CLI 統合インストーラー

Claude Code、Codex CLI、Gemini CLI を **ダウンロードしてダブルクリックするだけ** で簡単にインストールできるツールです。

## 🎯 こんな人におすすめ

- ターミナルやコマンドプロンプトが苦手
- AI CLIツールを使いたいけど、インストール方法がわからない
- 環境構築に時間をかけたくない

## ✨ 特徴

- **完全自動**: 必要なもの（Node.js等）も自動でインストール
- **初心者向け**: ダウンロード → ダブルクリック の2ステップ
- **ショートカット作成**: デスクトップにショートカットを自動生成

## 📥 ダウンロード

### Mac をお使いの方

1. [**install-ai-cli-mac.command**](./install-ai-cli-mac.command) をダウンロード
2. ダウンロードしたファイルをダブルクリック
3. 画面の指示に従う

> ⚠️ 「開発元を確認できません」と表示された場合：
> 1. 「システム設定」→「プライバシーとセキュリティ」を開く
> 2. 「このまま開く」をクリック

### Windows をお使いの方

1. [**install-ai-cli-windows.bat**](./install-ai-cli-windows.bat) をダウンロード
2. ダウンロードしたファイルを **右クリック** →「**管理者として実行**」
3. 画面の指示に従う

> ⚠️ 「WindowsによってPCが保護されました」と表示された場合：
> 1. 「詳細情報」をクリック
> 2. 「実行」をクリック

## 🚀 使い方

### インストール完了後

デスクトップに作成されたショートカットをダブルクリックするだけ！

| ショートカット | 起動するもの |
|-------------|-----------|
| 🟣 Claude Code.command (Mac) / Claude Code.bat (Win) | Claude Code CLI |
| 🟢 Codex CLI.command (Mac) / Codex CLI.bat (Win) | Codex CLI |
| 🔵 Gemini CLI.command (Mac) / Gemini CLI.bat (Win) | Gemini CLI |

## 🔑 APIキーについて

各AI CLIを使うにはAPIキーが必要です。インストーラー内で設定できますが、後から設定することもできます。

| サービス | APIキー取得先 |
|---------|------------|
| Claude Code | [https://console.anthropic.com/](https://console.anthropic.com/) |
| Codex CLI | [https://platform.openai.com/](https://platform.openai.com/) |
| Gemini CLI | [https://aistudio.google.com/](https://aistudio.google.com/) |

### APIキーを後から設定する方法

**Mac の場合:**
```bash
# ターミナルで実行
export ANTHROPIC_API_KEY="your-api-key"  # Claude
export OPENAI_API_KEY="your-api-key"     # Codex
export GOOGLE_API_KEY="your-api-key"     # Gemini
```

**Windows の場合:**
1. 「スタート」→「設定」→「システム」→「詳細情報」→「システムの詳細設定」
2. 「環境変数」をクリック
3. 「新規」で以下を追加：
   - 変数名: `ANTHROPIC_API_KEY` / 値: あなたのAPIキー
   - 変数名: `OPENAI_API_KEY` / 値: あなたのAPIキー
   - 変数名: `GOOGLE_API_KEY` / 値: あなたのAPIキー

## ❓ よくある質問

### Q: インストールに失敗しました

**A:** 以下を確認してください：
- Mac: インターネット接続があるか確認
- Windows: 「管理者として実行」しているか確認
- セキュリティソフトがブロックしていないか確認

### Q: ショートカットをダブルクリックしても何も起きない

**A:**
- Mac: ターミナルを開いて `chmod +x ~/Desktop/Claude\ Code.command` を実行
- Windows: PCを再起動して環境変数を反映させる

### Q: APIキーはどこで取得できますか？

**A:** 各サービスの公式サイトでアカウントを作成し、APIキーを発行してください（上の表を参照）。

## 📋 動作環境

- **Mac**: macOS 10.15 (Catalina) 以降
- **Windows**: Windows 10 以降（winget が使える環境）

## 🛠️ インストールされるもの

このインストーラーは以下をインストールします：

| ツール | 説明 |
|-------|------|
| Homebrew (Mac のみ) | パッケージマネージャー |
| Node.js | JavaScript実行環境 |
| Claude Code CLI | Anthropic の AI コーディングアシスタント |
| Codex CLI | OpenAI の AI コーディングアシスタント |
| Gemini CLI | Google の AI コーディングアシスタント |

## 📝 ライセンス

MIT License

## 🤝 貢献

バグ報告や機能リクエストは [Issues](../../issues) からお願いします。
