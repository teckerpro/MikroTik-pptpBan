# MikroTik-pptpBan
This script parses log and add to blacklist IP which established PPTP connection without login 

This script adds to the blacklist IPv4 addresses which:

- established PPTP connection without login
		
		TCP connection established from 192.0.2.1

- attempt find password for PPTP secret

		TCP connection established from 192.0.2.1
		<15>: user admin authentication failed

How to use

Create logging action

	/system logging action
	add memory-lines=60 name=YOUR_ACTION target=memory
	/system logging
	add action=YOUR_ACTION topics=pptp

Create firewall rule and address-list

	/ip firewall address-list add list=YOUR_BLACKLIST
	/ip firewall raw
	add action=drop chain=prerouting comment="Drop from blacklist" in-interface=ether-YOUR_WAN_INTERFACE \
		src-address-list=YOUR_BLACKLIST

Create script

	/system script
	add dont-require-permissions=no name=pptpBan owner=admin policy=\
		ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
		source="PUT HERE CODE FROM pptpBan.rsc"

Setup script

	bufferName is YOUR_ACTION (e.g. pptpBuffer)
	listName is YOUR_BLACKLIST (e.g Blacklist)
	timeout is YOUR_TIMEOUT (e.g. 90d if you want dynamic or leave empty if you want static)

Create scheduler witch your own interval, start-date and start-time

	/system scheduler
	add interval=1d name=pptpBan on-event="/system script run pptpBan" policy=\
		ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=oct/01/2018 start-time=00:00:00


