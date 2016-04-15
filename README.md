
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
ansible-playbook -i ansible/inventory/vagrant_ansible_inventory site.yml \
   --extra-vars "fsid=4a158d27-f750-41d5-9e7f-26ce4c9d2d45 \
   monitor_secret=AQAWqilTCDh7CBAAawXt6kyTgLFCxSvJhTEmuw=="
```

Once complete, a healthy ceph cluster should exist
```
vagrant ssh ceph1 -c "sudo ceph -s"
    cluster 4a158d27-f750-41d5-9e7f-26ce4c9d2d45
     health HEALTH_OK
     monmap e1: 3 mons at {ceph1=192.168.5.2:6789/0,ceph2=192.168.5.3:6789/0,ceph3=192.168.5.4:6789/0}
            election epoch 4, quorum 0,1,2 ceph1,ceph2,ceph3
     mdsmap e6: 1/1/1 up {0=ceph1=up:active}
     osdmap e20: 6 osds: 6 up, 6 in
            flags sortbitwise
      pgmap v30: 320 pgs, 3 pools, 1960 bytes data, 20 objects
            221 MB used, 5887 MB / 6109 MB avail
                 320 active+clean
  client io 2030 B/s wr, 17 op/s
```

Flocker

//TODO enable installing ceph driver. (through ansible? though script after ansible completes?)

```
ansible-galaxy install ClusterHQ.flocker -p ../roles
ansible-playbook -i ansible/inventory/vagrant_ansible_inventory \
    ${PWD}/../ceph-flocker-installer.yml  \
    --extra-vars "flocker_agent_yml_path=${PWD}/../agent.yml"
```

## License 

MIT / BSD
