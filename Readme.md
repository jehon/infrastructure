
# What where?

| Objective             | Types                             | Script (1) | Packages | Ansible | Not managed | Comment                                                        |
| :-------------------- | --------------------------------- | :--------: | :------: | :-----: | ----------- | -------------------------------------------------------------- |
| /                     | anything                          |            |   Yes    |         |             |                                                                |
| /etc/                 | fixed config (link to /usr/share) |            |   Yes    |         |             |                                                                |
| /etc/                 | host related                      |            |          |   Yes   |             |                                                                |
| /etc/jehon/restricted | secrets                           |            |          |   Yes   |             |                                                                |
| /etc/apt/*            | repositories for other sources    |     *1     |          |   *1    |             | Bundled as package, it is difficult to update and depend on it |
| Users                 |                                   |            |    *2    |         |             | Do we need this?                                               |
| Users secrets ?       | For rclone in self install?       |     *3     |    *3    |   *3    | *3          |                                                                |
|                       |                                   |            |          |         |             |                                                                |

(1) Scripts are bundled into jehon.deb

| Systems         | jehon.deb | others packages   | ansible | Comments                                    |
| --------------- | :-------: | ----------------- | :-----: | ------------------------------------------- |
| Ubuntu desktops |     Y     | Not necessary     |   No    | Owner is free, but cool to have all scripts |
| Debian servers  |     Y     | As necessary      |    Y    | Fixed ip, easily reachable                  |
| Dev computers   |     Y     | jehon-service-dev |    Y    | Localhost                                   |
|                 |           |                   |         |                                             |

## Questions:
- *1 Where to configure repositories?
- *2 Do we have a default users install?
- *3 Where to store users secrets (rclone)?

# Ansible

ansible-inventory --list
ansible-vault encrypt_string "$SECRET" --name "$KEY"
    See https://docs.ansible.com/ansible/latest/user_guide/vault.html#encrypting-individual-variables-with-ansible-vault

## Key order

    name
    when
    with_items
    <action>
    register
    failed_when
    changed_when
