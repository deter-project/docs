# Nortel 10

## Configuration
	
	Nortel10#show vlan 
	Id  Name                 Type     Protocol         User PID Active IVL/SVL Mgmt
	--- -------------------- -------- ---------------- -------- ------ ------- ----
	1   default              Port     None             0x0000   Yes    IVL     No
		Port Members: NONE
	998 ITUNNEL              Port     None             0x0000   Yes    IVL     No
		Port Members: 2/1,2/25,7/18
	999 TUNNEL               Port     None             0x0000   Yes    IVL     No
		Port Members: 2/1,2/25,4/17
	2004 HWCONTROL            Port     None             0x0000   Yes    IVL     Yes
		Port Members: 2/25
	3204 dr3204               Port     None             0x0000   Yes    IVL     No
		Port Members: 2/1,2/25
	3205 dr3205               Port     None             0x0000   Yes    IVL     No
		Port Members: 2/1,2/25
	3206 dr3206               Port     None             0x0000   Yes    IVL     No
		Port Members: 2/1,2/25
	3801 dr3801               Port     None             0x0000   Yes    IVL     No
		Port Members: 2/1,2/25
	3802 dr3802               Port     None             0x0000   Yes    IVL     No
		Port Members: 2/1,2/25
	3803 dr3803               Port     None             0x0000   Yes    IVL     No
		Port Members: 2/1,2/25
	3808 dr3808               Port     None             0x0000   Yes    IVL     No
		Port Members: 2/1,2/25
	3809 dr3809               Port     None             0x0000   Yes    IVL     No
		Port Members: 2/1,2/25
	3810 dr3810               Port     None             0x0000   Yes    IVL     No
		Port Members: 2/1,2/25
	

	
	Nortel10#show stack-info
	Unit# Switch Model     Pluggable Pluggable Pluggable Pluggable SW Version
	                         Port      Port      Port      Port              
	----- ---------------- --------- --------- --------- --------- ----------
	1     5510-48T         (47) None (48) None                     v6.1.3.025
	2     5530-24TFD       (13) None (14) None (15) None (16) None v6.1.3.025
	                       (17) None (18) None (19) None (20) None 
	                       (21) None (22) None (23) None (24) None 
	                       (25) SR   (26) None 
	3     5510-48T         (47) None (48) None                     v6.1.3.025
	4     5510-48T         (47) None (48) None                     v6.1.3.025
	5     5510-48T         (47) None (48) None                     v6.1.3.025
	6     5510-48T         (47) None (48) None                     v6.1.3.025
	7     5510-48T         (47) None (48) None                     v6.1.3.025
	