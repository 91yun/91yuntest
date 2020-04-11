get_opsy()
{
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
	# vm=`virt-what`

	#显示在屏幕上
    echo "Provider: $hostp"
	next
	echo "CPU model            : $cname"
	echo "Number of cores      : $cores"
	echo "CPU frequency        : $freq MHz"
	echo "Total amount of Mem  : $tram MB"
	echo "Total amount of Swap : $swap MB"
	echo "System uptime        : $up"
	# echo "Virtualization       : $vm"
	echo "IPaddr               : $IPaddr"
    echo "OS                   : $opsy $arch $kern"

	#写入日志文件
	echo "===系统基本信息===">>${dir}/$logfilename
	echo "CPU:$cname">>${dir}/$logfilename
	echo "cores:$cores">>${dir}/$logfilename
	echo "freq:$freq">>${dir}/$logfilename
	echo "ram:$tram">>${dir}/$logfilename
	echo "swap:$swap">>${dir}/$logfilename
	echo "uptime:$up">>${dir}/$logfilename
	echo "OS:$opsy">>${dir}/$logfilename
	echo "Arch:$arch ($lbit Bit)">>${dir}/$logfilename
	echo "Kernel:$kern">>${dir}/$logfilename
	echo "ip:$IP">>${dir}/$logfilename
	echo "ipaddr:$IPaddr">>${dir}/$logfilename
	echo "host:$hostp">>${dir}/$logfilename
	echo "uptime:$up">>${dir}/$logfilename
	# echo "vm:$vm">>${dir}/$logfilename
	echo "he:$he">>${dir}/$logfilename
	echo -e "\n\n">>${dir}/$logfilename
}