#! /bin/zsh

hexo clean
hexo generate
cd public

git init
git add .
git commit -m "update at `date` "

echo "### Pushing to Github..."
git push github master -f
echo "### Done"

echo "### Pushing to Coding..."
git push origin coding-pages -f
echo "### Done"