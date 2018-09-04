#!/usr/bin/env python
# -*- coding: utf-8 -*-

# import requests
import re
import json
import sys, getopt
# from requests.packages.urllib3.exceptions import InsecureRequestWarning 
# requests.packages.urllib3.disable_warnings(InsecureRequestWarning)


if sys.getdefaultencoding() != 'utf-8':
    reload(sys)
    sys.setdefaultencoding('utf-8')

opts, args = getopt.getopt(sys.argv[1:], "l:i:n:f:")
logfilename="91yuntest.log"
ip=''
filename=''
servername=''
for op, value in opts:
	if op == "-l":
		logfilename=value
	elif op == "-f":
		filename=value
	elif op == "-n":
		servername=value
	elif op == "-i":
		ip=value

def getip(iphtml):
	searchip=re.search("<a [^>]*>([^<]*)</a>",iphtml)
	if searchip:
		return searchip.group(1)
	else:
		return iphtml


def mtrgo(mtrurl,nodename):
	# send_headers={"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36",
    #           "Connection":"keep-alive",
    #           "Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
    #           "Accept-Language":"zh-CN,zh;q=0.8"}
	# text=requests.get(mtrurl,verify=False,headers=send_headers)
	# content=text.text
	with open(mtrurl,"r") as file:
		content=file.read()
	result=re.finditer(r"<script>parent\.resp_once\('(\d+)', (\[[^\]]*\])\)</script>",content)
	f=""
	print("===测试 ["+nodename+"] 到这台服务器的路由===")
	f="===start test traceroute from ["+nodename+"]===\n"
	for r in result:
		js=json.loads(r.group(2))
		f=f+"%s#%s#%s#%s#%s"%(r.group(1),getip(js[0]["ip"]),js[0]["host"],js[0]["area"],js[0]["time"])+"\n"
		print("%-5s%-20s%-30s%-45s"%(r.group(1),js[0]["host"],js[0]["area"],js[0]["time"]))
		print("\n")

	f=f+"=== ["+nodename+"] traceroute test ended===\n\n"
	with open(logfilename,"a+") as file:
		file.write(f)


mtrgo(filename,servername)
# mtrgo("https://tools.ipip.net/traceroute.php?as=1&v=4&a=get&n=1&id=100&ip="+ip,"上海电信（天翼云）")
# mtrgo("https://tools.ipip.net/traceroute.php?as=1&v=4&a=get&n=1&id=3&ip="+ip,"杭州联通")
# mtrgo("https://tools.ipip.net/traceroute.php?as=1&v=4&a=get&n=1&id=305&ip="+ip,"四川德阳移动")


