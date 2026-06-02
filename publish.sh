#!/bin/zsh
source ~/.zshrc

set -e

usage() {
    echo "使用方法: $0 {dev|patch|minor|major}"
    echo "  dev:   发布开发版本 (-dev.x)"
    echo "  patch: 发布修订版本 (0.0.x)"
    echo "  minor: 发布次要版本 (0.x.0)"
    echo "  major: 发布主要版本 (x.0.0)"
    exit 1
}

if [ $# -ne 1 ]; then
    usage
fi

RELEASE_TYPE=$1

case $RELEASE_TYPE in
    dev|patch|minor|major)
        ;;
    *)
        echo "错误: 无效的发布类型"
        usage
        ;;
esac

get_current_version() {
    grep '^version: ' pubspec.yaml | sed 's/version: //'
}

bump_version() {
    local current_version=$1
    local type=$2
    
    if [[ $current_version =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)(-dev\.([0-9]+))?$ ]]; then
        local major=${match[1]}
        local minor=${match[2]}
        local patch=${match[3]}
        local dev_num=${match[5]}
        
        case $type in
            dev)
                if [ -z "$dev_num" ]; then
                    echo "$major.$minor.$patch-dev.1"
                else
                    echo "$major.$minor.$patch-dev.$((dev_num + 1))"
                fi
                ;;
            patch)
                echo "$major.$minor.$((patch + 1))"
                ;;
            minor)
                echo "$major.$((minor + 1)).0"
                ;;
            major)
                echo "$((major + 1)).0.0"
                ;;
        esac
    else
        echo "错误: 无效的版本格式: $current_version"
        exit 1
    fi
}

CURRENT_VERSION=$(get_current_version)
NEW_VERSION=$(bump_version "$CURRENT_VERSION" "$RELEASE_TYPE")
RELEASE_MESSAGE="Release $NEW_VERSION"

echo "当前版本: $CURRENT_VERSION"
echo "新版本:     $NEW_VERSION"

echo "1. 使用 git flow 创建发布分支..."
yes y | git flow release start "$NEW_VERSION"

echo "2. 更新 pubspec.yaml 中的版本号..."
sed -i '' "s/version: $CURRENT_VERSION/version: $NEW_VERSION/" pubspec.yaml

echo "3. 提交 git 更改..."
git add pubspec.yaml
yes y | git commit -m "chore: bump version."

echo "4. 发布到 pub.dev..."
# 绕过 pub_publish_no_build alias，stdin 才能正确传递给 flutter 命令
set_proxy
yes y | flutter packages pub publish --server=https://pub.dartlang.org
unset_proxy

echo "5. 结束 git flow 发布分支..."
GIT_MERGE_AUTOEDIT=no yes y | git flow release finish -m "$RELEASE_MESSAGE" "$NEW_VERSION"

echo "发布 $NEW_VERSION 完成！"