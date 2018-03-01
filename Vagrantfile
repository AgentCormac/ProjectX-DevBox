################################################################
#
# Author: 	Mark Higginbottom
#
# Date:		28/02/2018
#
# Vagrant PROJECT file to create Ansible pxdev provisioned VM on VirtualBox
#
# This vagrant file creates a centos/7 box on Virtual box and then
# bootstraps Ansible to buils the stack. The boot strap ansible script 
# is in shared\ansible\site.yml
# 
# shared directory is mapped to VM -> /home/vagrant/shared
#
# Dependencies:
#     vagrant plugin install vagrant-triggers
#     vagrant plugin install vagrant-vbguest
#################################################################
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'


Vagrant.configure("2") do |config|
  config.ssh.insert_key = false

##pxdev VM
  config.vm.define "pxdev" do |pxdev|
    #pxdev.vm.box = "centos/7"
    pxdev.vm.box = "bento/centos-7.4"
    pxdev.vm.hostname = 'pxdev'

    pxdev.vm.network :private_network, ip: "192.168.100.201"
    pxdev.vm.network :forwarded_port, guest: 22, host: 20122, id: "ssh"
    pxdev.vm.network :forwarded_port, guest: 7272, host: 27272, id: "pxdevtestport"

	#VirtualBox configuration
    pxdev.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--name", "pxdev"]
      v.customize ["modifyvm", :id, "--memory", 2048]
      v.customize ["modifyvm", :id, "--description", "pxdev/Tower server"]
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]	#turn on host DNS resolver
      v.customize ["modifyvm", :id, "--natdnsproxy1", "off"]			#turn on DNS on VM in case of host dns problem
	    v.customize ['modifyvm', :id, '--cableconnected1', 'on']		#make sure "cables connected for VM network interfaces
# Show VM?
#	  v.gui = true
    end

	#map shared directory
  pxdev.vm.synced_folder "shared", "/home/vagrant/shared"

	pxdev.vm.provision "shell", inline: <<-SHELL
		ls -al shared
		#Basic vanilla installation to bootstrap Ansible.
		#set ownership of shared directory to vagrant
		sudo chown -R vagrant:vagrant /home/vagrant/shared
		##Install Ansible on pxdev node
		#sudo apt-get update -y
		sudo yum update -y
		sudo yum install vim -y
		sudo yum install epel-release -y
		sudo yum install ansible -y
		sudo yum install yum-utils
		##Install Git
		sudo yum install git -y
		##Turn off ansible key checking
		export ANSIBLE_HOST_KEY_CHECKING=false
	SHELL

	##run info script
    pxdev.vm.provision "info", type: "shell", path: "scripts/vminfo.sh"

	##Ansible provisioning from playbook that is on the Guest VM
	pxdev.vm.provision "ansible_local" do |ansible|
		ansible.verbose = "true"
		ansible.extra_vars = {servers: "pxdev"} #inject the name of the server we want to apply this ansible config to.
		ansible.galaxy_role_file = "shared/ansible/requirements.yml" #pre-provision any ansible roles before running the main playbook
		ansible.playbook = "shared/ansible/site.yml"
    end

	#map to modified pxdev role data store directory
  #  pxdev.vm.synced_folder "pxdev/", "/opt/pxdev"

	  # start liclipse in a host X11 session on the guest after the guest starts
		#need to set up the path to plink because windows paths with spaces mess everything up!
		config.trigger.after :up, :append_to_path => "C:\Program Files (x86)\PuTTY" do
			run "scripts\\start_liclipse.bat"
    end
	  # backup up GUEST DB files before the guest is destroyed
    config.trigger.before :destroy, :vm => ["pxdev"] do
#      run_remote "shared/util/backup_pxdev_db.sh"
    end
	  # clean up HOST files on the host after the guest is destroyed
    config.trigger.after :destroy do
      run "scripts\\reset_known_hosts.bat"
    end
  end

####################################################################################################################
####################################################################################################################
####################################################################################################################
end
