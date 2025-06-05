# Ghostcleaner 👻🧹

> 誰を呼ぶ？ **Ghostcleaner!**

AI支援コーディングセッション後、コードベースに憑りついたゴーストファイルを退治するスマートクリーンアップツール。

[English](README.md) | 日本語

## 問題

Claude、GitHub Copilot、CursorなどのAIペアプログラミングツールにより、開発者は以前の10倍の速さでファイルを作成するようになりました：

- `project-v1`、`project-v2`、`project-v3`... `project-final-final-本当に最終`
- 高速プロトタイピングによる複数の`node_modules`フォルダ
- 数ヶ月ではなく数日でディスクスペースが満杯に
- 古いビルド成果物がかつてないスピードで蓄積

## 機能

- **スマートバージョン検出**: バージョン管理されたプロジェクトを自動検出し、最新版のみを保持
- **Git連携**: 削除前にコミット済みかチェック
- **安全なデフォルト設定**: アクティブに使用中のプロジェクトは削除しません
- **ドライランモード**: 削除前に何が削除されるかプレビュー
- **言語非依存**: Node.js、Python、Go、Rustなどに対応

## インストール

### クイックインストール（推奨）

```bash
# ワンラインインストール
curl -sSL https://raw.githubusercontent.com/daiokawa/ghostcleaner/main/scripts/install-one-liner.sh | bash

# またはwgetで
wget -qO- https://raw.githubusercontent.com/daiokawa/ghostcleaner/main/scripts/install-one-liner.sh | bash
```

### パッケージマネージャー

```bash
# Homebrew (macOS/Linux)
brew install ghostcleaner

# npm (クロスプラットフォーム)
npm install -g ghostcleaner

# pip (クロスプラットフォーム)
pip install ghostcleaner
```

### 手動インストール

```bash
# スクリプトをダウンロード
curl -sSL https://raw.githubusercontent.com/daiokawa/ghostcleaner/main/ghostcleaner.sh -o ghostcleaner

# 実行可能にする
chmod +x ghostcleaner

# PATHに移動
sudo mv ghostcleaner /usr/local/bin/
```

### ソースからインストール

```bash
git clone https://github.com/daiokawa/ghostcleaner.git
cd ghostcleaner
./install.sh
```

## 使い方

```bash
# 削除されるものをプレビュー（最初にこれを実行することを推奨）
ghostcleaner --dry-run

# 基本的なクリーンアップを実行（古いキャッシュとビルド成果物を削除）
ghostcleaner

# アグレッシブモード（古いプロジェクトバージョンも削除）
ghostcleaner --aggressive

# カスタム設定を使用
ghostcleaner --config ~/.cleanerrc
```

## 何が削除されるか

### 常に削除（セーフモード）
- パッケージマネージャーのキャッシュ（npm、pip、Homebrew）
- 60日以上前のビルド成果物（`.next`、`dist`、`build`）
- 90日以上アクセスされていない`node_modules`フォルダ
- 空のディレクトリ

### アグレッシブモードのみ
- バージョン管理されたプロジェクトの古いバージョン（最新版を保持）
- 以下のような名前のプロジェクト：
  - `project-v1`、`project-v2` → 最新版を保持
  - `project-2024-06-01` → 最新の日付を保持
  - `my-app-backup`、`my-app-old` → `my-app`を保持

## 設定

ホームディレクトリに`.cleanerrc`ファイルを作成：

```yaml
# スキャンするディレクトリ（デフォルト: Desktop、Downloads、~）
scan_dirs:
  - ~/Desktop
  - ~/Downloads
  - ~/projects

# 常に無視するパターン
ignore:
  - "*.important"
  - "archive/*"

# ファイルを「古い」と判断するまでの日数
thresholds:
  node_modules: 90
  build_artifacts: 60
  
# 追加のビルドディレクトリ名
build_dirs:
  - out
  - .parcel-cache
  - __pycache__
```

## 安全機能

- 最近アクセスされたファイルは削除しません
- 各プロジェクトの最新バージョンを保持
- 依存関係を削除する前に親プロジェクトのアクティビティをチェック
- 初回ユーザーにはデフォルトでドライランモード
- リカバリー用のクリーンアップログを作成

## 言語サポート

現在、ツールはデフォルトで日本語のメッセージを表示します。英語のメッセージを使用するには：
```bash
export LANG=en_US.UTF-8
ghostcleaner --dry-run
```

完全な国際化サポートは将来のバージョンで予定されています。

## 貢献

以下の貢献を歓迎します：
- より多くのビルドツールと言語のサポート
- より安全なクリーニングのためのGit統合
- クロスプラットフォームサポート（Windows、Linux）
- より賢いバージョン検出アルゴリズム
- 国際化の改善

## ライセンス

MIT

## 謝辞

非常に現代的な問題を解決するために作られました：AIのおかげで開発が速すぎて、ディスクが追いつかない！ 🚀

---

**警告**: 必ず最初に`--dry-run`を使用し、重要な作業のバックアップがあることを確認してください。