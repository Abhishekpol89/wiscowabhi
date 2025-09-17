#!/usr/bin/env bash

# config thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80
LOGFILE="./system_monitor.log"

timestamp() {
  date +"%Y-%m-%d %H:%M:%S"
}

echo "$(timestamp) - Running system health check" >> "$LOGFILE"

# CPU usage (average of all cores) - use top or mpstat
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk -F'id,' '{ split($1, vs, ","); val=vs[length(vs)]; sub(".* ", "", val); printf("%.0f", 100 - val) }')

# Memory usage percentage
MEM_USAGE=$(free | awk '/Mem/ { printf("%.0f", $3/$2 * 100.0) }')

# Disk usage of root '/'
DISK_USAGE=$(df / | tail -1 | awk '{printf("%.0f", $5)}')

# number of processes
PROC_COUNT=$(ps aux --no-heading | wc -l)

echo "$(timestamp) - CPU:${CPU_USAGE}% MEM:${MEM_USAGE}% DISK:${DISK_USAGE}% PROCS:${PROC_COUNT}" >> "$LOGFILE"

# Alerts
if [ "$CPU_USAGE" -ge "$CPU_THRESHOLD" ]; then
  echo "$(timestamp) - ALERT: CPU usage is ${CPU_USAGE}% >= ${CPU_THRESHOLD}%" | tee -a "$LOGFILE"
fi

if [ "$MEM_USAGE" -ge "$MEM_THRESHOLD" ]; then
  echo "$(timestamp) - ALERT: Memory usage is ${MEM_USAGE}% >= ${MEM_THRESHOLD}%" | tee -a "$LOGFILE"
fi

if [ "$DISK_USAGE" -ge "$DISK_THRESHOLD" ]; then
  echo "$(timestamp) - ALERT: Disk usage is ${DISK_USAGE}% >= ${DISK_THRESHOLD}%" | tee -a "$LOGFILE"
fi

