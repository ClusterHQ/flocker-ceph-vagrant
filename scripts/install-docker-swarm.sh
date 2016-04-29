#!/bin/bash

# This script locks in Swarm at the below version
SWARM_VERSION=1.2.0

read -p "This script will remove any existing Swarm config, are you sure? [Yy]  " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

echo "Installing Consul on ceph1"
vagrant ssh ceph1 -c "sudo docker rm -f consul-server"
vagrant ssh ceph1 -c "sudo docker run -d \
    -p "8500:8500" \
    -h "consul" \
    --name=consul-server \
    progrium/consul -server -bootstrap"

# wait for consul to come up
sleep 5

echo "Installing Swarm Manager on ceph1"
vagrant ssh ceph1 -c "sudo docker rm -f swarm-manager1"
vagrant ssh ceph1 -c "sudo docker run -d \
    --name=swarm-manager1 \
    -p 3375:3375 swarm:$SWARM_VERSION manage \
    --host=0.0.0.0:3375 \
    --replication --advertise 192.168.5.2:3375 \
    consul://192.168.5.2:8500"

echo "Installing Swarm Manager on ceph2"
vagrant ssh ceph2 -c "sudo docker rm -f swarm-manager2"
vagrant ssh ceph2 -c "sudo docker run -d \
    --name=swarm-manager2 \
    -p 3375:3375 swarm:$SWARM_VERSION manage \
    --host=0.0.0.0:3375 \
    --replication --advertise 192.168.5.3:3375 \
    consul://192.168.5.2:8500"

echo "Installing Swarm Agent on ceph2"
vagrant ssh ceph2 -c "sudo docker rm -f swarm-agent1"
vagrant ssh ceph2 -c "sudo docker run -d \
   --name=swarm-agent1 \
   --restart=always swarm:$SWARM_VERSION join \
   --advertise=192.168.5.3:2375 \
   consul://192.168.5.2:8500"

echo "Installing Swarm Agent on ceph3"
vagrant ssh ceph3 -c "sudo docker rm -f swarm-agent2"
vagrant ssh ceph3 -c "sudo docker run -d \
      --name=swarm-agent2 \
      --restart=always swarm:$SWARM_VERSION join \
      --advertise=192.168.5.4:2375 \
      consul://192.168.5.2:8500"

echo "Installing Swarm Agent on ceph4"
vagrant ssh ceph4 -c "sudo docker rm -f swarm-agent3"
vagrant ssh ceph4 -c "sudo docker run -d \
      --name=swarm-agent3 \
      --restart=always swarm:$SWARM_VERSION join \
      --advertise=192.168.5.5:2375 \
      consul://192.168.5.2:8500"

echo "Done: Swarm available at tcp://192.168.5.2:3375"
