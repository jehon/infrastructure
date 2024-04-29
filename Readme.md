# What where?

| Objective           | Types                             | Script | Packages | Ansible | Application | Not managed | Comment                                                        |
| :------------------ | --------------------------------- | :----: | :------: | :-----: | :---------: | :---------: | -------------------------------------------------------------- |
| /                   | anything                          |        |    X     |         |             |             |                                                                |
| /etc/               | fixed config (link to /usr/share) |        |    X     |         |             |             |                                                                |
| /etc/               | host related                      |        |          |    X    |             |             |                                                                |
| ~/restricted        | secrets                           |        |          |    X    |             |             |                                                                |
| /etc/apt/\*         | repositories for other sources    |   X    |          |         |             |             | Bundled as package, it is difficult to update and depend on it |
| Default users       | ml, silouane, rosalie...          |        |          |         |             |      X      | Desktop are moving too quickly                                 |
| Users secrets       | For rclone in self install?       |        |          |         |             |      X      | Required by script when necessary                              |
| User configuration  | user crontab etc...               |        |          |    X    |             |             | Always depend of the user login name                           |
| Application folders |                                   |        |          |         |      X      |             | ?? C'est quoi ??                                               |
|                     |                                   |        |          |         |             |             |                                                                |

(1) Scripts are bundled into jehon.deb

| Systems         | jehon.deb | others packages   | ansible | Comments                                    |
| --------------- | :-------: | ----------------- | :-----: | ------------------------------------------- |
| Ubuntu desktops |     Y     | Not necessary     |   No    | Owner is free, but cool to have all scripts |
| Debian servers  |     Y     | As necessary      |    Y    | Fixed ip, easily reachable                  |
| Dev computers   |     Y     | jehon-service-dev |    Y    | Localhost                                   |
|                 |           |                   |         |                                             |

# Desktop install

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

``` lang=shell
wsl --install debian
cd && mkdir -p src && git clone git@github.com:jehon/infrastructure
```

In WSL
``` lang=shell
cd
ssh-keygen
mkdir -p src
git clone git@github.com:jehon/infrastructure
sudo ./deploy-infra-to init
```

``` lang=shell
wsl --shutdown
```

In WSL
``` lang=shell
src/infrastructure/deploy-infra-to init
```
