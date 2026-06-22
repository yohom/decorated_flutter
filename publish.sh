#!/bin/zsh
source ~/.zshrc

set -e

usage() {
    echo "使用方法: $0 <version>"
    echo "  version: 要发布的版本号 (例如: 1.2.3, 1.2.3-dev.1)"
    exit 1
}

if [ $# -ne 1 ]; then
    usage
fi

NEW_VERSION=$1

# 验证版本号格式
if [[ ! $NEW_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+(-dev\.[0-9]+)?$ ]]; then
    echo "错误: 无效的版本格式: $NEW_VERSION"
    echo "版本号应符合格式: x.y.z 或 x.y.z-dev.n"
    exit 1
fi

get_current_version() {
    grep '^version: ' pubspec.yaml | sed 's/version: //'
}

CURRENT_VERSION=$(get_current_version)
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
