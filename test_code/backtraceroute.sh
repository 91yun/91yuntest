mtrinstall()
{
    apt-get >/dev/null 2>&1
	[ $? -le '1' ] && ( apt-get update >/dev/null 2>&1 | apt-get -y mtr >/dev/null 2>&1 )
	yum >/dev/null 2>&1
	[ $? -le '1' ] && yum -y install mtr >/dev/null 2>&1
}
mtrback(){
    type mtr >/dev/null 2>&1 || mtrinstall 
	echo "===测试 [$2] 的回程路由===" | tee -a ${dir}/$logfilename
	mtr -r --tcp -w -b -c 10 $1 | tee -a ${dir}/$logfilename
	echo -e "\n\n"
	echo -e "===回程 [$2] 路由测试结束===\n\n" >> ${dir}/$logfilename

}

backtraceroute()
{
	next
    mtrback "113.59.224.1" "北京电信(天翼云)"
	mtrback "221.229.173.1" "江苏徐州电信"
	mtrback "14.215.116.1" "广州电信（天翼云）"

    mtrback "60.214.107.1" "山东枣庄联通"
    mtrback "120.80.253.101" "江苏徐州联通"
    mtrback "122.13.195.129" "广东茂名联通"


	mtrback "111.45.135.25" "辽宁沈阳移动"
	mtrback "222.187.226.193" "江苏宿迁移动"
	mtrback "120.237.53.17" "广东茂名移动"
}