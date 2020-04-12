curlinstall()
{
    apt-get >/dev/null 2>&1
	[ $? -le '1' ] && ( apt-get update >/dev/null 2>&1 | apt-get -y curl >/dev/null 2>&1 )
	yum >/dev/null 2>&1
	[ $? -le '1' ] && yum -y install curl >/dev/null 2>&1
}
allping()
{
    type curl >/dev/null 2>&1 || curlinstall
	next
	curl -s --user-agent "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36" --referer 'https://tools.ipip.net/ping.php' "https://tools.ipip.net/ping.php?v=4&a=send&host=${IP}&area=china" > ./allping.log
    ipipallpingsum
    ipipallpinglog
}


ipipallpingsum()
{
    echo "===ping show===" >>${dir}/$logfilename
    t=`cat allping.log`
    t=`echo -e "$t" | grep -oE "<script>parent\.summary_ping\([^<]*\)<\/script>" | sed -r 's@<script>parent.summary_ping\(([^<]*)\)<\/script>@\1@g'`
    t=`echo "$t" | grep -oE '"[^"]*":{"count":[^,]*,"total":"[^,]*","min_speed":"[^,]*","min_name":"[^,]*","max_speed":"[^,]*","max_name":"[^,]*","avg":"[^,]*"}' `
    printf "%-10s\t%-24s\t%-10s%-24s\t%-10s%-10s\n" "线路" "最快节点" "延迟" "最慢节点" "延迟" "平均延迟"
    echo -e "线路\t节点数目\t最快节点\t延迟\t最慢节点\t延迟\t平均延迟" >>${dir}/$logfilename
    while read line || [ -n "$line" ]
    do

    key=`echo "$line" | awk -F ":{" '{print $1}' | sed 's/"//g'`
    count=`echo "$line" | grep -oE '"count":[0-9]+' | awk -F ":" '{print $2}'`
    min_name=`echo "$line" | grep -oE '"min_name":"[^,]*"' | sed 's/"//g' | awk -F ":" '{print $2}'`
    min_speed=`echo "$line" | grep -oE '"min_speed":"[^,]*"' | sed 's/"//g' | awk -F ":" '{print $2}'`
    max_name=`echo "$line" | grep -oE '"max_name":"[^,]*"' | sed 's/"//g' | awk -F ":" '{print $2}'`
    max_speed=`echo "$line" | grep -oE '"max_speed":"[^,]*"' | sed 's/"//g' | awk -F ":" '{print $2}'`
    avg=`echo "$line" | grep -oE '"avg":"[^,]*"' | sed 's/"//g' | awk -F ":" '{print $2}'`

    printf "%-10s\t%-24s\t%-10s%-24s\t%-10s%-10s\n" "$key" "$min_name" "$min_speed" "$max_name" "$max_speed" "$avg"
    echo -e "$key\t$count\t$min_name\t$min_speed\t$max_name\t$max_speed\t$avg" >>${dir}/$logfilename
    done < <(echo "$t")
    echo "===ping show end===" >>${dir}/$logfilename
    echo "" >>${dir}/$logfilename
}

ipipallpinglog()
{
    t=`grep -oE '<script>parent\.call_ping\([^<]*\);<\/script>' ./allping.log | sed 's@"text":"[^"]*",@@g'  | sed 's@"link_url":"[^"]*"@@g' | sed 's@"link_name":"[^"]*",@@g'`
    t=`echo -e "$t" | sed -r 's@<script>parent\.call_ping\(([^<]*)\);<\/script>@\1@g'`
    echo "===all ping start===" >>${dir}/$logfilename
    echo "id\tping的地点\tIP\tIP所在地\t丢包率\tMIX\tMAX\t延迟\tTTL" >>${dir}/$logfilename
    while read line || [ -n "$line" ]
    do 
    id=`echo "$line" | grep -oE '"id":[0-9]+' | awk -F ":" '{print $2}'`
    name=`echo "$line" | grep -oE '"name":"[^,]*"' | sed 's/"//g' | awk -F ":" '{print $2}'`
    ip=`echo "$line" | grep -oE '"ip":"[^,]*"' | sed 's/"//g' | awk -F ":" '{print $2}'`
    ip_area=`echo "$line" | grep -oE '"ip_area":"[^,]*"' | sed 's/"//g' | awk -F ":" '{print $2}'`
    loss=`echo "$line" | grep -oE '"loss":"[^,]*"' | sed 's/"//g' | awk -F ":" '{print $2}'`
    rtt_min=`echo "$line" | grep -oE '"rtt_min":"[^,]*"' | sed 's/"//g' | awk -F ":" '{print $2}'`
    rtt_max=`echo "$line" | grep -oE '"rtt_max":"[^,]*"' | sed 's/"//g' | awk -F ":" '{print $2}'`
    rtt_avg=`echo "$line" | grep -oE '"rtt_avg":"[^,]*"' | sed 's/"//g' | awk -F ":" '{print $2}'`
    ttl=`echo "$line" | grep -oE '"ttl":"[^,]*"' | sed 's/"//g' | awk -F ":" '{print $2}'`

    echo -e "$id\t$name\t$ip\t$ip_area\t$loss\t$rtt_min\t$rtt_max\t$rtt_avg\t$ttl" >>${dir}/$logfilename
    done < <(echo -e "$t")
    echo "===all ping end===" >>${dir}/$logfilename
    echo "" >>${dir}/$logfilename
}
