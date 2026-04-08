#!/bin/bash

# ============================================
#        Git 上传工具 - 交互版
# ============================================

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# 用户配置（请在此填写你的信息）
GITHUB_USER="你的用户名"
GITHUB_TOKEN="你的Token"

# 清屏并显示标题
show_header() {
    clear
    echo -e "${PURPLE}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC}                                                  ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}          ${CYAN}🌟 Git 上传工具 - 交互版 🌟${NC}             ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}                                                  ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
}

# 显示分隔线
show_divider() {
    echo -e "${BLUE}──────────────────────────────────────────────────${NC}"
}

# 检查是否要退出
check_quit() {
    if [[ "$1" == "q" ]]; then
        echo ""
        echo -e "${YELLOW}👋 感谢使用 Git 上传工具，再见！${NC}"
        exit 0
    fi
}

# 显示成功消息
show_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# 显示错误消息
show_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 显示信息消息
show_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

# 显示问题
show_question() {
    echo -e "${WHITE}❓ $1${NC}"
}

# 主程序开始
show_header

# ============================================
# 第一步：获取项目路径
# ============================================
show_divider
show_question "你的项目路径是什么？"
echo -e "${YELLOW}   (输入 q 可随时退出)${NC}"
echo ""

while true; do
    echo -ne "${GREEN}➤ 请输入路径: ${NC}"
    read -r PROJECT_PATH
    check_quit "$PROJECT_PATH"

    # 展开 ~ 符号
    PROJECT_PATH=$(eval echo "$PROJECT_PATH")

    # 检查路径是否存在
    if [[ -d "$PROJECT_PATH" ]]; then
        cd "$PROJECT_PATH" || { show_error "无法进入路径"; continue; }
        show_success "已进入项目路径: $PROJECT_PATH"
        break
    else
        show_error "路径不存在: $PROJECT_PATH，请重新输入"
    fi
done
echo ""

# ============================================
# 第二步：初始化 Git（如果需要）
# ============================================
show_divider
if [[ -d ".git" ]]; then
    show_info "检测到已有 Git 仓库"
else
    show_info "正在初始化 Git 仓库..."
    git init
    show_success "Git 仓库初始化完成"
fi
echo ""

# ============================================
# 第三步：获取仓库名
# ============================================
show_divider
show_question "添加的远程仓库名叫什么？"
echo -e "${CYAN}   (只需要输入仓库名，例如: text)${NC}"
echo ""
echo -ne "${GREEN}➤ 请输入仓库名: ${NC}"
read -r REPO_NAME
check_quit "$REPO_NAME"

REPO_URL="https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${REPO_NAME}.git"
echo ""

# ============================================
# 第四步：添加远程仓库
# ============================================
show_divider
if git remote | grep -q "origin"; then
    show_info "远程仓库 origin 已存在，正在更新地址..."
    git remote set-url origin "$REPO_URL"
else
    show_info "正在添加远程仓库..."
    git remote add origin "$REPO_URL"
fi
show_success "远程仓库配置完成"
echo ""

# ============================================
# 第五步：拉取远程文件
# ============================================
show_divider
show_info "正在拉取远程文件..."
git pull origin main --allow-unrelated-histories 2>/dev/null || \
git pull origin master --allow-unrelated-histories 2>/dev/null || \
show_info "远程仓库可能为空，跳过拉取"
show_success "拉取完成"
echo ""

# ============================================
# 第六步：添加文件
# ============================================
show_divider
show_question "需要添加哪些文件？"
echo -e "${CYAN}   输入 . 然后回车 = 添加所有文件${NC}"
echo -e "${CYAN}   输入文件名 + 回车 = 添加单个文件${NC}"
echo -e "${CYAN}   输入 a + 回车 = 添加完成${NC}"
echo ""

FILES_TO_ADD=()
while true; do
    echo -ne "${GREEN}➤ 输入文件 (或 . 添加全部, a 完成): ${NC}"
    read -r FILE_INPUT
    check_quit "$FILE_INPUT"
    
    if [[ "$FILE_INPUT" == "a" ]]; then
        show_success "文件添加完成"
        break
    elif [[ "$FILE_INPUT" == "." ]]; then
        show_info "添加所有文件..."
        git add .
        show_success "所有文件已添加"
        break
    elif [[ -n "$FILE_INPUT" ]]; then
        if [[ -e "$FILE_INPUT" ]]; then
            git add "$FILE_INPUT"
            show_success "已添加: $FILE_INPUT"
            FILES_TO_ADD+=("$FILE_INPUT")
        else
            show_error "文件不存在: $FILE_INPUT"
        fi
    fi
done
echo ""

# ============================================
# 第七步：提交说明
# ============================================
show_divider
show_question "提交说明是什么？"
echo -e "${CYAN}   (直接回车 = 使用默认提交说明)${NC}"
echo ""
echo -ne "${GREEN}➤ 请输入提交说明: ${NC}"
read -r COMMIT_MSG
check_quit "$COMMIT_MSG"

if [[ -z "$COMMIT_MSG" ]]; then
    COMMIT_MSG="提交更新"
fi

git commit -m "$COMMIT_MSG"
show_success "提交完成: $COMMIT_MSG"
echo ""

# ============================================
# 第八步：检查 LICENSE
# ============================================
show_divider
show_question "远程仓库有没有 LICENSE 文件？"
echo -e "${CYAN}   输入 有/无 或 y/n${NC}"
echo ""
echo -ne "${GREEN}➤ 请回答: ${NC}"
read -r HAS_LICENSE
check_quit "$HAS_LICENSE"

if [[ "$HAS_LICENSE" == "有" || "$HAS_LICENSE" == "y" || "$HAS_LICENSE" == "Y" ]]; then
    if [[ -f "LICENSE" ]]; then
        show_info "正在删除本地 LICENSE 文件..."
        gio trash LICENSE 2>/dev/null || rm -f LICENSE
        show_success "LICENSE 文件已移至回收站"
    else
        show_info "本地没有 LICENSE 文件，跳过"
    fi
fi
echo ""

# ============================================
# 第九步：推送
# ============================================
show_divider
show_info "正在推送到远程仓库..."

# 配置凭据
git config credential.helper store

# 尝试推送到 main 分支
if git push -u origin master:main 2>/dev/null; then
    show_success "推送成功！"
else
    # 如果失败，尝试其他方式
    CURRENT_BRANCH=$(git branch --show-current)
    git push -u origin "$CURRENT_BRANCH:main" || git push -u origin "$CURRENT_BRANCH"
    show_success "推送成功！"
fi
echo ""

# ============================================
# 完成
# ============================================
show_header
show_divider
echo -e "${GREEN}🎉 恭喜！所有操作已完成！${NC}"
echo ""
show_divider
echo ""
echo -ne "${YELLOW}➤ 按 q 退出: ${NC}"
read -r EXIT_INPUT

echo ""
echo -e "${PURPLE}💕 感谢使用，下次见！${NC}"
echo ""
