# All my packages

This repository is for personal use only.
It contains helper scripts tailored for my usage.

Launch the start script (need sudo to be ok first: sudo ls):

```
wget -O- https://raw.githubusercontent.com/jehon/packages/master/start | sudo bash -E -
```

or

```
curl -fsSL https://raw.githubusercontent.com/jehon/packages/master/start | sudo bash -E -
```

or

```
curl -fsSL https://raw.githubusercontent.com/jehon/packages/master/start > start && chmod +x start && sudo ./start
```

May add "-k" if ca-certificates is not installed

## Recovery

Grub2 -> add systemd.unit=sshd.service to boot line

DPKG are in /var/lib/dpkg/info/

## Ansible vs packages

- users? system in packages, users in ansible
- groups? in packages, membership in pkg/ansible

### Dpkg example

https://github.com/m2osw/ipmgr

## triggers

!! Note that if a consumer is going to be normally configured (i.e. it is also being updated), then no triggering may occur and thus the standard control flow of the maintainer scripts should still take care to handle this.

See https://sources.debian.org/src/dpkg/1.19.7/doc/triggers.txt/
See https://stackoverflow.com/questions/15276535/dpkg-how-to-use-trigger

// https://stackoverflow.com/a/15276537/1954789
In most of the cases you really want interest-noawait, to not make the packages that activate the trigger be marked as needing to wait on the package processing the trigger to be able to get back to the configured state.

## Ubuntu

### Switch between windows of the current workspace

dconf write /org/gnome/shell/app-switcher/current-workspace-only 'true'

== Documentation:

https://www.debian.org/doc/manuals/maint-guide/dother.en.html
