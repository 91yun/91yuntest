allping()
{
	next
	wget -q --no-check-certificate https://raw.githubusercontent.com/91yun/91yuntest/master/test_code/allping.py 
	python -W ignore ${dir}/91yuntest/allping.py -l ${dir}/$logfilename -i $IP
}