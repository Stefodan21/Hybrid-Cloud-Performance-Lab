#!/usr/bin/env bash

# Benchmarking script that runs performance tests without writing log files.

set -e 

[ "$EUID" -ne 0 ] && echo "PLEASE RUN AS ROOT or with sudo" && exit 1

cleanup() {
	for pid in "$stress_cpu_job" "$stress_hdd_job" "$vmstat_job" "$mpstat_job" "$dstat_job" "$iostat_job" "$perf_stat_job" "$perf_sched_job" "$perf_record_job"; do
		kill "$pid" 2>/dev/null || true
	done
}

trap cleanup INT TERM

[ -z "$(command -v stress-ng)" ] && dnf install -y stress-ng
[ -z "$(command -v mtr)" ] && dnf install -y mtr
[ -z "$(command -v vmstat)" ] && dnf install -y procps-ng
[ -z "$(command -v mpstat)" ] && dnf install -y sysstat
[ -z "$(command -v dstat)" ] && dnf install -y dstat
[ -z "$(command -v perf)" ] && dnf install -y perf

stress-ng --cpu 0 --cpu-method matrixprod &
stress_cpu_job=$!

stress-ng --hdd 2 --hdd-bytes 1G &
stress_hdd_job=$!

mtr --report --report-cycles 10 8.8.8.8

vmstat 1 &
vmstat_job=$!

mpstat -P ALL -I SUM 1 &
mpstat_job=$!

dstat -tcdngy 1 &
dstat_job=$!

perf stat -a -- sleep infinity &
perf_stat_job=$!

perf sched record -- sleep infinity &
perf_sched_job=$!

perf record -F 99 -a -g -- sleep infinity &
perf_record_job=$!

iostat -dx 1 &
iostat_job=$!

set +e
wait "$stress_cpu_job"
wait "$stress_hdd_job"
wait "$vmstat_job"
wait "$mpstat_job"
wait "$dstat_job"
wait "$iostat_job"
wait "$perf_stat_job"
wait "$perf_sched_job"
wait "$perf_record_job"
set -e

echo "Benchmark run stopped"
