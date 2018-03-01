ProjectX-DevBox with Bonus Automation
========

Python development box with ansible tower cli tools.

This box is set up with X11 support and Liclipse.

To connect to the pxdev's x11 environment to run Liclipse (from a Win7 host):

1. Install Xming and Putty.
2. run Xming. Hovering over the Xming icon in the task bar should display "Xming server:0.0"
3. Create a Putty session with the following config:
   * Host Name - 192.168.100.201 Port - 22
   * connection -> SSH -> X11 - tick Enable X11 forwarding, add ***localhost:0.0*** to X disply location. Make sure MIT-Magic-cookie-1 is selected.
4. Log into the pxdev VM in the putty shell
5. liclipse &

The above will run Liclipse as a GUI application as though it is a Windows application. However, its running environment will be the pxdev VM. This means that this Python development environment will have access to the tower-cli tools.

More help can be found [here](http://ruleoftech.com/2014/windows-and-x11-forwarding-with-xming).

ansible-tower-cli

tower-cli can be configured at a user or global level. This VM configuration copies the .tower-cli.cfg from ProjectX-DevBox/shared/ansible/files to the vagrant user home directory at creation time. this means that it will be reset everytime the VM is re-created, so if you change the tower-cli config, make sure you manually copy the changes back to the persistence directory.

***NOTE:*** tower-cli cannot use the ***admin*** user. It refuses to authenticate the admin user to use the api. You must set up a different user with the correct access privileges for your use case.

Further details on tower-cli can be found [here](http://docs.ansible.com/ansible-tower/2.3.0/html/towerapi/intro.html).

Automation bonus
----------------
Because its a bit of a faff running putty, aligning the config with Xming etc, just to start up an IDE:

Prerequisites:
* Putty/Plink
* Xming

After the VM is stood up, Vagrant will delegate to scripts\start_liclipse.bat. This script will start Xming (X11 server), create an X11 ssh session using Plink and start Liclipse ready for Python editing in the default workspace shared/dev. 