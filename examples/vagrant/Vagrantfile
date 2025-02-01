# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64" # Use a current box

  # Private network for better isolation
  config.vm.network "private_network", ip: "192.168.33.10"

  # Forwarded Ports
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 9000, host: 9000

  # NFS Sharing (Conditional - Modern Vagrant handles Windows sharing better)
  if !Vagrant::Util::Platform.windows? # More robust Windows check
    config.vm.synced_folder ".", "/vagrant", type: "nfs", nfs_version: 4 # Explicit NFS version
    config.vm.synced_folder "./web", "/vagrant/web", type: "nfs", nfs_version: 4
  else
    config.vm.synced_folder ".", "/vagrant" # Default synced folder for Windows
    config.vm.synced_folder "./web", "/vagrant/web"
  end

  # Provisioning with Chef Solo
  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = ["chef/cookbooks", "chef/site-cookbooks"]

    # Ensure apt updates first for package availability
    chef.add_recipe "apt" 
    chef.add_recipe "build-essential"
    chef.add_recipe "openssl"
    chef.add_recipe "apache2"
    chef.add_recipe "sqlite"
    chef.add_recipe "php" # Core PHP setup

    # PHP Modules - More modular and maintainable
    %w(curl gd sqlite3 apc).each do |mod|
      chef.add_recipe "php::module_#{mod}"
    end

    chef.add_recipe "chef-xdebug" # Debugging tool
    chef.add_recipe "chef-curl"   # Often included with PHP

    # Apache2 modules
    chef.add_recipe "apache2::mod_php"
    chef.add_recipe "apache2::mod_rewrite"

    # Custom Site Recipe
    chef.add_recipe "Site"
  end
end
