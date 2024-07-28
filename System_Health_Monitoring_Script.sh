#!/bin/bash
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Log file variable
LOG_FILE="./system_health.log"
# Check CPU 
check_cpu() {
    # Get the current CPU usage
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
    if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
        echo "$(date): CPU usage is above threshold: ${CPU_USAGE}%" >> $LOG_FILE
    fi
}
# Check memory 
check_memory() {
    # current memory usage
    MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
        echo "$(date): Memory usage is above threshold: ${MEMORY_USAGE}%" >> $LOG_FILE
    fi
}

# Check disk 
check_disk() {
    DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
    # If disk usage is greater
    if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
        echo "$(date): Disk usage is above threshold: ${DISK_USAGE}%" >> $LOG_FILE
    fi
}
check_processes() {
    RUNNING_PROCESSES=$(ps aux --no-heading | wc -l)
    echo "$(date): Number of running processes: ${RUNNING_PROCESSES}" >> $LOG_FILE
}

check_cpu
check_memory
check_disk
check_processes

echo "System health check completed. Alerts (if any) have been logged to $LOG_FILE"
