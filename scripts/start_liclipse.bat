REM ###########################################################################
REM # 
REM # Mark Higginbottom
REM # 
REM # ProjectX-DevBox
REM # 
REM # 01/03/2018
REM # 
REM # start liclipse in a host X11 session on the guest after the guest starts
REM # need to set up the path to plink because windows paths with spaces mess everything up!
REM # starts liclipse in default workspace of shared/dev
REM # 
REM # Assumes:
REM # Plink/putty, Xming installed
REM # plink/putty home directory: "C:\Program Files (x86)\PuTTY"
REM # dev node ip: 192.168.100.201
REM # runs as vagrant user
REM # 
REM ###########################################################################
set path="C:\Program Files (x86)\PuTTY";"C:\Program Files (x86)\Xming";%PATH%
start /B Xming.exe :0 -clipboard -multiwindow -dpi 108
start /B plink.exe -ssh -2 -l vagrant -pw vagrant -X -t 192.168.100.201 liclipse -data shared/dev