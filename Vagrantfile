# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/xenial64'

  config.vm.provider :virtualbox do |vb|
    vb.cpus = 2
    vb.memory = 2048
    vb.customize ['modifyvm', :id, '--nicpromisc0', 'allow-all']
  end

  config.vm.define :vault_demo_vm do |vault_demo_vm|
    vault_demo_vm.vm.hostname = 'vault-demo-vm'
    vault_demo_vm.vm.network :private_network, ip: '1.1.1.11'
    vault_demo_vm.vm.provision :shell, path: 'scripts/prepare.sh'
  end

end
