#!/usr/bin/env bash

# Starts the stress workload and keeps it running until interrupted.

set -e

[ "$EUID" -ne 0 ] && echo "PLEASE RUN AS ROOT or with sudo" && exit 1

LOG_DIR="/var/log/stress-tests"
mkdir -p "$LOG_DIR"

stress-ng --cpu 0 --cpu-method matrixprod > "$LOG_DIR/cpu-stress.log" 2>&1 &
cpu_stress_job=$!

stress-ng --hdd 2 --hdd-bytes 1G > "$LOG_DIR/storage-stress.log" 2>&1 &
storage_stress_job=$!

trap 'kill "$cpu_stress_job" "$storage_stress_job" 2>/dev/null || true' INT TERM EXIT

echo "Stress jobs started. Press Ctrl+C to stop them."
wait "$cpu_stress_job"
wait "$storage_stress_job"
