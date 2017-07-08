# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
	config.vm.box = "ARTACK/debian-jessie"
	config.vm.box_url = "https://atlas.hashicorp.com/ARTACK/boxes/debian-jessie"

	config.vm.network "private_network", ip: "10.0.0.25"
	config.vm.hostname = "bolt.local"
	config.hostsupdater.aliases = ["www.bolt.local"]

	config.vm.synced_folder "project/", "/var/www/bolt.local", type: "nfs"
	config.vm.provider "virtualbox" do |vb|
    	# Display the VirtualBox GUI when booting the machine
    	vb.gui = false

    	# Customize the amount of memory on the VM:
    	vb.memory = "4048"
    	vb.name = "Bolt"
    	vb.customize ["modifyvm", :id, "--usb", "on"]
    	vb.customize ["modifyvm", :id, "--usbehci", "off"]
  	end

  	config.vm.provision "ansible" do |ansible|
    	ansible.playbook = "provision/playbook.yml"
    	ansible.inventory_path = "provision/hosts"
    	ansible.limit = "all"
  	end

end
