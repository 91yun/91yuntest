bandwidth()
{
	#获得相关数据
	wget --no-check-certificate https://raw.githubusercontent.com/91yun/speedtest-cli/master/speedtest_cli.py 1>/dev/null 2>&1
	bd=`python speedtest_cli.py --share`
	download=`echo "$bd" | awk -F ':' '/Download/{print $2}'`
	upload=`echo "$bd" | awk -F ':' '/Upload/{print $2}'`
	hostby=`echo "$bd" | grep 'Hosted'`
	rm -rf speedtest_cli.py

	#显示在屏幕上
	next
	echo "$hostby"
	echo "上传   : $download"
	echo "下载   : $upload"


	#写入日志文件
	echo "===开始测试带宽===">>${dir}/$logfilename
	echo "$bd">>${dir}/$logfilename
	echo -e "===带宽测试结束==\n\n">>${dir}/$logfilename
}