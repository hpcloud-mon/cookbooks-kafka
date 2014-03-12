# Create kafka topics
#   Assumes kafka is up and running

node[:kafka][:topics].each do |name, config|
  bash "add topic #{name}" do
    action :run
    code "/opt/kafka/bin/kafka-create-topic.sh --zookeeper #{node[:kafka][:zookeeper]} --replica #{config[:replicas]} --partition #{config[:partitions]} --topic #{name} | grep 'creation succeeded!'"
    not_if "/opt/kafka/bin/kafka-list-topic.sh --zookeeper #{node[:kafka][:zookeeper]} --topic #{name} | grep #{name}"
  end
end
