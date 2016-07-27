# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # The OS Image
  config.vm.box = "terrywang/archlinux"
  config.ssh.forward_x11 = true

  # Provisioning commands (init)
   config.vm.provision "shell", inline: <<-SHELL
      sudo pacman -Syy
      sudo pacman -S git nasm grub qemu xorriso qemu--noconfirm
      curl https://sh.rustup.rs -sSf > rup.sh
      chmod +x rup.sh
      ./rup.sh -y
      export PATH=$PATH:$HOME/.cargo/bin
      rustup override add nightly
      rustup default nightly
      rustup update
  SHELL


end
