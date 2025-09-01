![Vagrant](https://img.shields.io/badge/vagrant%20-%231563FF.svg?&style=for-the-badge&logo=vagrant&logoColor=white) ![netlab](https://img.shields.io/badge/netlab-d26400?style=for-the-badge)

# Cisco IOSv Vagrant box

A procedure for creating a Cisco IOSv Vagrant box for the [libvirt](https://libvirt.org) provider.

## Prerequisites

- [Cisco Modeling Labs](https://www.cisco.com/site/us/en/learn/training-certifications/training/modeling-labs) subscription
- [Git](https://git-scm.com)
- [uv](https://docs.astral.sh/uv)
- [libvirt](https://libvirt.org) with client tools
- [QEMU](https://www.qemu.org)
- [Vagrant](https://developer.hashicorp.com/vagrant) >= 2.4.0
- [vagrant-libvirt](https://vagrant-libvirt.github.io/vagrant-libvirt)
- [unzip](https://linux.die.net/man/1/unzip)
- [Expect](https://en.wikipedia.org/wiki/Expect)
- [Telnet](https://en.wikipedia.org/wiki/Telnet)

## Steps

0\. Verify the prerequisite tools are installed.

```
which git uv unzip libvirtd virsh qemu-system-x86_64 expect telnet vagrant
```

```
vagrant plugin list
```

1\. Point your web browser to the [CML Software Download](https://software.cisco.com/download/home/286193282/type/286326381/release/2.9.0) page.

2\. Click the **Download** icon for the **Cisco Modeling Labs reference platform ISO file (June 2025)**.

3\. Save the `refplat-20250616-fcs-iso.zip` file to your **Downloads** folder.

4\. Open your favorite terminal emulator, and change to the `Downloads` directory.

```
cd ~/Downloads
```

5\. Create the `cml29-refplat` directory.

```
mkdir -p cml29-refplat
```

6\. Uncompress the `refplat-20250616-fcs-iso.zip` file into the `cml29-refplat`directory.

```
unzip refplat-20250616-fcs-iso.zip -d cml29-refplat
```

7\. Change to the `cml29-refplat` directory.

```
cd cml29-refplat
```

8\. Create a mount point directory.

```
sudo mkdir -p /mnt/iso
```

9\. Mount the ISO file.

```
sudo mount -o loop refplat-20250616-fcs.iso /mnt/iso
```

10\. Copy (and rename) the Cisco IOSv disk image file to the `/var/lib/libvirt/images` directory.

```
sudo cp /mnt/iso/virl-base-images/iosv-159-3-m10/vios-adventerprisek9-m.spa.159-3.m10.qcow2 /var/lib/libvirt/images/cisco-iosv.qcow2
```

11\. Unmount the ISO file.

```
sudo umount /mnt/iso
```

12\. Modify the file ownership.

> The owner and/or group will differ between Linux distributions.

```
sudo chown libvirt-qemu:libvirt-qemu /var/lib/libvirt/images/cisco-iosv.qcow2
```

13\. Set the file as executable.

```
sudo chmod u+x /var/lib/libvirt/images/cisco-iosv.qcow2
```

14\. Create the `boxes` directory.

```
mkdir -p ~/boxes
```

15\. Start the `default` network (if not already started).

```
virsh -c qemu:///system net-start default
```

16\. Clone this GitHub repo and _cd_ into the directory.

```
git clone https://github.com/mweisel/cisco-iosv-vagrant-libvirt && cd cisco-iosv-vagrant-libvirt
```

17\. Create a Python virtual environment for Ansible.

```
uv sync
```

18\. Run the Ansible playbook.

```
uv run ansible-playbook main.yml
```

19\. Copy (and rename) the Vagrant box artifact to the `boxes` directory.

```
cp cisco-iosv.box ~/boxes/cisco-iosv-159.box
```

20\. Copy the box metadata file to the `boxes` directory.

```
cp ./files/cisco-iosv.json ~/boxes/
```

21\. Change the current working directory to `boxes`.

```
cd ~/boxes
```

22\. Substitute the `HOME` placeholder string in the box metadata file.

```
sed -i "s|HOME|${HOME}|" cisco-iosv.json
```

```
awk '/url/{gsub(/^ */,"");print}' cisco-iosv.json
```

output:

<pre>
"url": "file://<b>/home/marc</b>/boxes/cisco-iosv-159.box"
</pre>

23\. Add the Vagrant box to the local inventory.

```
vagrant box add cisco-iosv.json
```

## Debug

View the telnet session output for the `expect` task:

```
tail -f ~/iosv-console.explog
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
