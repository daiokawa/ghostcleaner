#!/bin/bash

# Ghostcleaner - Bust the ghost files haunting your codebase
# Version: 1.1.0
# Usage: ghostcleaner [--dry-run] [--aggressive] [--config FILE]

# Default settings
VERSION="1.1.0"
DRY_RUN=false
AGGRESSIVE=false
CONFIG_FILE="$HOME/.ghostcleanerrc"
LOG_FILE="$HOME/.ghostcleaner.log"
QUIET=false
GIT_CHECK=true

# Detect language from environment
LANG_CODE="${LANG:-en_US}"
if [[ "$LANG_CODE" =~ ^ja ]]; then
    LANGUAGE="ja"
elif [[ "$LANG_CODE" =~ ^en ]]; then
    LANGUAGE="en"
else
    LANGUAGE="en"
fi

# Language strings - using functions for bash 3.2 compatibility
msg() {
    local key=$1
    if [ "$LANGUAGE" = "ja" ]; then
        case $key in
            CLEANUP_START) echo "=== 開発環境クリーンアップ開始 ===" ;;
            CLEANUP_COMPLETE) echo "=== クリーンアップ完了 ===" ;;
            CACHE_SECTION) echo "パッケージマネージャーのキャッシュ" ;;
            OLD_DEPS) echo "長期間アクセスされていない依存関係" ;;
            OLD_VERSIONS) echo "バージョン管理されたプロジェクトの古いバージョン" ;;
            EMPTY_DIRS) echo "空のプロジェクトディレクトリ" ;;
            NPM_CACHE) echo "npm キャッシュ" ;;
            PIP_CACHE) echo "pip キャッシュ" ;;
            BREW_CACHE) echo "Homebrew ダウンロード" ;;
            WOULD_DELETE) echo "削除予定" ;;
            DELETING) echo "削除中" ;;
            SKIPPING) echo "スキップ" ;;
            UNCOMMITTED) echo "コミットされていない変更があります" ;;
            UNTRACKED) echo "追跡されていないファイルがあります" ;;
            KEEP_LATEST) echo "保持: 最新バージョン" ;;
            OLD_VERSION) echo "古いバージョン" ;;
            EMPTY_DIR) echo "空のディレクトリ" ;;
            FREED_SPACE) echo "解放した容量" ;;
            DELETABLE_SPACE) echo "削除可能な容量" ;;
            DISK_USAGE) echo "現在のディスク使用状況" ;;
            DRY_RUN_NOTE) echo "実際に削除するには、--dry-run オプションを外して実行してください" ;;
            CHECKING_VERSIONS) echo "バージョン管理されたプロジェクトをチェック中" ;;
            ANALYZING) echo "のバージョンを分析中..." ;;
            *) echo "$key" ;;
        esac
    else
        case $key in
            CLEANUP_START) echo "=== Starting AI Dev Cleanup ===" ;;
            CLEANUP_COMPLETE) echo "=== Cleanup Complete ===" ;;
            CACHE_SECTION) echo "Package Manager Caches" ;;
            OLD_DEPS) echo "Old Dependencies" ;;
            OLD_VERSIONS) echo "Old Project Versions" ;;
            EMPTY_DIRS) echo "Empty Directories" ;;
            NPM_CACHE) echo "npm cache" ;;
            PIP_CACHE) echo "pip cache" ;;
            BREW_CACHE) echo "Homebrew downloads" ;;
            WOULD_DELETE) echo "Would delete" ;;
            DELETING) echo "Deleting" ;;
            SKIPPING) echo "Skipping" ;;
            UNCOMMITTED) echo "has uncommitted changes" ;;
            UNTRACKED) echo "has untracked files" ;;
            KEEP_LATEST) echo "Keeping: latest version" ;;
            OLD_VERSION) echo "old version" ;;
            EMPTY_DIR) echo "empty directory" ;;
            FREED_SPACE) echo "Freed space" ;;
            DELETABLE_SPACE) echo "Deletable space" ;;
            DISK_USAGE) echo "Current disk usage" ;;
            DRY_RUN_NOTE) echo "To actually delete, run without --dry-run option" ;;
            CHECKING_VERSIONS) echo "Checking versioned projects in" ;;
            ANALYZING) echo "versions..." ;;
            *) echo "$key" ;;
        esac
    fi
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run|-n)
            DRY_RUN=true
            shift
            ;;
        --aggressive|-a)
            AGGRESSIVE=true
            shift
            ;;
        --config|-c)
            CONFIG_FILE="$2"
            shift 2
            ;;
        --quiet|-q)
            QUIET=true
            shift
            ;;
        --no-git-check)
            GIT_CHECK=false
            shift
            ;;
        --lang|-l)
            LANGUAGE="$2"
            shift 2
            ;;
        --version|-v)
            echo "Ghostcleaner v$VERSION"
            exit 0
            ;;
        --help|-h)
            cat << EOF
