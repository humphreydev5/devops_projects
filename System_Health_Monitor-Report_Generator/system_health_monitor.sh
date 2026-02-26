#!/bin/bash

REPORT_FILE="health-report-$(date +%F).txt"
ALERT_LOG="alerts.log"

# ---------- FUNCTION: SYSTEM INFO ----------
system_info() {
    echo "===== SYSTEM INFORMATION ====="
    echo "Hostname: $(hostname)"
    echo "Operating System: $(uname -o)"
    echo "Kernel Version: $(uname -r)"
    echo "Uptime: $(uptime -p)"
    echo ""
}

# ---------- FUNCTION: CPU LOAD ----------
cpu_info() {
    echo "===== CPU LOAD ====="
    uptime | awk -F'load average:' '{ print "Load Average:" $2 }'
    echo ""
}

# ---------- FUNCTION: MEMORY USAGE ----------
memory_info() {
    echo "===== MEMORY USAGE ====="
    free -h
    echo ""

    MEM_USAGE=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2 * 100}')

    if [ "$MEM_USAGE" -gt 80 ]; then
        echo "WARNING: Memory usage is above 80% ($MEM_USAGE%)"
        echo "$(date '+%Y-%m-%d %H:%M:%S') | HIGH MEMORY USAGE: $MEM_USAGE%" >> "$ALERT_LOG"
    fi
}

# ---------- FUNCTION: DISK USAGE ----------
disk_info() {
    echo "===== DISK USAGE ====="
    df -h
    echo ""

    df -h | awk 'NR>1 {print $5 " " $1}' | while read usage partition; do
        percent=$(echo $usage | cut -d'%' -f1)
        if [ "$percent" -gt 80 ]; then
            echo "WARNING: Disk usage on $partition is $usage"
            echo "$(date '+%Y-%m-%d %H:%M:%S') | HIGH DISK USAGE on $partition: $usage" >> "$ALERT_LOG"
        fi
    done
}

# ---------- FUNCTION: TOP PROCESSES ----------
top_processes() {
    echo "===== TOP 5 CPU-CONSUMING PROCESSES ====="
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
    echo ""
}

# ---------- GENERATE REPORT ----------
{
echo "SYSTEM HEALTH REPORT"
echo "Generated on: $(date)"
echo "================================"
echo ""

system_info
cpu_info
memory_info
disk_info
top_processes

} > "$REPORT_FILE"

echo "Health report generated: $REPORT_FILE"
