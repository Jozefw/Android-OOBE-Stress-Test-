✅ Part 1: Enable USB Debugging on Your Tablet
🔹 Step 1: Unlock Developer Options
Go to Settings > About tablet (or About device).

Scroll down to Build number.

Tap Build number 7 times quickly.

You’ll see: "You are now a developer!"

🔹 Step 2: Turn On USB Debugging
Go back to Settings.

Go to System (if available) > Developer options.

Scroll down and enable:
✅ USB debugging

Connect your tablet to your PC via USB.

You’ll see a prompt on the tablet:

Allow USB debugging from this computer?

✅ Tap Allow
(Optionally check Always allow from this computer)

✅ Part 2: Install ADB on Windows
🔹 Step 1: Download ADB
Go to:
👉 https://developer.android.com/tools/releases/platform-tools

Download the Windows ZIP version.

Extract it to a folder, e.g.:

C:\platform-tools


🔹 Step 2: Open Command Prompt
Press Win + R, type:

Run: cmd
and hit Enter

Navigate to the platform-tools folder:

cd C:\platform-tools

🔹 Step 3: Test the ADB Connection
Run: adb devices
If everything is working, you’ll see:


List of devices attached
R9xxxxxxx	device
If it says unauthorized, check your tablet and approve the USB debugging request.

🔁 Troubleshooting Tips
Problem	Fix
No device listed	Try another USB cable or port
Says "unauthorized"	Check tablet screen and tap "Allow"
Still not working	On your tablet, go to Developer options > toggle USB debugging off and on, then reconnect


------------- Next ------------


Connect Your Android Tablet via USB
Make sure:

Developer mode is on

USB Debugging is enabled

Run: adb devices

Confirm your device is listed.

Push the Script to Your Tablet

adb push adb_stress_logger_verbose.sh /sdcard/

Run the Script on the Device

Run: adb shell
Run: sh /sdcard/adb_stress_logger_verbose.sh
🔍 Note: You’re now executing the script inside the Android device's Linux shell.

View the Logs
Once complete, logs will be stored here:

/sdcard/adb_logs_<timestamp>/

Each file like log_1.txt, log_2.txt, etc., contains:

        Apps launched

        CPU usage

        Memory snapshot

        Temperature readings from all sensors

✅ Summary of What the Script Does
Metric	Description
CPU Usage	Shows how much CPU is being used by each process (top)
Memory Info	System memory stats (/proc/meminfo)
Temperature	All available thermal zones with readable °C conversion
Apps Launched	Simulates real-world usage/load
Non-technical Logs	Adds explanations for each log section so anyone can interpret it
