# Pull cluster info from a data bag or default to a singlenode
if node[:kafka][:cluster] == 'localhost'
  id = 0
else
  include_recipe 'hp_common_functions'
  servers = normalize(get_data_bag_item('kafka', node[:kafka][:cluster], { :encrypted => false}), {
    :brokers => { :required => true, :typeof => Hash, :metadata => {
      :* => { :typeof => Hash, :metadata => {
        :ip => { :required => true, :typeof => String },
        :id => { :required => true, :typeof => Integer },
      } }
    } }
  })[:brokers]
  # Add servers to /etc/hosts file
  brokers.each do |fqdn, info|
    ip = info['ip']
    hostsfile_entry ip do
      action :create
      hostname fqdn
      aliases [ fqdn.split('.')[0] ]
    end
  end
  id = brokers[node[:fqdn]][:id]
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

conf_dir = '/etc/kafka'
template "#{conf_dir}/server.properties" do
  action :create
  source "server.properties.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :id => id
  )
  notifies :restart, "service[kafka]"
end

template "#{conf_dir}/log4j.properties" do
  action :create
  source "log4j.properties.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[kafka]"
end

