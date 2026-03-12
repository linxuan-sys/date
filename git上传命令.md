Git 上传到 GitHub 命令模板
================================

【基础流程】

# 1. 进入项目文件夹
cd /你的项目路径

# 2. 初始化 git（如果还没有）
git init

# 3. 添加远程仓库
git remote add origin https://github.com/linxuan-sys/仓库名.git

# 4. 拉取远程文件（合并历史）
git pull origin main --allow-unrelated-histories

# 5. 添加所有文件
git add .

# 6. 提交
git commit -m "提交说明"

# 7. 推送
git push -u origin master:main


================================
【常见问题解决】


问题1：本地分支 master，远程分支 main，推送失败
错误：源引用规格 main 没有匹配

解决：推送时指定 本地:远程
git push -u origin master:main

或者把本地分支改名为 main：
git branch -m master main
git push -u origin main


问题2：本地和远程都有 LICENSE 文件，pull 冲突
错误：工作区中下列未跟踪的文件将会因为合并操作而被覆盖

解决：先删除本地冲突文件，再 pull
rm LICENSE
git pull origin main --allow-unrelated-histories


问题3：密码认证失败
错误：Password authentication is not supported

解决：用 Token 代替密码
1. 去 https://github.com/settings/tokens 创建 Token
2. 推送时密码填 Token（不是 GitHub 密码）


问题4：remote origin already exists
解决：跳过第3步，直接 pull


================================
【快速命令】

# 查看当前分支
git branch

# 查看远程地址
git remote -v

# 修改远程地址
git remote set-url origin https://github.com/linxuan-sys/新地址.git