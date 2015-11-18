# Serial 5

Serial5 is hooked to all of the ISI switches and critical infrastructure except for gatekeeper (if that goes down, you can't get to serial5).

Serial5 also has a direct link to serial2 which handles our serial power controllers.

Serial5 is also hooked up to Gatekeeper so if it is unreachable over the network, access is still possible.

	
	gatekeeper# tip serial5
	connected
	
	FreeBSD/i386 (serial5.isi.deterlab.net) (ttyd0)
	
	login:
	

Here is the current setup for serial5:

	
	# Deterlab Switches
	HP4c1|hp4c1:dv=/dev/cuaC00:br#9600:pa=none:
	HP10c1|hp10c1:dv=/dev/cuaC01:br#9600:pa=none:
	HP18c1|hp18c1:dv=/dev/cuaC02:br#9600:pa=none:
	HP4|hp4:dv=/dev/cuaC03:br#9600:pa=none:
	HP19|hp19:dv=/dev/cuaC04:br#9600:pa=none:
	cisco4:dv=/dev/cuaC05:br#9600:pa=none:
	# Master Pizza Box
	nortel10:dv=/dev/cuaC06:br#9600:pa=none:
	# 10G pizza box 2
	nortel10-2:dv=/dev/cuaC07:br#9600:pa=none:
	nortel18ne:dv=/dev/cuaC08:br#9600:pa=none:
	
	# Non-DRAC based hosts
	bgwc:dv=/dev/cuaC09:br#115200:pa=none:
	bgwe:dv=/dev/cuaC0a:br#115200:pa=none:
	router:dv=/dev/cuaC0b:br#57600:pa=none:
	scratch:dv=/dev/cuaC0c:br#115200:pa=none:
	aka:dv=/dev/cuaC0d:br#115200:pa=none:
	serial2:dv=/dev/cuaC0f:br#115200:pa=none:
	
	# Misc stuff hooked up to serial5
	# Secure 64 Defender box
	defender:dv=/dev/cuaCla:br#9600:pa=none:
	jnpr1|j1:dv=/dev/cuaC1b:br#9600:pa=none:
	jnpr2|j2:dv=/dev/cuaC1c:br#9600:pa=none:
	jnpr3|j3:dv=/dev/cuaC1d:br#9600:pa=none:
	jnpr4|j4:dv=/dev/cuaC1e:br#9600:pa=none:
	#jnpr5|j5:dv=/dev/cuaC1f:br#9600:pa=none:
	