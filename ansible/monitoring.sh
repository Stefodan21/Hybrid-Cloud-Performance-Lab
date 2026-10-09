#!/usr/bin/env bash

# Captures monitoring data while the stress workload is running.

set -e

[ "$EUID" -ne 0 ] && echo "PLEASE RUN AS ROOT or with sudo" && exit 1

LOG_DIR="/var/log/stress-tests"
mkdir -p "$LOG_DIR"

RUNTIME=60

mtr --report --report-cycles 10 8.8.8.8 > "$LOG_DIR/network-path-stats.log" 2>&1

vmstat 1 "$RUNTIME" > "$LOG_DIR/vmstat.log" 2>&1 &
vmstat_job=$!

mpstat -P ALL -I SUM 1 "$RUNTIME" > "$LOG_DIR/mpstat.log" 2>&1 &
mpstat_job=$!

dstat -tcdngy --output "$LOG_DIR/dstat.csv" 1 "$RUNTIME" > /dev/null 2>&1 &
dstat_job=$!

iostat -dx 1 "$RUNTIME" > "$LOG_DIR/iostat.log" 2>&1 &
iostat_job=$!

perf stat -a -o "$LOG_DIR/perf-stat.log" -- sleep "$RUNTIME" > /dev/null 2>&1 &
perf_stat_job=$!

perf sched record -o "$LOG_DIR/perf-sched.data" -- sleep "$RUNTIME" > /dev/null 2>&1 &
perf_sched_job=$!

perf record -F 99 -a -g -o "$LOG_DIR/perf-record.data" -- sleep "$RUNTIME" > /dev/null 2>&1 &
perf_record_job=$!

wait "$vmstat_job"
wait "$mpstat_job"
wait "$dstat_job"
wait "$iostat_job"
wait "$perf_stat_job"
wait "$perf_sched_job"
wait "$perf_record_job"

perf report -i "$LOG_DIR/perf-record.data" --stdio > "$LOG_DIR/perf-report.txt" 2>&1 || true
perf sched latency -i "$LOG_DIR/perf-sched.data" > "$LOG_DIR/perf-sched-latency.txt" 2>&1 || true

COMBINED_LOG="$LOG_DIR/combined-logs.txt"
: > "$COMBINED_LOG"

for file in "$LOG_DIR"/*
do
	if [ -f "$file" ] && [[ "$file" != *.data ]]; then
		{
			echo "===== $(basename "$file") ====="
			cat "$file"
			echo
		} >> "$COMBINED_LOG"
	fi
done

if command -v xxd >/dev/null 2>&1; then
	xxd "$LOG_DIR/perf-record.data" > "$LOG_DIR/perf-record.data.xxd" 2>/dev/null || true
	xxd "$LOG_DIR/perf-sched.data" > "$LOG_DIR/perf-sched.data.xxd" 2>/dev/null || true
fi

echo "Monitoring logs written to $LOG_DIR"
