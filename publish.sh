#!/bin/zsh
source ~/.zshrc

set -e

# 显示使用帮助
usage() {
    echo "Usage: $0 {dev|patch|minor|major}"
    echo "  dev:   发布 dev 版本 (-dev.x)"
    echo "  patch: 发布修订版本 (0.0.x)"
    echo "  minor: 发布次要版本 (0.x.0)"
    echo "  major: 发布主要版本 (x.0.0)"
    exit 1
}

# 检查参数
if [ $# -ne 1 ]; then
    usage
fi

RELEASE_TYPE=$1

# 验证发布类型
case $RELEASE_TYPE in
    dev|patch|minor|major)
        ;;
    *)
        echo "Error: Invalid release type"
        usage
        ;;
esac

# 获取当前版本
get_current_version() {
    grep '^version: ' pubspec.yaml | sed 's/version: //'
}

# 版本升级函数
bump_version() {
    local current_version=$1
    local type=$2
    
    # 解析版本号
    if [[ $current_version =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)(-dev\.([0-9]+))?$ ]]; then
        local major=${BASH_REMATCH[1]}
        local minor=${BASH_REMATCH[2]}
        local patch=${BASH_REMATCH[3]}
        local dev_num=${BASH_REMATCH[5]}
        
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
        echo "Error: Invalid version format: $current_version"
        exit 1
    fi
}

# 主流程
CURRENT_VERSION=$(get_current_version)
NEW_VERSION=$(bump_version "$CURRENT_VERSION" "$RELEASE_TYPE")

echo "Current version: $CURRENT_VERSION"
echo "New version:     $NEW_VERSION"

# 1. 使用 git flow 创建发布分支
git flow release start "$NEW_VERSION"

# 2. 更新 pubspec.yaml 中的版本号
sed -i '' "s/version: $CURRENT_VERSION/version: $NEW_VERSION/" pubspec.yaml

# 3. git 提交
git add pubspec.yaml
git commit -m "chore: bump version."

# 4. 发布到 pub.dev
echo "Publishing to pub.dev..."
pub_publish_no_build_v

# 5. 结束 git flow 发布分支
git flow release finish "$NEW_VERSION"

echo "Release $NEW_VERSION completed successfully!"
