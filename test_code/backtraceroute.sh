mtrinstall()
{
    apt-get >/dev/null 2>&1
	[ $? -le '1' ] && ( apt-get update >/dev/null 2>&1 | apt-get -y mtr >/dev/null 2>&1 )
	yum >/dev/null 2>&1
	[ $? -le '1' ] && yum -y install mtr >/dev/null 2>&1
}
mtrback(){
    type mtr >/dev/null 2>&1 || mtrinstall 
	echo "===测试 [$2] 的回程路由===" 
	mtr -r -w $1 
	echo -e "\n\n"

}

backtraceroute()
{
	next
	mtrback "221.229.173.1" "江苏徐州电信"

    mtrback "153.36.202.89" "江苏宿迁联通"

	mtrback "183.240.23.236" "广州移动"

	mtrback "101.89.132.5" "上海电信cn2"
}