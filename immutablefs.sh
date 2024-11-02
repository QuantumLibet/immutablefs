#! /usr/bin/env bash
# shellcheck disable=SC2317

set -euo pipefail


enable()
{
    #  install overlayroot
    if dpkg -l overlayroot 2>&1 | grep -q 'no packages found'
    then
        sudo --askpass DEBIAN_FRONTEND=noninteractive apt-get -qq -o=Dpkg::Use-Pty=0 update
        sudo --askpass DEBIAN_FRONTEND=noninteractive apt-get -qq -o=Dpkg::Use-Pty=0 install overlayroot
    fi

    # modify kernel parameters
    if ! grep -qE '^overlayroot=tmpfs ' /boot/firmware/cmdline.txt
    then
        if grep -qE '/boot/firmware.* ro,' /etc/mtab    #  if '/boot/firmware' is locked
        then
            if sudo mount -o remount,rw /boot/firmware  #  … unlock it
            then
                echo -e "\nUnable to mount boot/firmware as writable. Aborting!\n"
                exit 1
            fi
        fi
        sudo --askpass sed -i=bckp 's/^/overlayroot=tmpfs /' /boot/firmware/cmdline.txt
        echo -e "\nFilesystem immutable from next reboot onwards.\n"
    else
        echo -e "\nFilesystem is already immutable. Nothing do do.\n"
    fi
}


disable()
{
    # modify kernel parameters
    if grep -qE '^overlayroot=tmpfs ' /boot/firmware/cmdline.txt
    then
        if grep -qE '/boot/firmware.* ro,' /etc/mtab    #  if '/boot/firmware' is locked
        then
            if sudo mount -o remount,rw /boot/firmware  #  … unlock it
            then
                echo -e "\nUnable to mount boot/firmware as writable. Aborting!\n"
                exit 1
            fi
        fi
        sudo --askpass sed -i=bckp 's/^overlayroot=tmpfs //' /boot/firmware/cmdline.txt
        echo -e "\nFilesystem immutable disabled from next reboot onwards.\n"
    else
        echo -e "\nFilesystem is not immutable. Nothing to do.\n"
        exit 0
    fi
}


info()
{
    if $(grep -qE '^overlayroot=tmpfs ' /boot/firmware/cmdline.txt); then echo -e "\nFilesystem is immutable.\n"; else echo -e "\nFilesystem is not immutable.\n"; fi
}


if (( ! $# ))
then
    echo -e "\nusage:  $0 [enable | disable | info]\n"
else
    "$1"
fi
exit 0
