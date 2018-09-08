allping()
{
	next

	curl -s --user-agent "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36" --referer 'https://tools.ipip.net/ping.php' "https://tools.ipip.net/ping.php?v=4&a=send&host=${IP}&area=china" > ./allping.log
	wget -q --no-check-certificate https://raw.githubusercontent.com/91yun/91yuntest/master/test_code/allping.py 
	python -W ignore ${dir}/91yuntest/allping.py -l ${dir}/$logfilename -i $IP
	rm -rf ./allping.log
}
