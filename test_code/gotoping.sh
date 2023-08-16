testping()
{
	echo "{start testing $2 ping}" 
	ping -c 5 $1 
	echo -e "\n\n"
	echo "{end testing}" 
}

gotoping()
{
	echo "===开始测试跳板ping==="
	next
	testping speedtest.tokyo2.linode.com Linode日本
	testping hnd-jp-ping.vultr.com Vultr日本
	testping 192.157.214.6 Budgetvm洛杉矶
	testping speedtest.kdatacenter.com kdatacenter韩国SK
	testping 210.92.18.1 星光韩国KT
	echo "===跳板ping测试结束==="
}
