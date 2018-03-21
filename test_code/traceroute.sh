

traceroute()
{
	next
	wget -q --no-check-certificate https://raw.githubusercontent.com/91yun/91yuntest/master/test_code/traceroute.py 
	python -W ignore ${dir}/91yuntest/traceroute.py -l ${dir}/$logfilename -i $IP
}
