# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu_13.04_i386"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-i386-vagrant-disk1.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network :forwarded_port, guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: "192.168.56.101"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network :public_network

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  # # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end
  #
  # View the documentation for the provider you're using for more
  # information on available options.
  
  # Setting for deploying on digitalocean
  config.vm.provider :digital_ocean do |provider, override|
    config.omnibus.chef_version = :latest
    override.ssh.private_key_path = '~/.ssh/id_rsa'
    #override.vm.box = 'digital_ocean'
    #override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
    provider.client_id = 'e2198de55f612d89a062b47145b1a7ea'
    provider.api_key = '3e31f3349f03295ff863a1b649213f24'
  end

  # Enable provisioning with chef server:
  config.vm.provision :shell, :inline => 'apt-get update; apt-get install build-essential ruby1.9.1-dev --no-upgrade --yes'
  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "ocax" # The opendatajda.vmx recipe
    chef.json = { 
        :mysql => { # MySQL default credentials
          :server_root_password => "ocax",
          :server_repl_password => "ocax",
          :server_debian_password => "ocax"
        }
    }
  end
end
