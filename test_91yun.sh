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

# 安装依赖
preinstall()
{
	apt-get >/dev/null 2>&1
	[ $? -le '1' ] && apt-get -y install curl mtr virt-what python
	yum >/dev/null 2>&1
	[ $? -le '1' ] && yum -y install which sed curl mtr virt-what python
	backtime=`date +%Y%m%d`
	logfilename="test91yun.log"
	dir=`pwd`
	echo "====开始记录测试信息====">$logfilename
}

echo "服务器提供商（host provider）[default:Enter]"
read hostp
echo "开始测试中，会需要点时间，请稍后"

preinstall
_included_benchmarks=""

#创建测试目录
mkdir -p 91yuntest
cd 91yuntest
dir=`pwd`


clear

#取参数
while getopts "i:" opt; do
    case $opt in
        i) _included_benchmarks=$OPTARG;;
    esac
done

#默认参数
if [ "$_included_benchmarks" == "" ]; then
	_included_benchmarks="systeminfo,io,bandwidth,download,traceroute,backtraceroute,allping,gotoping"
fi

#取得测试的参数值
arr=(${_included_benchmarks//,/ })    
    
for i in ${arr[@]}    
do 
	wget -Nq --no-check-certificate https://raw.githubusercontent.com/91yun/91yuntest/test/test_code/${i}.sh
    . ${dir}/${i}.sh
	eval ${i}
done    


#上传文件
# updatefile()
# {
	# resultstr=$(curl -s -T $logfilename "http://test.91yun.org/logfileupload.php")
	# echo -e $resultstr | tee -a $logfilename
# }


