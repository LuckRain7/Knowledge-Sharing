#!/usr/bin/env sh

# 确保脚本抛出遇到的错误
set -e

git add . 

git commit -m "docs: update"

# Gitee
git push git@gitee.com:LuckRain7/Knowledge-Sharing.git master

# GitHub
git push git@github.com:LuckRain7/Knowledge-Sharing.git master

cd -