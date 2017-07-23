ping_test(){
	
	pingurl="http://www.ipip.net/ping.php?a=send&host=$1&area%5B%5D=china"
	pingstr=$(curl -s "$pingurl")
	#echo $pingstr >> ${dir}/$logfilename
	echo $pingstr > pingstr.log
	pingstrback_all=$(curl -s -d @pingstr.log "http://logfileupload.91yuntest.com/ping.php?ping")
	pingstrback=$(curl -s -d @pingstr.log "http://logfileupload.91yuntest.com/ping.php")
	rm -rf pingstr.log


	
	
	#显示在显示器
	next
	
	#记录进日志
	echo "===开始进行全国PING测试===">>${dir}/$logfilename
	echo "===all ping start===" >> ${dir}/$logfilename
	echo -e $pingstrback_all | awk -F '^' '{printf("%-3s\t%-30s\t%-15s\t%-20s\t%-3s\t%-7s\t%-7s\t%-7s\t%-3s\n",$1,$2,$3,$4,$5,$6,$7,$8,$9)}' >> ${dir}/$logfilename
	echo -e "===all ping end===\n\n" >> ${dir}/$logfilename
	echo "===ping show===" >> ${dir}/$logfilename
	echo -e $pingstrback | awk -F '^' '{printf("%-8s%-24s\t%-10s%-24s\t%-10s%-10s\n",$1,$3,$4,$5,$6,$7)}'
	echo -e $pingstrback | awk -F '^' '{printf("%-10s\t%-10s\t%-30s\t%-10s\t%-30s\t%-30s\t%-30s\n",$1,$2,$3,$4,$5,$6,$7)}'>>${dir}/$logfilename
	echo -e "===ping show end===\n\n" >> ${dir}/$logfilename
	echo "===进行全国PING测试结束===">>${dir}/$logfilename
}

allping()
{
	ping_test $IP
}