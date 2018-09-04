#!/usr/bin/env python
# -*- coding: utf-8 -*-

#import requests
import re
import json
import sys, getopt
import os
#from requests.packages.urllib3.exceptions import InsecureRequestWarning 
#requests.packages.urllib3.disable_warnings(InsecureRequestWarning)
if sys.getdefaultencoding() != 'utf-8':
    reload(sys)
    sys.setdefaultencoding('utf-8')

opts, args = getopt.getopt(sys.argv[1:], "l:i:")
logfilename="91yuntest.log"
ip=''
for op, value in opts:
	if op == "-l":
		logfilename=value
	elif op == "-i":
		ip=value

def getip(iphtml):
	searchip=re.search("<a [^>]*>([^<]*)</a>",iphtml)
	if searchip:
		return searchip.group(1)
	else:
		return iphtml



def allping(gethtml):
	f="===all ping start===\n"
	f=f+"%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s"%("id","ping的地点","IP","IP所在地","丢包率","MIX","MAX","延迟","TTL")+"\n"
	result=re.finditer(r"<script>parent\.call_ping\(([^<]*)\);<\/script>",gethtml)
	for r in result:
		js=json.loads(r.group(1))
		f=f+"%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s"%(js["id"],js["name"],js["ip"],js["ip_area"],js["loss"],js["rtt_min"],js["rtt_max"],js["rtt_avg"],js["ttl"])+"\n"

	f=f+"===all ping end===\n\n"
	return f

def showping(gethtml):
	f="===ping show===\n"
	f=f+"%s\t%s\t%s\t%s\t%s\t%s\t%s\n"%("线路","节点数目","最快节点","延迟","最慢节点","延迟","平均延迟")+"\n"
	print("%-10s%-24s\t%-10s%-24s\t%-10s%-10s\n"%("线路","最快节点","延迟","最慢节点","延迟","平均延迟"))
	result=re.finditer(r"<script>parent\.summary_ping\(([^<]*)\)<\/script>",gethtml)
	for r in result:
		js=json.loads(r.group(1))
		for key in js:
			f=f+"%s\t%s\t%s\t%sms\t%s\t%sms\t%sms"%(key,js[key]["count"],js[key]["min_name"],js[key]["min_speed"],js[key]["max_name"],js[key]["max_speed"],js[key]["avg"])+"\n"
			print("%-10s%-24s\t%-10s%-24s\t%-10s%-10s\n"%(key.encode('utf-8'),js[key]["min_name"].encode('utf-8'),js[key]["min_speed"].encode('utf-8'),js[key]["max_name"].encode('utf-8'),js[key]["max_speed"].encode('utf-8'),js[key]["avg"].encode('utf-8')))
			
	f=f+"===ping show end===\n\n"
	return f





# send_headers={"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36",
# 			"Connection":"keep-alive",
# 			"Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
# 			"Accept-Language":"zh-CN,zh;q=0.8"}
# text=requests.get("https://tools.ipip.net/ping.php?v=4&a=send&host="+ip+"&area=china",verify=False,headers=send_headers)
# content=text.text
# comstr="curl \"https://tools.ipip.net/ping.php?v=4&a=send&host="+ip+"&area=china\""
# print(comstr)
# content=os.popen(comstr).read()

with open("./allping.log","r") as file:
	content=file.read()

c="===开始进行全国PING测试===\n"
c=c+allping(content)
c=c+showping(content)
c=c+"===进行全国PING测试结束===\n"
with open(logfilename,"a+") as file:
	file.write(c)



