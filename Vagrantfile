Vagrant.configure("2") do |config|
    # BASE BOX
    config.vm.box = "ubuntu/xenial64"
    config.vm.boot_timeout = 240

    # Fix issue with jessie64 and vagrant shared
    config.vm.synced_folder "./", "/vagrant", type: :virtualbox

    # Configure hostmanager
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
    config.vm.define 'horta-local' do |node|
        node.vm.hostname = 'www.horta.local'
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
  config.vm.provision "shell", path: "./vagrant/provision.sh"
end