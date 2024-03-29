#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH

next() {
    printf "%-70s\n" "-" | sed 's/\s/-/g'
}


echo "开始测试中，会需要点时间，请稍后"


_included_benchmarks=""
upfile="y"


#取参数
while getopts "i:u" opt; do
    case $opt in
        i) _included_benchmarks=$OPTARG;;
		u) upfile="n";;
    esac
done

#默认参数
if [ "$_included_benchmarks" == "" ]; then
	_included_benchmarks="io,bandwidth,chinabw,download,backtraceroute,unlock"
fi

_included_benchmarks="systeminfo,"${_included_benchmarks}


#要用到的变量
backtime=`date +%Y%m%d`
logfilename="91yuntest.log"
dir=`pwd`
IP=$(curl -s myip.ipip.net | awk -F ' ' '{print $2}' | awk -F '：' '{print $2}')
echo "====开始记录测试信息===="

#创建测试目录
mkdir -p 91yuntest
cd 91yuntest

clear

#取得测试的参数值
arr=(${_included_benchmarks//,/ })    

#下载执行相应的代码
for i in ${arr[@]}    
do 
	wget -q --no-check-certificate https://raw.githubusercontent.com/91yun/91yuntest/master/test_code/${i}.sh
    . ${dir}/91yuntest/${i}.sh
	eval ${i}
done    

#删除目录
rm -rf ${dir}/91yuntest

