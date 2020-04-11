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
    python_ver=$(ls /usr/bin|grep -e "^python[23]\.[1-9]\+$"|tail -1)
	curl -s --user-agent "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36" --referer 'https://tools.ipip.net/ping.php' "https://tools.ipip.net/ping.php?v=4&a=send&host=${IP}&area=china" > ./allping.log
	wget -q --no-check-certificate https://raw.githubusercontent.com/91yun/91yuntest/master/test_code/allping.py  >/dev/null 2>&1
	${python_ver} -W ignore ./allping.py -l ${dir}/$logfilename -i $IP
	rm -rf ./allping.log
}

