#!/bin/bash
set -e

# Node Exporter 실행
/usr/local/bin/node_exporter &

# cAdvisor 실행
/usr/local/bin/cadvisor --port=8080 &

# 백그라운드 프로세스 유지
wait