# -*- mode: ruby -*-
# vi: set ft=ruby :

# Specify minimum Vagrant version and Vagrant API version
Vagrant.require_version ">= 1.6.0"
VAGRANTFILE_API_VERSION = "2"

# Require YAML module
require 'yaml'
environment = ENV['ENVIRONMENT']


if environment.nil? || environment == ''
		environment = 'local'
end

# Read YAML file with box details
settings = YAML.load_file("provision/servers/#{environment}.yaml")

# Create boxes
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Iterate through entries in YAML file
    settings['servers'].each do |servers|
        config.vm.define servers["name"] do |srv|
            srv.vm.box = servers["box"]
            srv.vm.box_url = servers["url"]

            srv.ssh.insert_key = false
            srv.ssh.forward_agent = true
            srv.vm.network :private_network, ip: servers["ip"]
            srv.vm.hostname = servers["hostname"]
            srv.vm.synced_folder "./","/home/vagrant/fbp", {:mount_options => ['dmode=777','fmode=777']}

            srv.vm.provider :virtualbox do |vb|
                vb.name = servers["name"]
                vb.memory = servers["ram"]
                vb.cpus = 1
                vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
                vb.customize ["modifyvm", :id, "--ioapic", "on"]
            end

            srv.vm.provision "ansible" do |ansible|
                ansible.playbook = "provision/ansible/provision.yaml"
                ansible.inventory_path = settings["path_inventory"]
                # ansible.limit = settings["vagrant"]["limit"]
                ansible.verbose = settings["vagrant"]["verbose"]
                ansible.sudo = settings["vagrant"]["sudo"]
            end

            srv.vm.provision "ansible" do |ansible|
                ansible.playbook = "provision/ansible/deploy.yaml"
                ansible.inventory_path = settings["path_inventory"]
                # ansible.limit = settings["vagrant"]["limit"]
                ansible.verbose = settings["vagrant"]["verbose"]
                ansible.sudo = settings["vagrant"]["sudo"]
            end

        end

    end

end

load "Vagrantfile.local" if File.exists?("Vagrantfile.local")
