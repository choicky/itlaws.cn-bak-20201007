#!/bin/bash
# work with webhook (https://github.com/adnanh/webhook)

# user config
USER='www-data'
USERGROUP='www-data'

# path config
repo_path="/var/www/itlaws.cn"
web_root="/var/www/itlaws.cn/public"

# git pull and update submodules
cd $repo_path
git clean -f
git pull
git submodule update --remote

# regenerate html with hugo
chown -R $USER:$USERGROUP $repo_path
hugo -s $repo_path -d $web_root
