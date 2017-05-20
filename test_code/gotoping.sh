testping()
{
	echo "{start testing $2 ping}" | tee -a $logfilename
	ping -c 10 $1 | tee -a $logfilename
	echo "{end testing}" | tee -a $logfilename
}

gotoping()
{
	echo "===开始测试跳板ping===">>$logfilename
	next
	testping speedtest.tokyo.linode.com Linode日本
	testping hnd-jp-ping.vultr.com Vultr日本
	testping 192.157.214.6 Budgetvm洛杉矶
	testping downloadtest.kdatacenter.com kdatacenter韩国SK
	testping 210.92.18.1 星光韩国KT
	echo "===跳板ping测试结束===">>$logfilename
}