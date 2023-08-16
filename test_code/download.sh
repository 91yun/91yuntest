speed_test() {
    speedtest=$(wget -4O /dev/null --inet4-only -T300 $1 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}')
    ipaddress=$(ping -4 -c1 -n `awk -F'/' '{print $3}' <<< $1` | awk -F'[()]' '{print $2;exit}')
    nodeName=$2
    if   [ "${#nodeName}" -lt "8" ]; then
        echo -e "$2\t\t\t\t$ipaddress\t\t$speedtest" 
    elif [ "${#nodeName}" -lt "13" ]; then
        echo -e "$2\t\t\t$ipaddress\t\t$speedtest" 
    elif [ "${#nodeName}" -lt "24" ]; then
        echo -e "$2\t\t$ipaddress\t\t$speedtest" 
    elif [ "${#nodeName}" -ge "24" ]; then
        echo -e "$2\t$ipaddress\t\t$speedtest" 
    fi
}

download()
{
	echo "===开始测试下载速度==="
	next
	echo -e "Node Name\t\t\tIPv4 address\t\tDownload Speed" 
    speed_test 'http://cachefly.cachefly.net/100mb.test' 'CacheFly'
    speed_test 'http://speedtest.tokyo2.linode.com/100MB-tokyo2.bin' 'Linode, Tokyo, JP'
    speed_test 'http://speedtest.london.linode.com/100MB-london.bin' 'Linode, London, UK'
    speed_test 'http://speedtest.fremont.linode.com/100MB-fremont.bin' 'Linode, Fremont, CA'
    speed_test 'http://speedtest.sng01.softlayer.com/downloads/test100.zip' 'Softlayer, Singapore, SG'
}
