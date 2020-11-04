# 常用的git命令汇总

首先安装git，查看版本

```
sudo apt-get update
sudo apt-get install git
git --version
```

### 一、新建代码库

1、在当前目录新建git代码库：
```
git init
```
2、新建一个目录，将其初始化为Git代码库
```
git init [project-name]
```
3、下载一个项目和它的整个代码历史
```
git clone url
```
- url为远程代码库的链接

二、配置

1、生成ssh密钥对
```
ssh-keygen -t rsa -C "xxx@xxx.com"
```
- xxx@xxx.com为邮箱
- 使用命令查看公钥：
```
cat .ssh/id_rsa.pub
```
- 然后登陆github，把公钥添加到[github](https://github.com/settings/ssh/new)页面，Title随便起，方便自己辨识，Key填写获取到的公钥。
              
2、配置身份标识
```
git config --global user.name "your name here"  
```
三、提交代码

1、添加到暂存区
```
git add filename
```
- 可以使用add继续添加人物文件
- 也可以使用：`git add .`添加所有改动

2、提交信息
```
git commit -m "信息"
```
- 当我们修改了很多文件，而不想每一个都add，想commit自动来提交本地修改，我们可以使用-a标识。
```
git commit -a -m "Changed some files"
```

