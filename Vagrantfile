# -*- mode: ruby -*-
# vi: set ft=ruby :
#

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "ubuntu-14.4"
    config.vm.box_url = "https://github.com/kraksoft/vagrant-box-ubuntu/releases/download/14.04/ubuntu-14.04-amd64.box"
    config.ssh.insert_key = false
    config.ssh.forward_agent = true

    config.vm.provider :virtualbox do |v|
        v.name = "dotfiles"
        v.memory = 256
        v.cpus = 1
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--ioapic", "on"]
    end

    config.vm.hostname = "dotfiles"
    config.vm.network :private_network, ip: "192.168.20.60"
    config.vm.synced_folder "./","/tmp", {:mount_options => ['dmode=777','fmode=777']}

    #HostManager Start
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = false
    config.hostmanager.ignore_private_ip = true
    config.hostmanager.include_offline = true
    #HostManager Finish

    # Set the name of the VM. See: http://stackoverflow.com/a/17864388/100134
    config.vm.define "dotfiles" do |dotfiles|
    end

    # Ansible provisioner.
    config.vm.provision "ansible" do |ansible|
        ansible.playbook = "provision/ansible/playbook.yml"
        ansible.inventory_path = "provision/ansible/inventory"
        ansible.sudo = true
        ansible.verbose =  'vvvv'
        # ansible.extra_vars = { ansible_ssh_user: 'vagrant',
                               # ansible_connection: 'ssh',
                               # ansible_ssh_args: '-o ForwardAgent=yes'}
    end

    # hostmanager provisioner.
    config.vm.provision :hostmanager
end

# Load Vagrantfile.local to overwrite or extend default Vagrant configuration
load "Vagrantfile.local" if File.exists?("Vagrantfile.local")
