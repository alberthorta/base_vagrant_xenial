Vagrant.configure("2") do |config|
    # BASE BOX
    config.env.enable
    config.vm.box = ENV['BOX']
    config.vm.boot_timeout = 240

    # Fix issue with jessie64 and vagrant shared
    config.vm.synced_folder "./", "/vagrant", type: :virtualbox

    # Configure hostmanager
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
    config.vm.define ENV['VMNAME'] do |node|
        node.vm.hostname = ENV['HOSTNAME']
        node.vm.network :private_network, type: "dhcp"
        node.hostmanager.aliases = []
    end

    config.hostmanager.ip_resolver = proc do |vm, resolving_vm|
    if hostname = (vm.ssh_info && vm.ssh_info[:host])
      `vagrant ssh -c "hostname -I"`.split()[1]
    end
    end

    config.vm.provider :virtualbox do |vb|
     vb.customize ["modifyvm", :id, "--usbehci", "off"]
     vb.customize ["modifyvm", :id, "--usbxhci", "off"]
    end
end

Vagrant.configure("2") do |config|
  config.vm.provision "shell", path: "./vagrant/provision.sh", env: {
    "HOSTNAME" => ENV['HOSTNAME'],
    "SERVICE" => ENV['SERVICE'],
    "VERSION" => ENV['VERSION'],
    "MYSQL_USER" => ENV['MYSQL_USER'],
    "MYSQL_PASSWORD" => ENV['MYSQL_PASSWORD'],
    "MYSQL_DB" => ENV['MYSQL_DB'],
    "BOX" => ENV['BOX'],
    "BOX_USER" => ENV['BOX_USER']
  }
end
