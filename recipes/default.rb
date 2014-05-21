# Pull cluster info from a data bag or default to a singlenode
if node[:kafka][:cluster] == 'localhost'
  id = 0
else
  brokers = data_bag_item('kafka', node[:kafka][:cluster])['brokers']
  # Add servers to /etc/hosts file
  brokers.each do |fqdn, info|
    ip = info['ip']
    hostsfile_entry ip do
      action :create
      hostname fqdn
      aliases [ fqdn.split('.')[0] ]
    end
  end
  id = brokers[node[:fqdn]]['id']
end

# The package depends on java, sets up /var/log/kafka and /etc/kafka, adds a kafka user and group
package 'kafka' do
  action :upgrade
end

service "kafka" do
  action :enable
  provider Chef::Provider::Service::Upstart
end

directory node[:kafka][:data_dir] do
  owner 'kafka'
  group 'kafka'
  action :create
end

# kafka startup will choke on a lost+found dir in its log dir
directory "#{node[:kafka][:data_dir]}/lost+found" do
  owner 'kafka'
  group 'kafka'
  action :delete
end

conf_dir = '/etc/kafka'
link conf_dir do
  to '/opt/kafka/config'
  action :create
end

template "#{conf_dir}/log4j.properties" do
  action :create
  source "log4j.properties.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[kafka]"
end

template "#{conf_dir}/server.properties" do
  action :create
  source "server.properties.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :id => id
  )
  notifies :restart, "service[kafka]", :immediately  # kafka must be running for topics to be created
end
