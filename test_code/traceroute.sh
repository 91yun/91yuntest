

traceroute()
{
	yum install -y epel-release
	yum install -y python-pip
	pip install requests


	wget -q --no-check-certificate https://raw.githubusercontent.com/91yun/91yuntest/test/traceroute.py 
	python -W ignore traceroute.py -l $logfilename -i $IP
}
