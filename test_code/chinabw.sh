cbw()
{

    arch=$( uname -m )
    wget --no-check-certificate https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-x86_64.tgz -O speedtest.tgz 1>/dev/null 2>&1
    tar xfvz speedtest.tgz >/dev/null 2>&1
    chmod +x speedtest
    bd=`./speedtest --accept-license --accept-gdpr -s $1 2>/dev/null | awk -F '(' '{print $1}'`

	#获得相关数据
    latency=`echo "$bd" | awk -F ':' '/Latency/{print $2}'`
	download=`echo "$bd" | awk -F ':' '/Download/{print $2}'`
	upload=`echo "$bd" | awk -F ':' '/Upload/{print $2}'`

	#显示在屏幕上
    if [ -n "$latency" ]
    then
        printf "%-18s%-18s%-20s%-12s\n" "$2" "$upload" "$download" "$latency"
    fi


}
chinabw()
{
    next
    echo "===开始测试国内带宽==="
    printf "%-18s%-18s%-20s%-12s\n" " Node Name" "Upload Speed" "Download Speed" "Latency"
    cbw '3633' '上海 电信'
    cbw '56354' '福州 联通'
    cbw '6611' '广东 移动'
}

