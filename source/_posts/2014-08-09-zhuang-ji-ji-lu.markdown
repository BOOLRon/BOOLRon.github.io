---
layout: post
title: "装机记录"
date: 2014-08-09 09:36:11 +0800
comments: true
categories: 
---
***
#### GUI安装
首先进入AppStore升级系统，然后通过AppStore的”Purchases”页面，重新安装以前购买过的应用，再通过网页下载输入法、Resizer、PS等
***
#### 命令行安装	
**安装homebrew**

	ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
	
安装完成后别忘了执行: 

	brew doctor
	
然后可以用brew安装git、wget等

	brew install git
	brew install wget
**brew cask**

还可以使用brew cask来安装应用，首先安装cask:

	brew tap phinze/cask
	brew install brew-cask
	
接下来可以安装你需要的软件，例如：

	brew cask install google-chrome
	brew cask install sublime-text
	brew cask install mou
	brew cask install sourcetree	
***
**安装oh-my-zsh**

	curl -L http://install.ohmyz.sh | sh
安装完成之后，执行：

	subl ~/.zshrc
	
然后把以下这行注释启用：export LANG=en_US.UTF-8 ，否则命令行中的中文可能会乱码。
你也可以给一些常用命令加上别名，例如：

	alias gs='git status'
	alias guod='git pull origin develop'
	alias gpod='git push origin develop'
***
**安装CocoaPods**

	sudo gem install cocoapods
	
然后执行

	 pod setup
	 
这是建立pod索引的过程，可能等待比较长时间，建议翻墙
***
**安装Alcatraz(Xcode插件管理包)**

	curl -fsSL https://raw.github.com/supermarin/Alcatraz/master/Scripts/install.sh | sh
	
***
**安装Rvm**
	
	curl -L https://get.rvm.io | bash -s stable --ruby
	
由于我的博客使用Octopress搭建，所以安装bundler: 

	gem install bundler
	bundle install