default[:kafka][:cluster] = 'localhost' # If unset defaults to a single node setup, if set the databag with this name is pulled
default[:kafka][:data_dir] = '/var/kafka'
default[:kafka][:log_dir] = '/var/log/kafka'
