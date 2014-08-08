kafka Cookbook
==============
Sets up Kafka

Requirements
------------
- Zookeeper
- When a cluster is defined
  - hostsfile needed to modify /etc/hosts

Attributes
----------

#### kafka::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>[:kafka][:cluster]</tt></td>
    <td>String</td>
    <td>Name of the kafka cluster, used to pull the right data bag</td>
    <td><tt>localhost</tt></td>
  </tr>
  <tr>
    <td><tt>[:kafka][:data_dir]</tt></td>
    <td>String</td>
    <td>Directory where kafka logs are stored</td>
    <td><tt>/var/kafka</tt></td>
  </tr>
  <tr>
    <td><tt>[:kafka][:group]</tt></td>
    <td>String</td>
    <td>Group of the user kafka runs as</td>
    <td><tt>kafka</tt></td>
  </tr>
  <tr>
    <td><tt>[:kafka][:listen_address]</tt></td>
    <td>String</td>
    <td>The address for kafka to listen on, without this it uses the ip of listen_interface or falls back to the kafka default</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>[:kafka][:listen_interface]</tt></td>
    <td>String</td>
    <td>The interface for kafka to listen on, pulls the ip from this interfaces, overridden by listen_address, without either falls back to the kafka default</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>[:kafka][:log_dir]</tt></td>
    <td>String</td>
    <td>Application logging dir</td>
    <td><tt>/var/log/kafka</tt></td>
  </tr>
  <tr>
    <td><tt>[:kafka][:topics]</tt></td>
    <td>Hash</td>
    <td>A Hash with the key being a topic name and the value a Hash containing :replicas and :partitions</td>
    <td><tt>{}</tt></td>
  </tr>
  <tr>
    <td><tt>[:kafka][:user]</tt></td>
    <td>String</td>
    <td>user kafka runs as</td>
    <td><tt>kafka</tt></td>
  </tr>
  <tr>
    <td><tt>[:kafka][:version]</tt></td>
    <td>String</td>
    <td>The version of kafka to install</td>
    <td><tt>0.8.1.1</tt></td>
  </tr>
  <tr>
    <td><tt>[:kafka][:zookeeper]</tt></td>
    <td>String</td>
    <td>The zookeeper url</td>
    <td><tt>localhost:2181</tt></td>
  </tr>
</table>

Data Bags
-----
For each cluster there is a data bag with the name of the cluster. The get_data bag functions are used so the cluster name
can vary based on environment. The data bag contains a servers hash with this format:
  "brokers": [
    "fqdn": { "id": 0, "ip": "10.10.10.10" },
    "fqdn2": { "id": 1, "ip": "10.10.10.11" }
  ]

Usage
-----
Simply include the kafka default recipe in your role making sure to setup the data bags and attributes as described above.

If you wish to create some topics also include the create_topics recipe