Ghostcleaner v$VERSION 👻

Usage: $(basename $0) [OPTIONS]

Options:
  --dry-run, -n        Preview which ghosts will be busted
  --aggressive, -a     Bust old project versions too
  --config, -c FILE    Use custom config file (default: ~/.ghostcleanerrc)
  --quiet, -q          Suppress non-essential output
  --no-git-check       Skip git status checks
  --lang, -l LANG      Set language (en/ja, default: auto-detect)
  --version, -v        Show version information
  --help, -h           Show this help message

Examples:
  $(basename $0) --dry-run           # See what ghosts are haunting you
  $(basename $0) --aggressive        # Full ghost busting mode
  $(basename $0) -c my.config        # Use custom config

More info: https://github.com/daiokawa/ghostcleaner
EOF
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# 色付き出力
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Convert size to human-readable format
human_size() {
    local size=$1
    if [ $size -gt 1073741824 ]; then
        echo "$(echo "scale=2; $size/1073741824" | bc)GB"
    elif [ $size -gt 1048576 ]; then
        echo "$(echo "scale=2; $size/1048576" | bc)MB"
    else
        echo "$(echo "scale=2; $size/1024" | bc)KB"
    fi
}

# Check if directory is a git repository with uncommitted changes
check_git_status() {
    local dir=$1
    
    if [ "$GIT_CHECK" = false ]; then
        return 0
    fi
    
    if [ -d "$dir/.git" ]; then
        cd "$dir" 2>/dev/null || return 1
        
        # Check for uncommitted changes
        if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
            echo -e "${YELLOW}Warning: Uncommitted changes in $dir${NC}"
            return 1
        fi
        
        # Check for untracked files
        if [ -n "$(git ls-files --others --exclude-standard)" ]; then
            echo -e "${YELLOW}Warning: Untracked files in $dir${NC}"
            return 1
        fi
        
        cd - > /dev/null
    fi
    
    return 0
}

# Log operations
log_operation() {
    local message=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

# Remove item with safety checks
remove_item() {
    local path=$1
    local size=$2
    local desc=$3
    
    # Check if it's a project directory with uncommitted changes
    if [ -d "$path" ] && [ -d "$path/.git" ]; then
        if ! check_git_status "$path"; then
            echo -e "${RED}Skipping:${NC} $desc (has uncommitted changes)"
            return
        fi
    fi
    
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[DRY RUN]${NC} Would delete: $desc ($(human_size $size))"
        log_operation "[DRY RUN] Would delete: $path"
    else
        echo -e "${RED}Deleting:${NC} $desc ($(human_size $size))"
        rm -rf "$path"
        log_operation "Deleted: $path ($(human_size $size))"
    fi
}

# プロジェクトの最新バージョンを保持する関数
clean_versioned_projects() {
    local base_dir=$1
    
    echo -e "\n${BLUE}バージョン管理されたプロジェクトをチェック中: $base_dir${NC}"
    
    # 一時ファイルを使用してプロジェクトをグループ化
    local temp_file=$(mktemp)
    
    # 似た名前のプロジェクトを検索
    find "$base_dir" -maxdepth 1 -type d -print0 2>/dev/null | while IFS= read -r -d '' dir; do
        basename=$(basename "$dir")
        # バージョン番号や日付を除去してプロジェクト名を推測
        project_name=$(echo "$basename" | sed -E 's/[-_]?v?[0-9]+[-._]?[0-9]*[-._]?[0-9]*$//' | sed -E 's/[-_][0-9]{4}[-_]?[0-9]{2}[-_]?[0-9]{2}$//')
        
        if [ -z "$project_name" ] || [ "$project_name" = "$basename" ]; then
            continue
        fi
        
        # プロジェクト名と実際のパスを記録
        echo "$project_name|$dir" >> "$temp_file"
    done
    
    # 同じプロジェクト名でグループ化して処理
    sort "$temp_file" | awk -F'|' '{
        if ($1 == prev_name) {
            paths = paths ":" $2
        } else {
            if (prev_name != "" && paths ~ /:/) {
                print prev_name "|" paths
            }
            prev_name = $1
            paths = $2
        }
    } END {
        if (prev_name != "" && paths ~ /:/) {
            print prev_name "|" paths
        }
    }' | while IFS='|' read -r project_name paths; do
        echo -e "${GREEN}プロジェクト '$project_name' のバージョンを分析中...${NC}"
        
        # 各バージョンの最終更新時刻を取得してソート
        IFS=':' read -ra versions <<< "$paths"
        
        # 最新バージョンを見つける
        latest=""
        latest_time=0
        for version in "${versions[@]}"; do
            if [ -d "$version" ]; then
                mtime=$(stat -f "%m" "$version" 2>/dev/null || echo 0)
                if [ "$mtime" -gt "$latest_time" ]; then
                    latest_time=$mtime
                    latest=$version
                fi
            fi
        done
        
        # 最新以外を削除
        for version in "${versions[@]}"; do
            if [ -d "$version" ] && [ "$version" != "$latest" ]; then
                SIZE=$(du -sk "$version" 2>/dev/null | cut -f1)
                SIZE=$((SIZE * 1024))
                remove_item "$version" $SIZE "古いバージョン: $version"
                TOTAL_FREED=$((TOTAL_FREED + SIZE))
            fi
        done
        
        if [ -n "$latest" ]; then
            echo -e "${GREEN}  保持: 最新バージョン $latest${NC}"
        fi
    done
    
    rm -f "$temp_file"
}

