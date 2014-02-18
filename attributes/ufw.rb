default[:kafka][:firewall][:rules] = [
  "kafka-9092" => {
    "port" => "9092",
    "protocol" => "tcp"
  }
]
