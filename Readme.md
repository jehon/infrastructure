# Infrastructure

## By installing jehon.deb first

```
curl -fsSL https://jehon.github.io/infrastructure/packages/jehon.deb -o jehon.deb
sudo apt install ./jehon.deb
# sudo apt install -f
```

```
./deploy-to kiosk --e "ansible_host=192.168.1.5"
```

## By deploy-to

```
./deploy-to kiosk --become --user jehon --e "ansible_host=192.168.1.5"
```

# What where?

| Objective           | Types                       | Script | Packages | Ansible | Application | Not managed | Comment                              |
| :------------------ | --------------------------- | :----: | :------: | :-----: | :---------: | :---------: | ------------------------------------ |
| ~/restricted        | secrets                     |        |          |    X    |             |             |                                      |
| Users secrets       | For rclone in self install? |        |          |         |             |      X      | Required by script when necessary    |
| User configuration  | user crontab etc...         |        |          |    X    |             |             | Always depend of the user login name |
| Application folders |                             |        |          |         |      X      |             | ?? C'est quoi ??                     |
|                     |                             |        |          |         |             |             |                                      |

(1) Scripts are bundled into jehon.deb|

# Items

First, put everything possible in packages.
Secrets, host related stuff in Ansible.
Bin script for anything that move too frenquently.

## Packages

- ++ Install Dependencies
- ++ Install Scripts
- ++ Install, configure and start daemons
- ++ files: /etc (global - by link to /usr/share/...)
- ++ files: /usr/
- -- No secrets (don't know anything about it ; delivered scripts may use secrets)
- -- No user config (what is the user?)
- !! run as root
- => servers + laptops

### Packages > jehon.deb

To be installed on any computer to have a basic setup.

- ++ Install max scripts
- ++ Start basic daemons
- ++ Configure generic security
- ++ Configure jh-% users

### Packages > jehon-hardware-\*.deb

++ Tweak according to hardware
-- Nothing more (minimal tweaks)

### Packages > jehon-service-...

- ++ packages for this particuliar role
- ++ Configure daemons (configs) generic
- -- No secrets (see Ansible)

### Packages > jehon-service-headless

### Packages > jehon-service-kiosk

### Packages > jehon-service-music

## Ansible

- ++ Install Repositories
- ++ Install Secrets
- ++ files: /etc (host related)
- -- Do not install packages dependencies
- -- Do not install Scripts
- !! run as root
- !! configure user if can be done by files only
- ==> servers + laptop dev

### Ansible > jehon_basis

- ++ Install Repositories -> files: /etc/apt/sources.list.d/\*
- ++ Install basic utilities: docker / grapfana / node that depend on repositories (TODO: docker / node should be installed by jehon.deb)
- ++ Install jehon.deb
- ++ Install jehon-hardware-\*.deb
- ++ Configure global secrets
- ++ Configure monitoring

### Ansible > host\_\*

### Ansible > jh_service_headless

### Ansible > jh-<all>

### Ansible > service_desktop_linux

### Ansible > user_jehon

- ++ Configure user
- ++ files: ~/restricted

## Scripts

- ++ Everything that change too often
- ++ Can run as user

## Not managed

-- End users (ml, silouane, rosalie...)
-- <repo>/setup.sh -> configuration that run as root
-- <repo>/setup-profile.sh -> configuration that run as user

# HDD Desktop setup

- 200 Gb root drive
- 200 Gb home
- 50 Gb swap

# Ansible

ansible-inventory --list
ansible-vault encrypt_string "$SECRET" --name "$KEY"
See https://docs.ansible.com/ansible/latest/user_guide/vault.html#encrypting-individual-variables-with-ansible-vault

## Key order

    name
    with_items
    when
    <action>
    register
    failed_when
    changed_when

# Install

## WSL

- Add ssh key to github
- Add ssh key to infra ssh packages ???

```lang=shell
wsl --install ubuntu
cd && mkdir -p src && git clone git@github.com:jehon/infrastructure
```

In WSL

```lang=shell
cd
ssh-keygen
mkdir -p src
git clone git@github.com:jehon/infrastructure
sudo ./deploy-infra-to init
```

```lang=shell
wsl --shutdown
```

In WSL

```lang=shell
src/infrastructure/deploy-infra-to init
cp .ssh/id_rsa.pub
```