echo -e "${GREEN}=== 開発環境クリーンアップ開始 ===${NC}"
TOTAL_FREED=0

# 1. パッケージマネージャーのキャッシュクリア
echo -e "\n${GREEN}1. パッケージマネージャーのキャッシュ${NC}"

# npm
if [ -d ~/.npm ]; then
    SIZE=$(du -sk ~/.npm 2>/dev/null | cut -f1)
    SIZE=$((SIZE * 1024))
    remove_item ~/.npm $SIZE "npm キャッシュ"
    TOTAL_FREED=$((TOTAL_FREED + SIZE))
fi

# pip
if [ -d ~/Library/Caches/pip ]; then
    SIZE=$(du -sk ~/Library/Caches/pip 2>/dev/null | cut -f1)
    SIZE=$((SIZE * 1024))
    remove_item ~/Library/Caches/pip $SIZE "pip キャッシュ"
    TOTAL_FREED=$((TOTAL_FREED + SIZE))
fi

# Homebrew downloads
if [ -d ~/Library/Caches/Homebrew/downloads ]; then
    SIZE=$(du -sk ~/Library/Caches/Homebrew/downloads 2>/dev/null | cut -f1)
    SIZE=$((SIZE * 1024))
    remove_item ~/Library/Caches/Homebrew/downloads $SIZE "Homebrew ダウンロード"
    TOTAL_FREED=$((TOTAL_FREED + SIZE))
fi

# 2. 古いnode_modulesとビルド成果物（プロジェクトの依存関係のみ）
echo -e "\n${GREEN}2. 長期間アクセスされていない依存関係${NC}"

# 検索対象ディレクトリ
SEARCH_DIRS=("$HOME/Desktop" "$HOME/Downloads" "$HOME")

for dir in "${SEARCH_DIRS[@]}"; do
    # node_modules (90日以上アクセスなし - より保守的に)
    while IFS= read -r -d '' path; do
        PROJECT=$(dirname "$path")
        # プロジェクト自体が最近アクセスされているかチェック
        if [ $(find "$PROJECT" -maxdepth 1 -type f -atime -30 2>/dev/null | wc -l) -eq 0 ]; then
            SIZE=$(du -sk "$path" 2>/dev/null | cut -f1)
            SIZE=$((SIZE * 1024))
            remove_item "$path" $SIZE "node_modules: $PROJECT"
            TOTAL_FREED=$((TOTAL_FREED + SIZE))
        fi
    done < <(find "$dir" -maxdepth 3 -type d -name "node_modules" -atime +90 -print0 2>/dev/null)
    
    # .next (60日以上アクセスなし)
    while IFS= read -r -d '' path; do
        SIZE=$(du -sk "$path" 2>/dev/null | cut -f1)
        SIZE=$((SIZE * 1024))
        PROJECT=$(dirname "$path")
        remove_item "$path" $SIZE ".next ビルド: $PROJECT"
        TOTAL_FREED=$((TOTAL_FREED + SIZE))
    done < <(find "$dir" -maxdepth 3 -type d -name ".next" -atime +60 -print0 2>/dev/null)
    
    # dist/build (60日以上アクセスなし)
    for build_dir in "dist" "build"; do
        while IFS= read -r -d '' path; do
            SIZE=$(du -sk "$path" 2>/dev/null | cut -f1)
            SIZE=$((SIZE * 1024))
            PROJECT=$(dirname "$path")
            remove_item "$path" $SIZE "$build_dir: $PROJECT"
            TOTAL_FREED=$((TOTAL_FREED + SIZE))
        done < <(find "$dir" -maxdepth 3 -type d -name "$build_dir" -atime +60 -print0 2>/dev/null)
    done
done

# 3. アグレッシブモード：バージョン管理されたプロジェクトの古いバージョン
if [ "$AGGRESSIVE" = true ]; then
    echo -e "\n${GREEN}3. バージョン管理されたプロジェクトの古いバージョン${NC}"
    
    # Desktop内のプロジェクト
    clean_versioned_projects "$HOME/Desktop"
    
    # Downloads内のプロジェクト
    clean_versioned_projects "$HOME/Downloads"
    
    # ホームディレクトリ直下のプロジェクト
    clean_versioned_projects "$HOME"
