bandwidth()
{
    arch=$( uname -m )
    wget --no-check-certificate https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-x86_64.tgz -O speedtest.tgz 1>/dev/null 2>&1
    tar xfvz speedtest.tgz >/dev/null 2>&1
    chmod +x speedtest
    bd=`./speedtest --accept-license --accept-gdpr | awk -F '(' '{print $1}'`
    

	#显示在屏幕上
	next
    echo "$bd" | grep -v Ookla | grep -v '^$'

}
