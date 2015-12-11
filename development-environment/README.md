# SMACCMPilot Development Environment

The SMACCMPilot project has numerous dependencies that frequently change. In
order to ease the creation of a complete development environment, we provide a
complete environment as a [Vagrant][] VM. [Vagrant][] is a free tool for
creating, provisioning, and managing a virtual machine.

## Requirements

In order to use this development environment, you must have the following tools
present on your machine:

- [Vagrant][]
- [VirtualBox][]
- [Ansible][] 1.9

[Vagrant]: http://vagrantup.com
[VirtualBox]: https://virtualbox.org
[Ansible]: http://ansible.com

Additionally, you will need to have about 7GB of hard disk space and 4GB of
RAM available for use by the virtual machine. (The large amount of RAM is
required for building some complex Haskell packages, such as
`haskell-src-exts`).

## Using

If you have the dependencies installed, simply running

```sh
$ vagrant up
```

in the current directory will create a complete virtual machine. This operation
will download and install many dependencies, and build the SMACCMPilot
application. Expect it to take at least an hour to complete.

You can open a shell to interact with the system using `vagrant ssh`. More
information on how to use Vagrant in [their documentation][vagrant-docs].

To suspend a VM, use `vagrant suspend`. To permanently delete, and reclaim hard
disk space, use `vagrant destroy`.

[vagrant-docs]: https://docs.vagrantup.com/v2/

## Details

The included `Vagrantfile` specifies how to configure a virtual machine based on
the [Fedora 23 Cloud base image][f23base]. The Vagrantfile specifies that
VirtualBox provide 4GB of memory and 2 CPUs for the virtual machine.

[f23base]: https://atlas.hashicorp.com/fedora/boxes/23-cloud-base

If you have more memory or more CPUs available to devote to the VM, you can
expand this allocation by editing the `v.memory = 4096` and `v.cpus = 2`
specifications, respectively.

The Vagrantfile hands off the rest of provisioning to the Ansible tool. Ansible
uses the `smaccmpilot.yml` playbook to install all dependencies for the
SMACCMPilot development environment, and then build the SMACCMPilot flight
application.

If you want to reproduce the development environment on another type of machine,
please refer to the comments in the `tasks/basic_dev_tools.yml` file.

If you want to use the Ansible provisioner with a non-vagrant Fedora VM, create
an Ansible inventory file called `hosts` in this directory, and then use
`ansible-playbook smaccmpilot.yml -l <your host>` to provision the machine. We
have tested this method to provision a [Fedora 23 Workstation][f23w] machine.

[f23w]: https://getfedora.org/en/workstation/
