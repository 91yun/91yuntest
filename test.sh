#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH

Color_Text()
{
  echo -e " \e[0;$2m$1\e[0m"
}

Echo_Red()
{
  echo $(Color_Text "$1" "31")
}

Echo_Green()
{
  echo $(Color_Text "$1" "32")
}

Echo_Yellow()
{
  echo -n $(Color_Text "$1" "33")
}

Echo_Blue()
{
  echo $(Color_Text "$1" "34")
}

next() {
    printf "%-70s\n" "-" | sed 's/\s/-/g'
}


echo "服务器提供商（host provider）[default:Enter]"
read hostp
echo "开始测试中，会需要点时间，请稍后"


_included_benchmarks=""



#取参数
while getopts "i:" opt; do
    case $opt in
        i) _included_benchmarks=$OPTARG;;
    esac
done

#默认参数
if [ "$_included_benchmarks" == "" ]; then
	_included_benchmarks="io,bandwidth,download,traceroute,backtraceroute,allping"
fi

_included_benchmarks="systeminfo,"${_included_benchmarks}

#预先安装库，如果有进行benchtest就会多安装些东西
bt="benchtest"
if [[ $_included_benchmarks == *$bt* ]]
then
    apt-get >/dev/null 2>&1
	[ $? -le '1' ] && ( apt-get update | apt-get -y install curl mtr virt-what python perl automake autoconf time make gcc gdb )
	yum >/dev/null 2>&1
	[ $? -le '1' ] && yum -y install which sed curl mtr virt-what python make gcc gcc-c++ gdbautomake autoconf time perl-Time-HiRes perl
else
    apt-get >/dev/null 2>&1
	[ $? -le '1' ] && ( apt-get update | apt-get -y install curl mtr virt-what python )
	yum >/dev/null 2>&1
	[ $? -le '1' ] && yum -y install which sed curl mtr virt-what python
fi

#要用到的变量
backtime=`date +%Y%m%d`
logfilename="test91yun.log"
dir=`pwd`
IP=$(curl -s myip.ipip.net | awk -F ' ' '{print $2}' | awk -F '：' '{print $2}')
echo "====开始记录测试信息====">${dir}/$logfilename

#创建测试目录
mkdir -p 91yuntest
cd 91yuntest

clear

#取得测试的参数值
arr=(${_included_benchmarks//,/ })    

#下载执行相应的代码
for i in ${arr[@]}    
do 
	wget -q --no-check-certificate https://raw.githubusercontent.com/91yun/91yuntest/test/test_code/${i}.sh
    . ${dir}/91yuntest/${i}.sh
	eval ${i}
done    


#上传文件
updatefile()
{
	resultstr=$(curl -s -T ${dir}/$logfilename "https://test.91yun.org/logfileupload.php")
	echo -e $resultstr | tee -a ${dir}/$logfilename
}
updatefile

#删除目录
rm -rf ${dir}/91yuntest

