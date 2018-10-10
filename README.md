# MikroTik-pptpBan
This script parses log and add to blacklist IP which established PPTP connection without login 

How to use

Create logging action or use memory

	/system logging action
	add memory-lines=50 name=YourAction target=memory
	/system logging
	add action=YourAction topics=pptp

Create script

	/system script
	add dont-require-permissions=no name=pptpBan owner=admin policy=\
		ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
		source=" Put Here Script "

Create firewall rule and Blacklist

	/ip firewall raw
	add action=drop chain=prerouting comment="Drop from blacklist" in-interface=ether-YourWANinterface \
		src-address-list=Blacklist
	/ip firewall address-list add list=YourBlacklist

Setup script

	bufferName is YourAction or memory
	listName is YourBlacklist
	timeout is YourTimeout

Create scheduler witch your own interval, start-date and start-time

	/system scheduler
	add interval=1d name=pptpBan on-event="/system script run pptpBan" policy=\
		ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=oct/01/2018 start-time=01:00:00


This script adds to the blacklist IPv4 addresses which:

- established PPTP connection without login
		
		TCP connection established from ip.ip.ip.ip
