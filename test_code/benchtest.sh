benchtest()
{

	if [ "$os" == 'centos' ]; then
		yum -y install make gcc gcc-c++ gdbautomake autoconf time perl-Time-HiRes python perl
	else
		apt-get update
		apt-get -y install perl python automake autoconf time make gcc gdb
	fi
	
	# Download UnixBench5.1.3
	if [ -s UnixBench5.1.3.tgz ]; then
		echo "UnixBench5.1.3.tgz [found]"
	else
		echo "UnixBench5.1.3.tgz not found!!!download now..."
		if ! wget -c http://lamp.teddysun.com/files/UnixBench5.1.3.tgz; then
			echo "Failed to download UnixBench5.1.3.tgz, please download it to ${cur_dir} directory manually and try again."
			exit 1
		fi
	fi
	tar -xzf UnixBench5.1.3.tgz
	cd UnixBench/

	#Run unixbench
	make
	echo "===开始测试bench===" | tee -a ../${logfilename}
	./Run
	benchfile=`ls results/ | grep -v '\.'`
	cat results/${benchfile} >> ../${logfilename}
	echo "===bench测试结束===" | tee -a ../${logfilename}	
	cd ..
	rm -rf UnixBench5.1.3.tgz UnixBench
}