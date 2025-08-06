#!/system/bin/sh

# ================================
# ADB STRESS LOGGING SCRIPT
# ================================
# This script is designed to run on an Android device or through adb shell.
# It launches several common apps to simulate load and collects logs:
# - CPU usage
# - Memory usage
# - Temperature (all thermal sensors)
# These logs are stored in a timestamped folder in /sdcard/

# -------- CONFIGURATION --------
INTERVAL=10      # Seconds to wait between log captures
ITERATIONS=12    # Total number of logging cycles
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_DIR="/sdcard/adb_logs_$TIMESTAMP"

mkdir -p "$LOG_DIR"

# -------- APPS TO STRESS DEVICE --------
APPS="
com.android.chrome
com.android.settings
com.google.android.youtube
com.android.calculator2
"

# -------- START TEST --------
echo "==============================="
echo " Starting Android Stress Test"
echo "==============================="
echo "Logging to: $LOG_DIR"
echo "Each cycle launches apps and collects CPU, memory, and temperature data."
echo "Waiting $INTERVAL seconds between each cycle."
echo "Total cycles: $ITERATIONS"
echo ""

i=1
while [ $i -le $ITERATIONS ]
do
    echo "[$i/$ITERATIONS] Running stress cycle..."

    LOG_FILE="$LOG_DIR/log_$i.txt"
    echo "===== Stress Test Iteration $i =====" > "$LOG_FILE"
    echo "Timestamp: $(date)" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"

    # --- LAUNCH HEAVY APPS ---
    echo "Launching apps to simulate device usage..." >> "$LOG_FILE"
    for pkg in $APPS; do
        echo "- Launching $pkg" >> "$LOG_FILE"
        monkey -p "$pkg" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
        sleep 1
    done

    # --- CPU USAGE ---
    echo "" >> "$LOG_FILE"
    echo ">>> CPU Usage Snapshot:" >> "$LOG_FILE"
    echo "(Shows which apps and processes are using the most CPU)" >> "$LOG_FILE"
    top -n 1 >> "$LOG_FILE"

    # --- MEMORY USAGE ---
    echo "" >> "$LOG_FILE"
    echo ">>> Memory Usage Snapshot:" >> "$LOG_FILE"
    echo "(System memory status — free, cached, buffers, etc.)" >> "$LOG_FILE"
    cat /proc/meminfo >> "$LOG_FILE"

    # --- TEMPERATURES ---
    echo "" >> "$LOG_FILE"
    echo ">>> Temperature Sensors:" >> "$LOG_FILE"
    echo "(Below are readings from all available thermal zones)" >> "$LOG_FILE"

    zone=0
    while [ -f /sys/class/thermal/thermal_zone$zone/temp ]; do
        TEMP_RAW=$(cat /sys/class/thermal/thermal_zone$zone/temp)
        TYPE_FILE="/sys/class/thermal/thermal_zone$zone/type"
        if [ -f "$TYPE_FILE" ]; then
            ZONE_TYPE=$(cat "$TYPE_FILE")
        else
            ZONE_TYPE="Unknown"
        fi

        # Convert raw temp (e.g., 48000) to Celsius
        TEMP_C=$(awk "BEGIN {printf \"%.1f\", $TEMP_RAW / 1000}")
        echo "- Thermal Zone $zone ($ZONE_TYPE): $TEMP_C °C" >> "$LOG_FILE"
        zone=$((zone + 1))
    done

    echo "" >> "$LOG_FILE"
    echo "===== End of Iteration $i =====" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"

    sleep $INTERVAL
    i=$((i + 1))
done

echo ""
echo "==============================="
echo " Stress test completed."
echo " Logs saved to: $LOG_DIR"
echo "==============================="
