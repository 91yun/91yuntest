traceroute()
{
	next
	wget -q --no-check-certificate https://raw.githubusercontent.com/91yun/91yuntest/master/test_code/traceroute.py  >/dev/null 2>&1
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
	curl -s $1 > $3
    ipiptraceroute $1 $2 $3

}

ipiptraceroute()
{
    t=`cat $3`
    t=`echo -e "$t" | sed "s/<\/script>/<\/script>\n/g"`
    t=`echo "$t" | grep "parent.resp_once"`
    t=`echo "$t" | sed -r "s/<script>parent.resp_once\((.*)\)<\/script>/\1/g"`

    echo "===测试 [$2] 到这台服务器的路由==="
    echo  "===start test traceroute from [$2]===" >>${dir}/$logfilename
    while read line || [ -n "$line" ]
    do
        num=`echo "$line" | grep -oE "^'[0-9]+'" | grep -oE "[0-9]+"`
        host=`echo "$line" | grep -oE '"host":"[^\*"]*"' | sed -r 's@"host":"([^*"]*)"@\1@g' | head -n 1`
        if [ -z "$host" ] 
        then
            host="*"
        fi     

        ip=`echo "$line" | grep -oE '"ip":"[^\*,]*"' | sed -r 's@"ip":"<a .*>([^\*,]*)</a>"@\1@g' | head -n 1`
        if [ -z "$ip" ] 
        then
            ip="*"
        fi 


        area=`echo "$line" | grep -oE '"area":"[^\*,]*"' | sed -r 's@"area":"([^\*,]*)"@\1@g' | head -n 1`
        if [ -z "$area" ] 
        then
            area="*"
        fi     


        time=`echo "$line" | grep -oE '"time":"?[^,*"]+"?' | head -n 1 | awk -F ":" '{print $2}' | sed 's/"//g' | awk -F "/" '{if( $2 == "" ) print $1;else print $2}' | awk '{printf("%.2f",$1)}'`   
        if [ -z "$time" ] 
        then
            time="*"
        fi   

        printf "%-5s\t%-20s\t%-60s\t%-10s\n" "$num" "$host" "$area" "$time"
        echo "$num#$ip#$host#$area#$time" >>${dir}/$logfilename

    done < <(echo "$t")
    echo "=== [$2] traceroute test ended===" >>${dir}/$logfilename
    echo ""
    echo "" >>${dir}/$logfilename
}

