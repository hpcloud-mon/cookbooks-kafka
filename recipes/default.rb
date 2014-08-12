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

# Install kafka from the binary package
bash 'chmod +x /opt/kafka/bin/*.sh' do
  action :nothing
end
ark 'kafka' do
  action :install
  prefix_home '/opt'
  prefix_root '/opt'
  url "#{node[:ark][:apache_mirror]}/kafka/#{node[:kafka][:version]}/kafka_2.9.2-#{node[:kafka][:version]}.tgz"
  version node[:kafka][:version]
  notifies :run, "bash[chmod +x /opt/kafka/bin/*.sh]"
end

group node[:kafka][:group] do
  action :create
end
user node[:kafka][:user] do
  action :create
  system true
  gid node[:kafka][:group]
end

template '/etc/init/kafka.conf' do
  action :create
  source 'kafka.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
end

service 'kafka' do
  action :enable
  provider Chef::Provider::Service::Upstart
end

[node[:kafka][:data_dir], node[:kafka][:log_dir]].each do |dir|
  directory dir do
    owner node[:kafka][:user]
    group node[:kafka][:group]
    action :create
  end
end

# kafka startup will choke on a lost+found dir in its data dir
directory "#{node[:kafka][:data_dir]}/lost+found" do
  owner node[:kafka][:user]
  group node[:kafka][:group]
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
