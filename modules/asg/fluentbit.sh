#!/bin/bash

if [[ "${installFluentbitCWMetrics}" == "true" ]]
then
wget -qO - https://packages.fluentbit.io/fluentbit.key | sudo apt-key add -
sed -i -e '$adeb https://packages.fluentbit.io/ubuntu/bionic bionic main' /etc/apt/sources.list
apt-get update
apt-get install td-agent-bit -y
systemctl start td-agent-bit
mv /etc/td-agent-bit/td-agent-bit.conf /etc/td-agent-bit/td-agent-bit.conf.default
cat <<EOF | sudo tee /etc/td-agent-bit/td-agent-bit.conf
[SERVICE]
    flush        5
    daemon       Off
    log_level    info
    parsers_file parsers.conf
    plugins_file plugins.conf
    http_server  Off
    http_listen  0.0.0.0
    http_port    2020
    storage.metrics on

[INPUT]
    Name tail
    Tag fluentbit.apache.access
    Path /var/log/apache2/access.log
    Path_Key access.log
    Parser apache2
    Refresh_Interval 5
    Rotate_Wait 10
    Mem_Buf_Limit     100MB
    Buffer_Chunk_Size 128k
    Buffer_Max_Size   4096k

[INPUT]
    Name tail
    Tag fluentbit.apache.error
    Path /var/log/apache2/error.log
    Path_Key error.log
    Parser apache_error
    Refresh_Interval 5
    Rotate_Wait 10
    Mem_Buf_Limit     100MB
    Buffer_Chunk_Size 128k
    Buffer_Max_Size   4096k

[OUTPUT]
    Name cloudwatch_logs
    Match   *
    region us-west-2
    log_group_name fluent-bit-cloudwatch
    log_stream_prefix from-fluent-bit-
    auto_create_group On
EOF
systemctl restart td-agent-bit
fi
