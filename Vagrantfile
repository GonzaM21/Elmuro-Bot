# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'nicopaez/rubykatas'
  config.vm.box_version = '20201'

  config.vm.network 'forwarded_port', guest: 3000, host: 3000
  config.vm.hostname = 'memo2'
  config.vm.provider 'virtualbox' do |vb|
    vb.memory = '1024'
    vb.name = config.vm.hostname
    vb.customize ['modifyvm', :id, '--uartmode1', 'disconnected']
  end
end
