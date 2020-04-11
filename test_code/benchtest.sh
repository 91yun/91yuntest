bechinstall()
{
    apt-get >/dev/null 2>&1
	[ $? -le '1' ] && ( apt-get update >/dev/null 2>&1 | apt-get -y make automake gcc autoconf time perl >/dev/null 2>&1 )
	yum >/dev/null 2>&1
	[ $? -le '1' ] && yum -y install make automake gcc autoconf gcc-c++ time perl-Time-HiRes >/dev/null 2>&1
}
benchtest()
{	
	next
	
	# Download UnixBench5.1.3
	if ! wget -qc http://dl.lamp.sh/files/UnixBench5.1.3.tgz; then
		echo "Failed to download UnixBench5.1.3.tgz, please download it to ${cur_dir} directory manually and try again."
		exit 1
	fi
	tar xzf UnixBench5.1.3.tgz
	cd ${dir}/91yuntest/UnixBench/

	#Run unixbench
	make > /dev/null 2>&1
	echo "===开始测试bench===" >> ${dir}/${logfilename}
	./Run
	benchfile=`ls results/ | grep -v '\.'`
	cat results/${benchfile} >> ${dir}/${logfilename}
	echo "===bench测试结束===" >> ${dir}/${logfilename}	
	cd ..
	rm -rf UnixBench5.1.3.tgz UnixBench
}
