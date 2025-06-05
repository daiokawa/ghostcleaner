#!/bin/bash

# Ghostcleaner定期実行セットアップスクリプト

echo "👻 Ghostcleaner定期実行セットアップ"
echo "=================================="

# デフォルト設定
GHOSTCLEANER_PATH="$(which ghostcleaner || echo "/usr/local/bin/ghostcleaner")"
SCHEDULE="weekly"  # weekly, daily, monthly
MODE="notify"      # notify, clean, aggressive

# オプション選択
echo "
1. 実行頻度を選択してください:
   1) 毎週（推奨）
   2) 毎日
   3) 毎月
"
read -p "選択 [1-3]: " freq_choice

case $freq_choice in
    1) SCHEDULE="weekly" ;;
    2) SCHEDULE="daily" ;;
    3) SCHEDULE="monthly" ;;
    *) SCHEDULE="weekly" ;;
esac

echo "
2. 動作モードを選択してください:
   1) 通知のみ（推奨） - ドライランで結果を通知
   2) 安全モード - キャッシュとnode_modulesのみ削除
   3) アグレッシブ - 古いバージョンも削除（非推奨）
"
read -p "選択 [1-3]: " mode_choice

case $mode_choice in
    1) MODE="notify" ;;
    2) MODE="clean" ;;
    3) MODE="aggressive" ;;
    *) MODE="notify" ;;
esac

# cron用のスクリプト作成
CRON_SCRIPT="$HOME/.ghostcleaner-cron.sh"
cat > "$CRON_SCRIPT" << 'EOF'
#!/bin/bash

# Ghostcleaner定期実行スクリプト
export PATH="/usr/local/bin:$PATH"
GHOSTCLEANER="__GHOSTCLEANER_PATH__"
MODE="__MODE__"
LOG_FILE="$HOME/.ghostcleaner-cron.log"

echo "========================================" >> "$LOG_FILE"
echo "Ghostcleaner実行: $(date)" >> "$LOG_FILE"

case "$MODE" in
    notify)
        # ドライラン結果を取得
        RESULT=$("$GHOSTCLEANER" --dry-run 2>&1)
        FREED=$(echo "$RESULT" | grep "削除可能な容量" | cut -d: -f2)
        
        if [[ "$FREED" =~ [1-9] ]]; then
            # macOS通知
            osascript -e "display notification \"削除可能: $FREED\" with title \"👻 Ghostcleaner\" subtitle \"ゴーストファイルが見つかりました\""
            
            # ログに記録
            echo "削除可能な容量: $FREED" >> "$LOG_FILE"
        fi
        ;;
        
    clean)
        # 安全モードで実行
        "$GHOSTCLEANER" >> "$LOG_FILE" 2>&1
        
        # 結果を通知
        FREED=$(tail -20 "$LOG_FILE" | grep "解放した容量" | tail -1 | cut -d: -f2)
        if [ -n "$FREED" ]; then
            osascript -e "display notification \"解放済み: $FREED\" with title \"👻 Ghostcleaner\" subtitle \"ゴースト退治完了！\""
        fi
        ;;
        
    aggressive)
        # アグレッシブモードで実行（注意！）
        "$GHOSTCLEANER" --aggressive >> "$LOG_FILE" 2>&1
        ;;
esac
EOF

# 変数を置換
sed -i '' "s|__GHOSTCLEANER_PATH__|$GHOSTCLEANER_PATH|g" "$CRON_SCRIPT"
sed -i '' "s|__MODE__|$MODE|g" "$CRON_SCRIPT"
chmod +x "$CRON_SCRIPT"

# crontab設定
echo "
3. crontabに追加しています..."

# 現在のcrontabを取得
crontab -l 2>/dev/null > /tmp/current_cron || true

# Ghostcleanerのエントリを削除（重複防止）
grep -v "ghostcleaner-cron.sh" /tmp/current_cron > /tmp/new_cron || true

# 新しいエントリを追加
case $SCHEDULE in
    daily)
        echo "0 9 * * * $CRON_SCRIPT" >> /tmp/new_cron
        echo "✅ 毎日午前9時に実行"
        ;;
    weekly)
        echo "0 9 * * 1 $CRON_SCRIPT" >> /tmp/new_cron
        echo "✅ 毎週月曜日午前9時に実行"
        ;;
    monthly)
        echo "0 9 1 * * $CRON_SCRIPT" >> /tmp/new_cron
        echo "✅ 毎月1日午前9時に実行"
        ;;
esac

# crontabを更新
crontab /tmp/new_cron
rm -f /tmp/current_cron /tmp/new_cron

echo "
👻 セットアップ完了！

設定内容:
- 実行頻度: $SCHEDULE
- モード: $MODE
- スクリプト: $CRON_SCRIPT
- ログ: $HOME/.ghostcleaner-cron.log

変更する場合:
- crontab -e で編集
- このスクリプトを再実行

無効にする場合:
- crontab -e で該当行を削除
"