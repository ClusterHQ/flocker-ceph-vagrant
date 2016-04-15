
# Local Docker + Ceph + Flocker Cluster with Vagrant

## STILL EXPERIMENTAL!

### What you will need

- Vagrant
- Virtialbox

```
vagrant plugin install vai
```

## How to use this repository

```
brew install ansible
vagrant plugin install vai
```

```
git clone [this repo]
cd [this repo]
git clone https://github.com/ceph/ceph-ansible.git
cd  ceph-ansible 
cp  group_vars/mons.sample  group_vars/mons
cp  site.yml.sample  site.yml
cp  ../osds.group_vars  group_vars/osds
cp  ../all.group_vars  group_vars/all
cp  ../ansible.cfg  .
```

```
mv Vagrantfile Vagrantfile.original
cp ../Vagrantfile Vagrantfile
vagrant up
ansible-playbook -i ansible/inventory/vagrant_ansible_inventory site.yml --extra-vars "fsid=4a158d27-f750-41d5-9e7f-26ce4c9d2d45 monitor_secret=AQAWqilTCDh7CBAAawXt6kyTgLFCxSvJhTEmuw=="
```

Flocker

//TODO enable installing ceph driver. (through ansible? though script after ansible completes?)

```
ansible-galaxy install ClusterHQ.flocker -p ../roles
ansible-playbook -i  ansible/inventory/vagrant_ansible_inventory ${PWD}/../ceph-flocker-installer.yml  --extra-vars "flocker_agent_yml_path=${PWD}/../agent.yml"
```

## License 

MIT / BSD
