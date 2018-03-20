#!/usr/bin/env python
# -*- coding: utf-8 -*-

import requests
import re
import json
import sys, getopt
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


def mtrgo(mtrurl,nodename):
	text=requests.get(mtrurl,verify=False)
	content=text.text
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



mtrgo("https://www.ipip.net/traceroute.php?as=1&a=get&n=1&id=100&ip="+ip,"上海电信（天翼云）")
mtrgo("https://www.ipip.net/traceroute.php?as=1&a=get&n=1&id=3&ip="+ip,"杭州联通")
mtrgo("https://www.ipip.net/traceroute.php?as=1&a=get&n=1&id=305&ip="+ip,"四川德阳移动")


