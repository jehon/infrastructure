# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # https://docs.vagrantup.com.

  # https://vagrantcloud.com/search.
  config.vm.box = "debian/testing64"
  config.ssh.username = "root"
  config.ssh.password = "vagrant"

  config.vm.synced_folder ".", "/workspace", type: "rsync"
  # config.vm.synced_folder "tmp/00-parameters.yml", "/workspace/inventory/00-parameters.yml", type: "rsync"

  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end

  config.vm.provision "shell", inline: <<-SHELL
    echo "inside"
    # apt-get update
    # apt-get install -y apache2
  SHELL
end
