常用的git命令汇总

首先安装git，查看版本

        sudo apt-get update
        sudo apt-get install git
        git --version

一、新建代码库

       1、在当前目录新建git代码库：

            `git init`

       2、新建一个目录，将其初始化为Git代码库

            git init [project-name]

       3、下载一个项目和它的整个代码历史

            git clone url

            url为远程代码库的链接

二、配置

       1、生成ssh密钥对

            ssh-keygen -t rsa -C "xxx@xxx.com"
            xxx@xxx.com为邮箱
            使用命令查看公钥：
            cat .ssh/id_rsa.pub
            然后登陆github，把公钥添加到https://github.com/settings/ssh/new页面，Title随便起，方
            便自己辨识，Key填写获取到的公钥。
              
       2、配置身份标识
            git config --global user.name "your name here"  

三、提交代码

        1、
