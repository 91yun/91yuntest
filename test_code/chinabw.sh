cbw()
{

    arch=$( uname -m )
    wget --no-check-certificate https://bintray.com/ookla/download/download_file?file_path=ookla-speedtest-1.0.0-${arch}-linux.tgz -O speedtest.tgz 1>/dev/null 2>&1
    tar xfvz speedtest.tgz >/dev/null 2>&1
    chmod +x speedtest
    bd=`./speedtest --accept-license -s $1 2>/dev/null | awk -F '(' '{print $1}'`

	#获得相关数据
    latency=`echo "$bd" | awk -F ':' '/Latency/{print $2}'`
	download=`echo "$bd" | awk -F ':' '/Download/{print $2}'`
	upload=`echo "$bd" | awk -F ':' '/Upload/{print $2}'`

	#显示在屏幕上
    if [ -n "$latency" ]
    then
        printf "%-18s%-18s%-20s%-12s\n" "$2" "$upload" "$download" "$latency"
        #写入日志文件
	    echo "$2|$upload|$download|$latency">>${dir}/$logfilename
    fi


}
chinabw()
{
    next
    echo "===开始测试国内带宽===">>${dir}/$logfilename
    printf "%-18s%-18s%-20s%-12s\n" " Node Name" "Upload Speed" "Download Speed" "Latency"
    cbw '3633' '上海 电信'
    cbw '27377' '北京 电信5G'
    cbw '19076' '重庆 电信'
    cbw '27594' '广州 电信5G'
    cbw '21005' '上海 联通'
    cbw '5145' '北京 联通'
    cbw '31985' '重庆 联通'
    cbw '26678' '广州 联通5G'
    cbw '25637' '上海 移动5G'
    cbw '25858' '北京 移动'
    cbw '17584' '重庆 移动'
    cbw '6611' '广东 移动'
    echo -e "===国内带宽测试结束==\n\n">>${dir}/$logfilename
}

