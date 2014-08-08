# Create kafka topics
#   Assumes kafka is up and running

node[:kafka][:topics].each do |name, config|
  bash "add topic #{name}" do
    action :run
    code "/opt/kafka/bin/kafka-topics.sh --create --zookeeper #{node[:kafka][:zookeeper]} --replication-factor #{config[:replicas]} --partitions #{config[:partitions]} --topic #{name} | grep 'Created topic'"
    not_if "/opt/kafka/bin/kafka-topics.sh --list --zookeeper #{node[:kafka][:zookeeper]} --topic #{name} | grep #{name}"
  end
end
