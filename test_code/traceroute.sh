

traceroute()
{
	wget -q --no-check-certificate https://raw.githubusercontent.com/91yun/91yuntest/master/traceroute.py 
	python -W ignore ${dir}/91yuntest/traceroute.py -l $logfilename -i $IP
}
