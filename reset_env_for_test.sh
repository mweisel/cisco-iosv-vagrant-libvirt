NAME=cisco-iosv

# remove the modified disk image
if [ -f ./files/${NAME}.qcow2 ]; then
    rm ./files/${NAME}.qcow2
    printf "${NAME}.qcow2 deleted.\n"
fi
# remove the vagrant box package artifact
if [ -f ./${NAME}.box ]; then
    rm ./${NAME}.box
    printf "${NAME}.box deleted.\n"
fi
# copy a "fresh" disk image to the libvirt/images dir
sudo cp ${HOME}/Downloads/${NAME}.qcow2 /var/lib/libvirt/images/${NAME}.qcow2
if [ $? -eq 0 ]; then
    printf "${NAME}.qcow2 copied successfully to /var/lib/libvirt/images.\n"
fi
