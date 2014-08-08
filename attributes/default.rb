default[:kafka][:cluster] = 'localhost' # If unset defaults to a single node setup, if set the databag with this name is pulled
default[:kafka][:topics] = {} # Add hash with key being the topic name and value a hash with replicas and partitions the two required values
default[:kafka][:version] = '0.8.1.1'
default[:kafka][:zookeeper] = 'localhost:2181'

default[:kafka][:user] = 'kafka'
default[:kafka][:group] = 'kafka'
default[:kafka][:data_dir] = '/var/kafka'
default[:kafka][:log_dir] = '/var/log/kafka'
