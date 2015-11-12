A Linux-based penetration testing package best used through its X11 GUI.
For example, to drive _pcNNN'' running this image from ''workstation_:
	
	    pcNNN% sudo -H vncserver -geometry 1200x900
	    workstation% vncviewer -via users.isi.deterlab.net pcNNN:1
	