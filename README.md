# Cisco IOSv Vagrant box (libvirt)

A procedure for creating a Cisco IOSv Vagrant box for the [libvirt](https://libvirt.org) provider.

## Prerequisites

  * [Cisco VIRL](http://virl.cisco.com) account
  * [Git](https://git-scm.com)
  * [Python](https://www.python.org)
  * [Ansible](https://docs.ansible.com/ansible/latest/index.html) >= 2.7
  * [libvirt](https://libvirt.org) with client tools
  * [QEMU](https://www.qemu.org)
  * [Expect](https://en.wikipedia.org/wiki/Expect)
  * [Telnet](https://en.wikipedia.org/wiki/Telnet)
  * [Vagrant](https://www.vagrantup.com)
  * [vagrant-libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt)

## Steps

0\. Verify the prerequisite tools are installed.

<pre>
$ <b>which git python ansible libvirtd virsh qemu-system-x86_64 expect telnet vagrant</b>
</pre>

<pre>
$ <b>vagrant plugin list</b>
vagrant-libvirt (0.1.2, global)
</pre>

1\. Clone this GitHub repo and _cd_ into the directory.

<pre>
$ <b>git clone https://github.com/mweisel/cisco-iosv-vagrant-libvirt</b>
$ <b>cd cisco-iosv-vagrant-libvirt</b>
</pre>

2\. Log in and download the IOSv disk image file from your [Cisco VIRL](http://virl.cisco.com) account.

3\. Convert the IOSv disk image file from `vmdk` to `qcow2`.

<pre>
$ <b>qemu-img convert -pO qcow2 $HOME/Downloads/vios-adventerprisek9-m.vmdk.SPA.157-3.M3 $HOME/Downloads/cisco-iosv.qcow2</b>
$ <b>qemu-img check $HOME/Downloads/cisco-iosv.qcow2</b>
$ <b>qemu-img info $HOME/Downloads/cisco-iosv.qcow2</b>
</pre>

4\. Copy the converted IOSv disk image file to the `/var/lib/libvirt/images` directory.

<pre>
$ <b>sudo cp $HOME/Downloads/cisco-iosv.qcow2 /var/lib/libvirt/images</b>
</pre>

5\. Modify the file ownership and permissions. Note the owner may differ between Linux distributions.

> Arch Linux

<pre>
$ <b>sudo chown nobody:kvm /var/lib/libvirt/images/cisco-iosv.qcow2</b>
$ <b>sudo chmod u+x /var/lib/libvirt/images/cisco-iosv.qcow2</b>
</pre>

> Ubuntu 18.04

<pre>
$ <b>sudo chown libvirt-qemu:kvm /var/lib/libvirt/images/cisco-iosv.qcow2</b>
$ <b>sudo chmod u+x /var/lib/libvirt/images/cisco-iosv.qcow2</b>
</pre>

6\. Start the `vagrant-libvirt` network (if not already started).

<pre>
$ <b>virsh -c qemu:///system net-list</b>
$ <b>virsh -c qemu:///system net-start vagrant-libvirt</b>
</pre>

7\. Run the Ansible playbook.

<pre>
$ <b>ansible-playbook main.yml</b>
</pre>

8\. Add the Vagrant box to the local inventory.

<pre>
$ <b>vagrant box add --provider libvirt --name cisco-iosv-157-3.M3 ./cisco-iosv.box</b>
</pre>

## Debug

View the telnet session output for the `expect` task:

<pre>
$ <b>tail -f ~/iosv-console.explog</b>
</pre>

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
