VAGRANTFILE_API_VERSION = "2"

nodes = ['ceph1', 'ceph2', 'ceph3', 'ceph4']
network = "192.168.5"
ceph1ip = "#{network}.2"
ceph2ip = "#{network}.3"
ceph3ip = "#{network}.4"
ceph4ip = "#{network}.5"
osd_nodes = []
subnet=1
nodes.each { |node_name|
  (1..1).each {|n|
    subnet += 1
    osd_nodes << {:hostname => "#{node_name}"}
  }
}

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "trusty"
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  osd_nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
      node_config.vm.host_name = "#{node[:hostname]}"
      if node[:hostname] != "ceph1" 
        (0..1).each do |d|
          node_config.vm.provider "virtualbox" do |vb|
            vb.customize [ "createmedium", "disk", "--format", "VDI", "--filename", "disk-#{node[:hostname]}-#{d}", "--size", "2048"]
            vb.customize [ "storageattach", :id, "--storagectl", "SATAController", "--port", 3+d, "--device", 0, "--type", "hdd", "--medium", "disk-#{node[:hostname]}-#{d}.vdi" ]
            vb.customize [ "modifyvm", :id, "--memory", "512" ]
          end
        end
      end
      if node[:hostname] == "ceph1"
        node_config.vm.network "private_network", ip: "#{ceph1ip}"
      end
      if node[:hostname] == "ceph2"
        node_config.vm.network "private_network", ip: "#{ceph2ip}"
      end
      if node[:hostname] == "ceph3"
        node_config.vm.network "private_network", ip: "#{ceph3ip}"
      end
      if node[:hostname] == "ceph4"
        node_config.vm.network "private_network", ip: "#{ceph4ip}"
        node_config.vm.provision "vai" do |ansible|
          ansible.inventory_dir = 'ansible/inventory'
          ansible.groups = {
            'osds' => ["ceph2", "ceph3", "ceph4"],
            'mons' => ["ceph1", "ceph2", "ceph3"],
            'mdss' => ["ceph1"],
            'rdgws' => ["ceph1"],
            'flocker_agents' => ["ceph2", "ceph3", "ceph4"],
            'flocker_control_service' => ["ceph1"],
            'flocker_docker_plugin' => ["ceph2", "ceph3", "ceph4"],
            'flocker_ceph' => ["ceph2", "ceph3", "ceph4"],
            'nodes:children' => ["flocker_agents", "flocker_control_service"]
          }
        end
        node_config.vm.provision "ansible" do |ansible|
          ansible.playbook = 'site.yml'
          ansible.limit = "all"
          ansible.groups = {
            'osds' => ["ceph2", "ceph3", "ceph4"],
            'mons' => ["ceph1", "ceph2", "ceph3"],
            'mdss' => ["ceph1"],
            'rdgws' => ["ceph1"],
            'flocker_agents' => ["ceph2", "ceph3", "ceph4"],
            'flocker_control_service' => ["ceph1"],
            'flocker_docker_plugin' => ["ceph2", "ceph3", "ceph4"],
            'flocker_ceph' => ["ceph2", "ceph3", "ceph4"],
            'nodes:children' => ["flocker_agents", "flocker_control_service", "flocker_docker_plugin", "flocker_ceph"]
          }
          ansible.extra_vars = {
            fsid: "4a158d27-f750-41d5-9e7f-26ce4c9d2d45",
            monitor_secret: "AQAWqilTCDh7CBAAawXt6kyTgLFCxSvJhTEmuw==",
            flocker_agent_yml_path: "../agent.yml"
          }  
        end
      end
    end
  end
end
