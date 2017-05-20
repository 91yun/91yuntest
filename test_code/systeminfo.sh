

get_opsy() {
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
}

systeminfo()
{
	#获得相关数据
	cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
	cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
	freq=$( awk -F: '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
	tram=$( free -m | awk '/Mem/ {print $2}' )
	swap=$( free -m | awk '/Swap/ {print $2}' )
	up=$( awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60;d=$1%60} {printf("%ddays, %d:%d:%d\n",a,b,c,d)}' /proc/uptime )
	opsy=$( get_opsy )
	arch=$( uname -m )
	lbit=$( getconf LONG_BIT )
	host=$hostp
	up=$( awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60;d=$1%60} {printf("%ddays, %d:%d:%d\n",a,b,c,d)}' /proc/uptime )
	kern=$( uname -r )
	IP=$(curl -s myip.ipip.net | awk -F ' ' '{print $2}' | awk -F '：' '{print $2}')
	IPaddr=$(curl -s myip.ipip.net | awk -F '：' '{print $3}')
	if [ "$IP" == "" ]; then
		IP=$(curl -s ip.cn | awk -F ' ' '{print $2}' | awk -F '：' '{print $2}')
		IPaddr=$(curl -s ip.cn | awk -F '：' '{print $3}')	
	fi
	vm=`virt-what`

	#显示在屏幕上
	next
	echo "CPU model            : $cname"
	echo "Number of cores      : $cores"
	echo "CPU frequency        : $freq MHz"
	echo "Total amount of Mem  : $tram MB"
	echo "Total amount of Swap : $swap MB"
	echo "System uptime        : $up"
	echo "Virtualization       : $vm"
	echo "IPaddr               : $IPaddr"

	#写入日志文件
	echo "===系统基本信息===">>$logfilename
	echo "CPU:$cname">>$logfilename
	echo "cores:$cores">>$logfilename
	echo "freq:$freq">>$logfilename
	echo "ram:$tram">>$logfilename
	echo "swap:$swap">>$logfilename
	echo "uptime:$up">>$logfilename
	echo "OS:$opsy">>$logfilename
	echo "Arch:$arch ($lbit Bit)">>$logfilename
	echo "Kernel:$kern">>$logfilename
	echo "ip:$IP">>$logfilename
	echo "ipaddr:$IPaddr">>$logfilename
	echo "host:$hostp">>$logfilename
	echo "uptime:$up">>$logfilename
	echo "vm:$vm">>$logfilename
	echo "he:$he">>$logfilename
	echo -e "\n\n">>$logfilename
}