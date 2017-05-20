

io_test() {
    (LANG=en_US dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//'
}

io()
{
	#获得相关数据
	io1=$( io_test )
	io2=$( io_test )
	io3=$( io_test )
	ioraw1=$( echo $io1 | awk 'NR==1 {print $1}' )
	[ "`echo $io1 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw1=$( awk 'BEGIN{print '$ioraw1' * 1024}' )
	ioraw2=$( echo $io2 | awk 'NR==1 {print $1}' )
	[ "`echo $io2 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw2=$( awk 'BEGIN{print '$ioraw2' * 1024}' )
	ioraw3=$( echo $io3 | awk 'NR==1 {print $1}' )
	[ "`echo $io3 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw3=$( awk 'BEGIN{print '$ioraw3' * 1024}' )
	ioall=$( awk 'BEGIN{print '$ioraw1' + '$ioraw2' + '$ioraw3'}' )
	ioavg=$( awk 'BEGIN{print '$ioall'/3}' )

	#显示在屏幕上
	next
	echo "I/O speed(1st run)   : $io1"
	echo "I/O speed(2nd run)   : $io2"
	echo "I/O speed(3rd run)   : $io3"
	echo "Average I/O speed    : $ioavg MB/s"

	#写入日志文件
	echo "===开始测试IO性能===">>${dir}/$logfilename
	echo "I/O speed(1st run) : $io1">>${dir}/$logfilename
	echo "I/O speed(2nd run) : $io2">>${dir}/$logfilename
	echo "I/O speed(3rd run) : $io3">>${dir}/$logfilename
	echo "Average I/O: $ioavg MB/s">>${dir}/$logfilename
}