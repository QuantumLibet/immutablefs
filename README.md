# ImmutableFS for Raspberry Pi

</br>

This script installs (if necessary) and then enables/disables an union filesystem based on the `overlayroot` OverlayFS implementation.
That's a mouthful for: It makes the current root filesystem read-only and redirects all writes to the memory.

The idea is taken from `raspi-config`.
If you have a Raspberry Pi, `sudo raspi-config` offers the same and more, via a GUI.

</br>

### Usage:

    /path/to/immutablefs.sh [ enable | disable | info]

It requires `sudo` (as in: `sudo` must be available and the user calling the script must have permissions to use `sudo`).


</br>

### Motivation:

The motivation for this was simple: I wanted to freeze an installation, experiment on/with it, and unfreeze it. A poor man's time machine of sorts.

To do so is simple: Redirect writes to the filesystem to the machine's memory instead. Done.
This basically makes the filesystem read-only. To reset the machine to the original state, just reboot, since that looses all contents of the memory.

This has turned out to be useful in different places, e.g. with my (smol) fleet of Raspberry Pi's. There I freeze machines, once they have the desired state.
A poor man's immutable operating system.
To update the machine, I'll unfreeze it (which requires a reboot), update it, and freeze it again (which requirest yet another reboot). Simple, really.


</br>

### Implementation:

This uses the (debian) [`overlayroot`](https://packages.debian.org/bookworm/overlayroot) package, which is part of the (debian) [`cloud-initramfs-tools`](https://packages.debian.org/source/bookworm/cloud-initramfs-tools) that have been upstreamed to debian from the Canonical `overlayroot` package, part of the bigger (Canonical) [`cloud-initramfs-tools`](https://launchpad.net/cloud-initramfs-tools) package.

</br>

### Sources:

[OverlayFS on The Linux Kernel](https://docs.kernel.org/filesystems/overlayfs.html)
[OverlayFS on the ArchLinux man page](https://wiki.archlinux.org/title/Overlay_filesystem)
[OverlayFS on Wikpedia](https://en.wikipedia.org/wiki/OverlayFS)
[Protecting the Root Filesystem on Ubuntu](https://spin.atomicobject.com/protecting-ubuntu-root-filesystem/)
