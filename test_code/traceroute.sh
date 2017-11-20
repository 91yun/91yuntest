
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PLAIN='\033[0m'

mtrgo(){
	
	#获得数据
	mtrurl=$1
	nodename=$2
	mtrgostr=$(curl -s -L "$mtrurl")
	echo $mtrgostr > mtrlog.log
	mtrgostrback=$(curl -s -d @mtrlog.log "https://logfileupload.91yuntest.com/traceroute.php")
	rm -rf mtrlog.log
	
	#显示在显示器上
	echo -e "===测试 [${YELLOW}$nodename${PLAIN}] 到这台服务器的路由==="
	echo -e $mtrgostrback | awk -F '^' '{printf("%-5s%-20s%-30s%-45s\n",$1,$2,$5,$4)}'
	echo -e "\n\n"
	
	#计入日志文件
	echo "===start test traceroute from [$nodename]===">>${dir}/$logfilename
	echo -e $mtrgostrback | awk -F '^' '{print $1,"#",$2,"#",$3,"#",$4,"#",$5}'>>${dir}/$logfilename
	echo -e "=== [$nodename] traceroute test ended===\n\n">>${dir}/$logfilename
}


traceroute()
{
	next
	mtrgo "http://www.ipip.net/traceroute.php?as=1&a=get&n=1&id=274&ip=$IP" "广州电信（天翼云）"
	mtrgo "http://www.ipip.net/traceroute.php?as=1&a=get&n=1&id=100&ip=$IP" "上海电信（天翼云）"
	mtrgo "http://www.ipip.net/traceroute.php?as=1&a=get&n=1&id=20&ip=$IP" "厦门电信CN2"
	mtrgo "http://www.ipip.net/traceroute.php?as=1&a=get&n=1&id=12&ip=$IP" "重庆联通"
	mtrgo "http://www.ipip.net/traceroute.php?as=1&a=get&n=1&id=356&ip=$IP" "上海移动"
	mtrgo "http://www.ipip.net/traceroute.php?as=1&a=get&n=1&id=160&ip=$IP" "北京教育网"
}
