default[:kafka][:cluster] = 'localhost' # If unset defaults to a single node setup, if set the databag with this name is pulled
default[:kafka][:data_dir] = '/var/kafka'
default[:kafka][:log_dir] = '/var/log/kafka'

default[:kafka][:topics] = {} # Add hash with key being the topic name and value a hash with replicas and partitions the two required values
default[:kafka][:zookeeper] = 'localhost:2181'
