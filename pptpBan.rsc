:local bufferName "memory";
:local listName "Blacklist";
:local timeout 180d;

:local prevMess "";
:local notFirstRunCheck false;

:foreach line in=[/log find buffer=$bufferName] do={
	:do {
		:local content [/log get $line message];
		:local badIP "";

		:if ($notFirstRunCheck and\
		([:find $prevMess "TCP connection established from"] >= 0) and\
		([:find $content "logged in,"] < 0))\
		do={
			:set badIP [:pick $prevMess 32 [:len $prevMess]];
			:if ([:len [/ip firewall address-list find address=$badIP and list=$listName]] <= 0)\
			do={
				/ip firewall address-list add list=$listName address=$badIP timeout=$timeout comment="by pptpBan (pptp)";
				:log warning "ip $badIP has been banned (pptp)";
				}
			}
			:if ($notFirstRunCheck = false) do={ :set notFirstRunCheck true; }

			:set prevMess $content;
		} on-error={ :log error "pptpBan Script has crashed"; }
	}
:log info "pptpBan Script was executed properly";