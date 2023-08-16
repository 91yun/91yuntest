# 91yun服务器测试一键包介绍

一键包主要是为了让大家快速对服务器的基本状况有一个了解。考虑到天朝的网络出口问题，所以这个一键包更加偏向网络的测试。

影响测试耗时主要是下载，整个测试如果是能跑满100M带宽的话，应该在20分钟-30分钟。但如果只有几百k下载速度的话，就要耗很长时间了，所以如果大家看到测试卡在了下载测试，希望大家耐心等候。

测试结果存在当前目录的test91yun.log。大家可以用vim或者cat看，同时也会生成html的页面，方便大家查看和分享。具体html页面的样式参考以下内容。

# 使用方法：
    wget -N --no-check-certificate https://raw.githubusercontent.com/91yun/91yuntest/master/test.sh && bash test.sh
    
# 问题反馈
欢迎大家到我的博客反馈问题：[91yun](https://www.91yun.org)

[服务器测试一键包反馈页面](https://www.91yun.org/archives/833)
