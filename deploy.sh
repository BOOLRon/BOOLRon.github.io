#! /bin/zsh

hexo clean
hexo generate
cd public

git init
git add .
git commit -m "update at `date` "

git remote add github git@github.com:BOOLRon/BOOLRon.github.io.git >> /dev/null 2>&1
echo "### Pushing to Github..."
git push github master -f
echo "### Done"

git remote add origin git@git.coding.net:bool_ron/bool_ron.git >> /dev/null 2>&1
echo "### Pushing to Coding..."
git push origin master:coding-pages -f
echo "### Done"