traceroute()
{
	next
	wget -q --no-check-certificate https://raw.githubusercontent.com/91yun/91yuntest/master/test_code/traceroute.py  >/dev/null 2>&1
	# python -W ignore ${dir}/91yuntest/traceroute.py -l ${dir}/$logfilename -i $IP
	mtrgo "https://tools.ipip.net/traceroute.php?as=1&v=4&a=get&n=1&t=I&id=254&ip=${IP}" "北京电信（天翼云）" "beijinct.log"
    mtrgo "https://tools.ipip.net/traceroute.php?as=1&v=4&a=get&n=1&t=I&id=701&ip=${IP}" "江苏徐州电信" "xuzhouct.log"
	mtrgo "https://tools.ipip.net/traceroute.php?as=1&v=4&a=get&n=1&t=I&id=274&ip=${IP}" "广州电信（天翼云）" "guangzhouct.log"

	mtrgo "https://tools.ipip.net/traceroute.php?as=1&v=4&a=get&n=1&t=I&id=661&ip=${IP}" "山东枣庄联通" "shandongcu.log"
	mtrgo "https://tools.ipip.net/traceroute.php?as=1&v=4&a=get&n=1&t=I&id=700&ip=${IP}" "江苏徐州联通" "jiangsucu.log"
	mtrgo "https://tools.ipip.net/traceroute.php?as=1&v=4&a=get&n=1&t=I&id=503&ip=${IP}" "广东茂名联通" "guangdongcu.log"

	mtrgo "https://tools.ipip.net/traceroute.php?as=1&v=4&a=get&n=1&t=I&id=774&ip=${IP}" "辽宁沈阳移动" "liaoningcm.log"
	mtrgo "https://tools.ipip.net/traceroute.php?as=1&v=4&a=get&n=1&t=I&id=766&ip=${IP}" "江苏宿迁移动" "jiangsucm.log"
	mtrgo "https://tools.ipip.net/traceroute.php?as=1&v=4&a=get&n=1&t=I&id=756&ip=${IP}" "广东茂名移动" "guangdongcm.log"
}
curlinstall()
{
    apt-get >/dev/null 2>&1
	[ $? -le '1' ] && ( apt-get update >/dev/null 2>&1 | apt-get -y curl >/dev/null 2>&1 )
	yum >/dev/null 2>&1
	[ $? -le '1' ] && yum -y install curl >/dev/null 2>&1
}

mtrgo(){
    type curl >/dev/null 2>&1 || curlinstall
    python_ver=$(ls /usr/bin|grep -e "^python[23]\.[1-9]\+$"|tail -1)
	curl -s $1 > $3
	${python_ver} -W ignore ./traceroute.py -l ${dir}/$logfilename -i $IP -n $2 -f $3 
}