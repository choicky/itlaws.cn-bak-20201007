#!/bin/bash

# 网站的代码仓库目录
input="/var/www/itlaws.cn"

# Nginx 中配置的网站的 HTML 根目录
output="/var/www/itlaws.cn/public"

cd $input && git pull --recurse-submodules && hugo --cleanDestinationDir --destination=/var/www/itlaws.cn/public

