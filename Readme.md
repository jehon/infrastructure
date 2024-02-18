
# What where?

| Objective             | Types                             | Script (1) | Packages | Ansible | Application | Not managed | Comment                                                        |
| :-------------------- | --------------------------------- | :--------: | :------: | :-----: | ----------- | :---------: | -------------------------------------------------------------- |
| /                     | anything                          |            |    X     |         |             |             |                                                                |
| /etc/                 | fixed config (link to /usr/share) |            |    X     |         |             |             |                                                                |
| /etc/                 | host related                      |            |          |    X    |             |             |                                                                |
| ~/restricted | secrets                           |            |          |    X    |             |             |                                                                |
| /etc/apt/*            | repositories for other sources    |     X      |          |         |             |             | Bundled as package, it is difficult to update and depend on it |
| Default users         | ml, silouane, rosalie...          |            |          |         |             |      X      | Desktop are moving too quickly                                 |
| Users secrets         | For rclone in self install?       |            |          |         |             |      X      | Required by script when necessary                              |
| Application folders   |                                   |            |          |         | X           |             |                                                                |
|                       |                                   |            |          |         |             |             |                                                                |

(1) Scripts are bundled into jehon.deb

| Systems         | jehon.deb | others packages   | ansible | Comments                                    |
| --------------- | :-------: | ----------------- | :-----: | ------------------------------------------- |
| Ubuntu desktops |     Y     | Not necessary     |   No    | Owner is free, but cool to have all scripts |
| Debian servers  |     Y     | As necessary      |    Y    | Fixed ip, easily reachable                  |
| Dev computers   |     Y     | jehon-service-dev |    Y    | Localhost                                   |
|                 |           |                   |         |                                             |

## Questions:
- *2 Do we have a default users install?
- *3 Where to store users secrets (rclone)?

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

