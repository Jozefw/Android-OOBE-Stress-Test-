#!/system/bin/sh

# CONFIGURATION
ITERATIONS=20
INTERVAL=10
LOG_DIR="/sdcard/display_stress_logs_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$LOG_DIR"

# HEAVY APPS TO LAUNCH (package names)
APPS="
com.google.android.youtube
com.android.chrome
com.netflix.mediaclient
com.google.android.apps.photos
"

echo "=========================" > "$LOG_DIR/display_0_idle.txt"
echo "BASELINE DISPLAY STATE" >> "$LOG_DIR/display_0_idle.txt"
echo "=========================" >> "$LOG_DIR/display_0_idle.txt"

# Capture baseline values
BASE_RES=$(wm size | awk '{print $3}')
BASE_DPI=$(wm density | awk '{print $3}')
BASE_HZ=$(dumpsys display | grep -i "mActiveMode" | grep -oE "[0-9]+\.[0-9]+" | head -1)

echo "Resolution: $BASE_RES" >> "$LOG_DIR/display_0_idle.txt"
echo "Display Density (DPI): $BASE_DPI" >> "$LOG_DIR/display_0_idle.txt"
echo "Refresh Rate (Hz): $BASE_HZ" >> "$LOG_DIR/display_0_idle.txt"
echo "=========================" >> "$LOG_DIR/display_0_idle.txt"

echo "Baseline logged. Starting stress test..."

# STRESS + LOGGING LOOP
i=1
while [ $i -le $ITERATIONS ]
do
    echo "[Iteration $i/$ITERATIONS] Running stress test..."

    # Launch heavy apps
    for pkg in $APPS; do
        monkey -p "$pkg" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
        sleep 1
    done

    # Synthetic stress with monkey
    monkey --pct-touch 80 --pct-motion 15 --throttle 100 -v 300 >/dev/null 2>&1

    # Capture current values
    CUR_RES=$(wm size | awk '{print $3}')
    CUR_DPI=$(wm density | awk '{print $3}')
    CUR_HZ=$(dumpsys display | grep -i "mActiveMode" | grep -oE "[0-9]+\.[0-9]+" | head -1)

    LOG_FILE="$LOG_DIR/display_${i}.txt"
    echo "=========================" > "$LOG_FILE"
    echo "DISPLAY STATE UNDER LOAD - Iteration $i" >> "$LOG_FILE"
    echo "=========================" >> "$LOG_FILE"

    echo "Resolution: $CUR_RES" >> "$LOG_FILE"
    if [ "$CUR_RES" != "$BASE_RES" ]; then
        echo "⚠ Resolution changed from $BASE_RES to $CUR_RES" >> "$LOG_FILE"
        echo "⮞ Meaning: Possible resolution scaling to reduce GPU or thermal load." >> "$LOG_FILE"
    fi

    echo >> "$LOG_FILE"

    echo "Display Density (DPI): $CUR_DPI" >> "$LOG_FILE"
    if [ "$CUR_DPI" != "$BASE_DPI" ]; then
        echo "⚠ DPI changed from $BASE_DPI to $CUR_DPI" >> "$LOG_FILE"
        echo "⮞ Meaning: UI scale may have been reduced to lower rendering cost." >> "$LOG_FILE"
    fi

    echo >> "$LOG_FILE"

    echo "Refresh Rate (Hz): $CUR_HZ" >> "$LOG_FILE"
    if [ "$CUR_HZ" != "$BASE_HZ" ]; then
        echo "⚠ Refresh rate dropped from $BASE_HZ Hz to $CUR_HZ Hz" >> "$LOG_FILE"
        echo "⮞ Meaning: Device may be throttling for battery or thermal reasons." >> "$LOG_FILE"
    fi

    echo "=========================" >> "$LOG_FILE"

    sleep $INTERVAL
    i=$((i + 1))
done

echo "Stress test completed. Logs saved to: $LOG_DIR"