fi

# 4. Xcode関連のゴーストファイル
if [ -d "$HOME/Library/Developer/Xcode" ] || [ -d "$HOME/Library/Developer/CoreSimulator" ]; then
    echo -e "\n${GREEN}4. Xcode開発の亡霊${NC}"
    
    # DerivedData (ビルドキャッシュ)
    if [ -d "$HOME/Library/Developer/Xcode/DerivedData" ]; then
        SIZE=$(du -sk "$HOME/Library/Developer/Xcode/DerivedData" 2>/dev/null | cut -f1)
        SIZE=$((SIZE * 1024))
        if [ $SIZE -gt 0 ]; then
            remove_item "$HOME/Library/Developer/Xcode/DerivedData" $SIZE "Xcode DerivedData (ビルドキャッシュ)"
            TOTAL_FREED=$((TOTAL_FREED + SIZE))
        fi
    fi
    
    # iOS Simulator devices
    if [ -d "$HOME/Library/Developer/CoreSimulator/Devices" ] && command -v xcrun >/dev/null 2>&1; then
        # 各シミュレータデバイスのサイズを計算
        SIMULATOR_SIZE=0
        while IFS= read -r device_dir; do
            if [ -d "$device_dir" ]; then
                DEVICE_SIZE=$(du -sk "$device_dir" 2>/dev/null | cut -f1)
                SIMULATOR_SIZE=$((SIMULATOR_SIZE + DEVICE_SIZE))
            fi
        done < <(find "$HOME/Library/Developer/CoreSimulator/Devices" -maxdepth 1 -type d -name "*-*-*-*-*" 2>/dev/null)
        
        if [ $SIMULATOR_SIZE -gt 0 ]; then
            SIMULATOR_SIZE=$((SIMULATOR_SIZE * 1024))
            if [ "$DRY_RUN" = true ]; then
                echo -e "${YELLOW}[DRY RUN]${NC} Would delete: iOSシミュレータ ($(human_size $SIMULATOR_SIZE))"
                echo -e "  ${BLUE}ℹ️  シミュレータは削除しても安全です。必要な時にXcodeから再作成できます${NC}"
                log_operation "[DRY RUN] Would delete iOS Simulators: $(human_size $SIMULATOR_SIZE)"
            else
                echo -e "${RED}Deleting:${NC} iOSシミュレータ ($(human_size $SIMULATOR_SIZE))"
                echo -e "  ${BLUE}ℹ️  心配無用！必要になったらXcodeから再作成できます${NC}"
                xcrun simctl delete all 2>/dev/null || rm -rf "$HOME/Library/Developer/CoreSimulator/Devices/"*
                log_operation "Deleted iOS Simulators: $(human_size $SIMULATOR_SIZE)"
            fi
            TOTAL_FREED=$((TOTAL_FREED + SIMULATOR_SIZE))
        fi
    fi
    
    # Archives (古いアプリアーカイブ)
    if [ -d "$HOME/Library/Developer/Xcode/Archives" ]; then
        # 60日以上前のアーカイブを削除
        while IFS= read -r -d '' archive; do
            SIZE=$(du -sk "$archive" 2>/dev/null | cut -f1)
            SIZE=$((SIZE * 1024))
            remove_item "$archive" $SIZE "古いXcodeアーカイブ: $(basename "$archive")"
            TOTAL_FREED=$((TOTAL_FREED + SIZE))
        done < <(find "$HOME/Library/Developer/Xcode/Archives" -name "*.xcarchive" -atime +60 -print0 2>/dev/null)
    fi
fi

# 5. 空のプロジェクトディレクトリ
echo -e "\n${GREEN}5. 空のプロジェクトディレクトリ${NC}"
for dir in "${SEARCH_DIRS[@]}"; do
    while IFS= read -r -d '' empty_dir; do
        remove_item "$empty_dir" 0 "空のディレクトリ: $empty_dir"
    done < <(find "$dir" -maxdepth 2 -type d -empty -print0 2>/dev/null)
done

# 結果表示
echo -e "\n${GREEN}=== クリーンアップ完了 ===${NC}"
if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}[DRY RUN] 削除可能な容量: $(human_size $TOTAL_FREED)${NC}"
    echo -e "実際に削除するには、--dry-run オプションを外して実行してください"
else
    echo -e "${GREEN}解放した容量: $(human_size $TOTAL_FREED)${NC}"
fi

# 現在のディスク使用状況
echo -e "\n${GREEN}現在のディスク使用状況:${NC}"
df -h /System/Volumes/Data | tail -n 1