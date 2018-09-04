traceroute()
{
	next
	wget -q --no-check-certificate https://raw.githubusercontent.com/91yun/91yuntest/master/test_code/traceroute.py 
	# python -W ignore ${dir}/91yuntest/traceroute.py -l ${dir}/$logfilename -i $IP
	mtrgo "https://tools.ipip.net/traceroute.php?as=1&v=4&a=get&n=1&id=100&ip=${IP}" "上海电信（天翼云）" "shanghaict.log"
	mtrgo "https://tools.ipip.net/traceroute.php?as=1&v=4&a=get&n=1&id=3&ip=${IP}" "杭州联通" "hangzhoucu.log"
	mtrgo "https://tools.ipip.net/traceroute.php?as=1&v=4&a=get&n=1&id=305&ip=${IP}" "四川德阳移动" "deyangcm.log"
}
mtrgo(){
	curl -s $1 > $3
	python -W ignore ${dir}/91yuntest/traceroute.py -l ${dir}/$logfilename -i $IP -n $2 -f $3 
}
