
# Ansible

dump variables:
ansible kiosk -m setup

https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html

ansible-playbook upgrade.yml --limit vm

## Key order:

name
when
with_items
<action>
register

## Roles

debug: 
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/debug_module.html

custom:
https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html

## Ansible.cfg

ansible-config init --disabled

## Inventory

https://docs.ansible.com/ansible/2.4/ansible-inventory.html
https://docs.ansible.com/ansible/2.8/dev_guide/developing_inventory.html#developing-inventory

ansible-inventory --list

## Vault

https://docs.ansible.com/ansible/latest/user_guide/vault.html#encrypting-individual-variables-with-ansible-vault

ansible-vault encrypt_string "$SECRET" --name "$KEY"
