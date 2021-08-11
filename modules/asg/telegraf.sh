#!/bin/bash

if [[ "${installTelegrafCWMetrics}" == "true" ]]
then
cat <<EOF | sudo tee /etc/telegraf/telegraf.conf
[global_tags]
  StackName="my-xyz-stack"
[agent]
  interval = "1m"
  round_interval = true
  metric_batch_size = 1000
  metric_buffer_limit = 10000
  collection_jitter = "0s"
  flush_interval = "30s"
  flush_jitter = "0s"
  precision = ""
  debug = false
  quiet = false
  logfile = "/var/log/telegraf/telegraf.log"
  hostname = ""
  omit_hostname = false
[[inputs.cpu]]
  ## Whether to report per-cpu stats or not
  percpu = true
  ## Whether to report total system cpu stats or not
  totalcpu = true
  ## If true, collect raw CPU time metrics
  collect_cpu_time = false
  ## If true, compute and report the sum of all non-idle CPU states
  report_active = false
[[inputs.diskio]]
[[inputs.kernel]]
[[inputs.mem]]
[[inputs.processes]]
[[outputs.cloudwatch]]
  region = "us-west-2"
  role_arn = "${role_arn}"
  namespace = "AWS/EC2_aws_drupal_testing"
EOF
systemctl restart telegraf
systemctl enable telegraf
fi
