#!/bin/bash

#
# A simple script to copy the needed files for the environment
#

#Check if in the `ceph-ansible` dir
IS_CEPH_ANSIBLE=${PWD##*/}

if [ "$IS_CEPH_ANSIBLE" != "ceph-ansible" ]
then
   echo "Must run script from `ceph-ansible` directory"
   exit 1
fi

echo "Copying needed files."

ansible-galaxy install marvinpinto.docker -p ./roles
cp  ../roles/ClusterHQ.flocker roles/
cp  group_vars/mons.sample  group_vars/mons
cp  ../osds.group_vars  group_vars/osds
cp  ../all.group_vars  group_vars/all
cp  ../ansible.cfg  .
cp  ../site.yml .
mv Vagrantfile Vagrantfile.original
cp ../Vagrantfile Vagrantfile

echo "Done!"

