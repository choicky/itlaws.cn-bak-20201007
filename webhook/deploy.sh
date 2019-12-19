#!/bin/bash

# 配合 npm i -S github-webhook-handler 使用

# 网站的代码仓库目录
repo_path="/var/www/itlaws.cn"
USER='www-data'
USERGROUP='www-data'

# Nginx 中配置的网站的 HTML 根目录
web_root="/var/www/itlaws.cn/public"

# 更新 repo 并生成新的静态化文件
cd $repo_path
# git reset --hard origin/master
git clean -f
git pull --recurse-submodules
# git checkout master
chown -R $USER:$USERGROUP $repo_path
hugo -s $repo_path -d $web_root
