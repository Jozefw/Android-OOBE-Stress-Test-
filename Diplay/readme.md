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


🔹 1. Prepare the Script
Copy the full script (if you haven’t already)

Save it on your PC as:

display_stress_test.sh


🔹 2. Connect Your Android Tablet to Your PC
Make sure:

USB debugging is enabled on your tablet

You have adb installed and working

Then run this on your PC terminal:

adb devices
You should see your tablet listed as device.

🔹 3. Push the Script to the Android Device
Use the following command from your PC terminal:

adb push display_stress_test.sh /sdcard/
This copies the script to the device’s internal storage.

🔹 4. Start a Shell Session on the Device
Open an interactive shell on the device:

adb shell
You are now inside the Android device's Linux shell (you’ll see something like generic_x86:/ $).

🔹 5. Run the Script
Inside the adb shell, run:

sh /sdcard/display_stress_test.sh
Note: If you get a permission denied error, try:

chmod +x /sdcard/display_stress_test.sh
sh /sdcard/display_stress_test.sh


🔹 6. Wait for the Script to Complete
The script runs for a set number of iterations (default is 20).

Each iteration launches apps and logs the display state.

Logs are saved in:

/sdcard/display_stress_logs_<timestamp>/


🔹 7. (Optional) Pull Logs Back to Your PC
When the script finishes, you can copy logs to your PC:

adb pull /sdcard/display_stress_logs_20250804_142205 .
(Replace the timestamp with the actual folder name shown in the script output)

🧪 What You’ll See in Each Log File
Example content of /sdcard/display_stress_logs_1/display_3.txt:


=========================
DISPLAY STATE UNDER LOAD - Iteration 3
=========================
Resolution: 1600x900
⚠ Resolution changed from 2000x1200 to 1600x900
⮞ Meaning: The system may be dynamically scaling resolution to reduce GPU or thermal load.

Display Density (DPI): 280
⚠ DPI changed from 320 to 280
⮞ Meaning: The UI scale has been altered, possibly to reduce rendering workload.

Refresh Rate (Hz): 60.0
⚠ Refresh rate dropped from 90.0Hz to 60.0Hz
⮞ Meaning: The system may be throttling to save power or reduce heat.
=========================
🧠 Summary
Step	        Command (run on PC)	                        Purpose
1. Push script	adb push display_stress_test.sh /sdcard/	Move script to device
2. Open shell	adb shell	                                Enter Android’s Linux shell
3. Run script	sh /sdcard/display_stress_test.sh	        Start the logging process
4. View logs	On-device: /sdcard/display_stress_logs_<timestamp>/	Views output
5. Pull logs	adb pull /sdcard/...	                    Copy logs back to PC


