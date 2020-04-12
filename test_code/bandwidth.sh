bandwidth()
{
    arch=$( uname -m )
    wget --no-check-certificate https://bintray.com/ookla/download/download_file?file_path=ookla-speedtest-1.0.0-${arch}-linux.tgz -O speedtest.tgz 1>/dev/null 2>&1
    tar xfvz speedtest.tgz >/dev/null 2>&1
    chmod +x speedtest
    bd=`./speedtest --accept-license | awk -F '(' '{print $1}'`
    

	#显示在屏幕上
	next
    echo "$bd" | grep -v Ookla | grep -v '^$'



	#写入日志文件
	echo "===开始测试带宽===">>${dir}/$logfilename
	echo "$bd">>${dir}/$logfilename
	echo -e "===带宽测试结束==\n\n">>${dir}/$logfilename
}
