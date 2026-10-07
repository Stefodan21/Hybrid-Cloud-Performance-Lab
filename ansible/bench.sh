#!/usr/bin/env bash

# Benchmarking script that runs performance tests, collects logs, and bundles results.

set -e 

[ "$EUID" -ne 0 ] && echo "PLEASE RUN AS ROOT or with sudo" && exit 1

LOG_DIR="/var/log/stress-tests"

mkdir -p "$LOG_DIR"

[ -z "$(command -v stress-ng)" ] && dnf install -y stress-ng
[ -z "$(command -v mtr)" ] && dnf install -y mtr
[ -z "$(command -v vmstat)" ] && dnf install -y procps-ng
[ -z "$(command -v mpstat)" ] && dnf install -y sysstat
[ -z "$(command -v dstat)" ] && dnf install -y dstat
[ -z "$(command -v perf)" ] && dnf install -y perf

stress-ng --cpu 0 --cpu-method matrixprod --timeout 60s > "$LOG_DIR/cpu-stress.log" 2>&1
stress-ng --hdd 2 --hdd-bytes 1G --timeout 60s > "$LOG_DIR/storage-stress.log" 2>&1
mtr --report --report-cycles 10 8.8.8.8 > "$LOG_DIR/network-path-stats.log" 2>&1

vmstat 1 60 > "$LOG_DIR/vmstat.log" 2>&1 &
vmstat_job=$!

mpstat -P ALL -I SUM 1 60 > "$LOG_DIR/mpstat.log" 2>&1 &
mpstat_job=$!

dstat -tcdngy --output "$LOG_DIR/dstat.csv" 1 60 > /dev/null 2>&1 &
dstat_job=$!

perf stat -a -o "$LOG_DIR/perf-stat.log" -- sleep 60 > /dev/null 2>&1 &
perf_stat_job=$!

perf sched record -o "$LOG_DIR/perf-sched.data" -- sleep 60 > /dev/null 2>&1 &
perf_sched_job=$!

perf record -F 99 -a -g -o "$LOG_DIR/perf-record.data" -- sleep 60 > /dev/null 2>&1 &
perf_record_job=$!

wait "$vmstat_job"
wait "$mpstat_job"
wait "$dstat_job"
wait "$perf_stat_job"
wait "$perf_sched_job"
wait "$perf_record_job"

perf report -i "$LOG_DIR/perf-record.data" --stdio > "$LOG_DIR/perf-report.txt" 2>&1 || true
perf sched latency -i "$LOG_DIR/perf-sched.data" > "$LOG_DIR/perf-sched-latency.txt" 2>&1 || true

echo "Benchmark logs written to $LOG_DIR"
