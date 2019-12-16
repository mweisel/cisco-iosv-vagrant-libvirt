A procedure for creating a Cisco IOSv Vagrant box for the [libvirt](https://libvirt.org) provider.

## Prerequisites

  * [Cisco VIRL](http://virl.cisco.com) account
  * [Git](https://git-scm.com)
  * [Python](https://www.python.org)
  * [Ansible](https://docs.ansible.com/ansible/latest/index.html)
  * [libvirt](https://libvirt.org) with client tools
  * [QEMU](https://www.qemu.org)
  * [Expect](https://en.wikipedia.org/wiki/Expect)
  * [Telnet](https://en.wikipedia.org/wiki/Telnet)
  * [Vagrant](https://www.vagrantup.com)
  * [vagrant-libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt)

## Steps

0. Verify the prerequisite tools are installed.

```
which git python ansible libvirtd virsh qemu-system-x86_64 expect telnet vagrant
vagrant plugin list
```

1. Clone this GitHub repo and _cd_ into the directory.

```
git clone https://github.com/mweisel/cisco-iosv-vagrant-libvirt
cd cisco-iosv-vagrant-libvirt
```

2. Log in and download the IOSv disk image file from your [Cisco VIRL](http://virl.cisco.com) account.

3. Convert the IOSv disk image file from `vmdk` to `qcow2`.

```
qemu-img convert -pO qcow2 $HOME/Downloads/vios-adventerprisek9-m.vmdk.SPA.157-3.M3 $HOME/Downloads/cisco-iosv.qcow2
qemu-img check $HOME/Downloads/cisco-iosv.qcow2
qemu-img info $HOME/Downloads/cisco-iosv.qcow2
```

4. Copy the converted IOSv disk image file to the `/var/lib/libvirt/images` directory.

```
sudo cp $HOME/Downloads/cisco-iosv.qcow2 /var/lib/libvirt/images
```

5. Modify the file ownership and permissions. Note the owner will differ between Linux distributions. A couple of examples:

> Arch Linux
```
sudo chown nobody:kvm /var/lib/libvirt/images/cisco-iosv.qcow2
sudo chmod u+x /var/lib/libvirt/images/cisco-iosv.qcow2
```

> Ubuntu 18.04
```
sudo chown libvirt-qemu:kvm /var/lib/libvirt/images/cisco-iosv.qcow2
sudo chmod u+x /var/lib/libvirt/images/cisco-iosv.qcow2
```

6. Start the `vagrant-libvirt` network (if not already started).

```
virsh -c qemu:///system net-list
virsh -c qemu:///system net-start vagrant-libvirt
```

7. Run the Ansible playbook. 

```
ansible-playbook main.yml
```

8. Add the Vagrant box. 

```
vagrant box add --provider libvirt --name cisco-iosv-157-3.M3 ./cisco-iosv.box
```

![demo screenshot](https://res.cloudinary.com/binarynature/image/upload/v1576528555/cisco-iosv-vagrant-libvirt_vj6ewc.png)

## Debug

To view the telnet session output for the `expect` task:

```
tail -f ~/iosv-console.explog
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
