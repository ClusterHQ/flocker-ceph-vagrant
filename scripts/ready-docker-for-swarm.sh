#!/bin/bash

echo "Setting DOCKER_OPTS on ceph1"
vagrant ssh ceph1 -c "sudo sed -ie 's@.*DOCKER_OPTS=.*@DOCKER_OPTS=\"-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --dns 8.8.8.8 --dns 8.8.4.4\"@' /etc/default/docker"

echo "Restarting the Docker Daemon on ceph1"
vagrant ssh ceph1 -c "sudo service docker restart"

echo "Setting DOCKER_OPTS on ceph2"
vagrant ssh ceph2 -c "sudo sed -ie 's@.*DOCKER_OPTS=.*@DOCKER_OPTS=\"-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --dns 8.8.8.8 --dns 8.8.4.4\"@' /etc/default/docker"

echo "Restarting the Docker Daemon on ceph2"
vagrant ssh ceph2 -c "sudo service docker restart"

echo "Setting DOCKER_OPTS on ceph3"
vagrant ssh ceph3 -c "sudo sed -ie 's@.*DOCKER_OPTS=.*@DOCKER_OPTS=\"-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --dns 8.8.8.8 --dns 8.8.4.4\"@' /etc/default/docker"

echo "Restarting the Docker Daemon on ceph3"
vagrant ssh ceph3 -c "sudo service docker restart"

echo "Setting DOCKER_OPTS on ceph4"
vagrant ssh ceph4 -c "sudo sed -ie 's@.*DOCKER_OPTS=.*@DOCKER_OPTS=\"-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --dns 8.8.8.8 --dns 8.8.4.4\"@' /etc/default/docker"

echo "Restarting the Docker Daemon on ceph4"
vagrant ssh ceph4 -c "sudo service docker restart"
