# VulnNote - Installation and Setup Guide for Beginners


---

## Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Installing Flutter](#installing-flutter)
4. [Setting Up the Development Environment](#setting-up-the-development-environment)
5. [Running the VulnNote App](#running-the-vulnnote-app)
6. [Exploring the Vulnerabilities](#exploring-the-vulnerabilities)
7. [Troubleshooting](#troubleshooting)
8. [Next Steps](#next-steps)

---

## Introduction

Welcome to the VulnNote installation guide! This document will walk you through every step needed to install, run, and explore the VulnNote app on your computer. VulnNote is an intentionally vulnerable Flutter application designed to help you learn about mobile security vulnerabilities.

**What you'll learn:**
- How to install Flutter development tools
- How to run a Flutter app on an emulator or physical device
- How to explore and understand security vulnerabilities
- How to test different attack scenarios

**What you'll need:**
- A computer running Windows, macOS, or Linux
- At least 8 GB of RAM (16 GB recommended)
- At least 10 GB of free disk space
- Internet connection for downloading tools and dependencies

---

## Prerequisites

Before we begin, let's make sure you have everything you need.

### System Requirements

| Operating System | Minimum Requirements |
|-----------------|---------------------|
| **Windows** | Windows 10 or later (64-bit) |
| **macOS** | macOS 10.14 (Mojave) or later |
| **Linux** | Ubuntu 18.04 or later (64-bit) |

### Required Software

You'll need to install the following software:

1. **Flutter SDK** - The framework for building the app
2. **Android Studio** - For Android development and emulator
3. **Git** - For version control (usually pre-installed on macOS/Linux)
4. **Visual Studio Code** (optional but recommended) - Code editor

Don't worry if you don't have these installed yet. We'll guide you through the installation process step by step.

---

## Installing Flutter

Flutter is the framework used to build the VulnNote app. Follow the instructions for your operating system.

### Windows Installation

**Step 1: Download Flutter SDK**

1. Visit the official Flutter website: [https://flutter.dev/docs/get-started/install/windows](https://flutter.dev/docs/get-started/install/windows)
2. Download the latest stable Flutter SDK (ZIP file)
3. Extract the ZIP file to a location like `C:\src\flutter`
   - **Important:** Do NOT install Flutter in a directory that requires elevated privileges (like `C:\Program Files\`)

**Step 2: Update PATH Environment Variable**

1. Open the Start menu and search for "Environment Variables"
2. Click "Edit the system environment variables"
3. Click the "Environment Variables" button
4. Under "User variables", find the "Path" variable and click "Edit"
5. Click "New" and add the full path to `flutter\bin` (e.g., `C:\src\flutter\bin`)
6. Click "OK" to save

**Step 3: Verify Installation**

1. Open a new Command Prompt window
2. Run the following command:

```bash
flutter doctor
```

This command checks your environment and displays a report. Don't worry if you see some red X marks - we'll fix those in the next steps.

---

### macOS Installation

**Step 1: Download Flutter SDK**

1. Visit: [https://flutter.dev/docs/get-started/install/macos](https://flutter.dev/docs/get-started/install/macos)
2. Download the latest stable Flutter SDK (ZIP file)
3. Extract the file to your desired location:

```bash
cd ~/development
unzip ~/Downloads/flutter_macos_*.zip
```

**Step 2: Update PATH**

Add Flutter to your PATH by editing your shell configuration file:

```bash
# For bash (default on older macOS)
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bash_profile
source ~/.bash_profile

# For zsh (default on newer macOS)
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

**Step 3: Verify Installation**

Open a new terminal window and run:

```bash
flutter doctor
```

---

### Linux Installation

**Step 1: Download Flutter SDK**

```bash
cd ~/development
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_*-stable.tar.xz
tar xf flutter_linux_*-stable.tar.xz
```

**Step 2: Update PATH**

```bash
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
```

**Step 3: Install Dependencies**

```bash
sudo apt-get update
sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa
```

**Step 4: Verify Installation**

```bash
flutter doctor
```

---

## Setting Up the Development Environment

Now that Flutter is installed, let's set up the tools needed to run the app.

### Installing Android Studio

Android Studio provides the Android SDK and emulator needed to run Flutter apps.

**Step 1: Download Android Studio**

1. Visit: [https://developer.android.com/studio](https://developer.android.com/studio)
2. Download Android Studio for your operating system
3. Run the installer and follow the setup wizard

**Step 2: Install Android SDK**

During the Android Studio setup:
1. Choose "Standard" installation type
2. Accept the license agreements
3. Wait for the SDK components to download (this may take 10-20 minutes)

**Step 3: Configure Flutter to Use Android SDK**

Run this command to accept Android licenses:

```bash
flutter doctor --android-licenses
```

Type `y` to accept each license.

---

### Setting Up an Android Emulator

An emulator lets you run the app on a virtual Android device.

**Step 1: Open AVD Manager**

1. Open Android Studio
2. Click "More Actions" → "Virtual Device Manager"
3. Click "Create Device"

**Step 2: Choose a Device**

1. Select a device definition (e.g., "Pixel 5")
2. Click "Next"

**Step 3: Select System Image**

1. Choose a system image (e.g., "R" for Android 11)
2. Click "Download" next to the system image
3. Wait for the download to complete
4. Click "Next"

**Step 4: Finish Setup**

1. Give your emulator a name (e.g., "Pixel_5_API_30")
2. Click "Finish"

**Step 5: Start the Emulator**

1. In the AVD Manager, click the ▶️ (Play) button next to your emulator
2. Wait for the emulator to boot (first boot may take 2-3 minutes)

---

### Installing Visual Studio Code (Optional)

Visual Studio Code is a lightweight code editor that works great with Flutter.

**Step 1: Download VS Code**

1. Visit: [https://code.visualstudio.com/](https://code.visualstudio.com/)
2. Download and install VS Code for your operating system

**Step 2: Install Flutter Extension**

1. Open VS Code
2. Click the Extensions icon (or press `Ctrl+Shift+X` / `Cmd+Shift+X`)
3. Search for "Flutter"
4. Click "Install" on the Flutter extension by Dart Code
5. This will also install the Dart extension automatically

---

## Running the VulnNote App

Now that your development environment is ready, let's run the VulnNote app!

### Step 1: Get the VulnNote Code

You should have received the VulnNote app folder. If you have it as a ZIP file:

1. Extract the ZIP file to a location like:
   - Windows: `C:\Users\YourName\Documents\vuln_note`
   - macOS/Linux: `~/Documents/vuln_note`

### Step 2: Open the Project

**Using VS Code:**

1. Open VS Code
2. Click "File" → "Open Folder"
3. Navigate to the `vuln_note` folder and select it
4. Click "Select Folder" (Windows) or "Open" (macOS)

**Using Command Line:**

```bash
cd ~/Documents/vuln_note  # or your path
```

### Step 3: Install Dependencies

Open a terminal in the project folder and run:

```bash
flutter pub get
```

This command downloads all the packages (libraries) that the app needs. You should see output like:

```
Running "flutter pub get" in vuln_note...
Resolving dependencies...
Got dependencies!
```

### Step 4: Check Connected Devices

Make sure your emulator is running or your physical device is connected, then run:

```bash
flutter devices
```

You should see output like:

```
2 connected devices:

Pixel 5 API 30 (mobile) • emulator-5554 • android-x64 • Android 11 (API 30)
Chrome (web)            • chrome        • web-javascript • Google Chrome 119.0
```

### Step 5: Run the App

Now, let's run the app! Execute this command:

```bash
flutter run
```

**What happens next:**

1. Flutter compiles the app (first time takes 2-5 minutes)
2. The app is installed on your emulator/device
3. The app launches automatically
4. You'll see the login screen

**Expected output:**

```
Launching lib/main.dart on Pixel 5 API 30 in debug mode...
Running Gradle task 'assembleDebug'...
✓ Built build/app/outputs/flutter-apk/app-debug.apk.
Installing build/app/outputs/flutter-apk/app-debug.apk...
Syncing files to device Pixel 5 API 30...
Flutter run key commands.
r Hot reload.
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).

💪 Running with sound null safety 💪

An Observatory debugger and profiler on Pixel 5 API 30 is available at: http://127.0.0.1:xxxxx/
The Flutter DevTools debugger and profiler on Pixel 5 API 30 is available at: http://127.0.0.1:xxxxx/
```

**Congratulations! The app is now running!** 🎉

---

## Exploring the Vulnerabilities

Now that the app is running, let's explore the security vulnerabilities.

### Using the App

**Step 1: Login Screen**

When you first open the app, you'll see the login screen.

**Try these experiments:**

1. **Weak Password Test**
   - Username: `testuser`
   - Password: `1` (just the number one!)
   - Click "Login"
   - ✅ It works! This demonstrates **Vulnerability #4: Weak Password Validation**

2. **Admin Access Test**
   - Username: `admin`
   - Password: `admin123`
   - Click "Login"
   - ✅ You're logged in as admin! This demonstrates **Vulnerability #5: Hardcoded Admin Credentials**

3. **Remember Me Test**
   - Enter any username and password
   - Check the "Remember Me" box
   - Click "Login"
   - ✅ Your password is stored in plain text! This demonstrates **Vulnerability #13: Plain Text Password Storage**

**Step 2: Notes Screen**

After logging in, you can create and manage notes.

**Try these experiments:**

1. **SQL Injection Test**
   - Create a few notes with different titles
   - In the search box, type: `' OR '1'='1' --`
   - ✅ You'll see ALL notes, bypassing the search filter! This demonstrates **Vulnerability #7: SQL Injection**

2. **No Input Validation Test**
   - Click the + button to add a note
   - Try entering a very long title (1000+ characters)
   - Try entering special characters: `<script>alert("XSS")</script>`
   - ✅ The app accepts everything! This demonstrates **Vulnerability #8: No Input Sanitization**

3. **Client-Side Authorization Test** (Admin only)
   - Login as admin (admin/admin123)
   - Notice the "Delete All" button in the toolbar
   - This button only appears based on client-side check
   - ✅ This demonstrates **Vulnerability #6: Client-Side Authorization**

**Step 3: Settings Screen**

Click the settings icon to see the Settings screen.

**What you'll see:**

1. **Debug Information Section**
   - Shows the hardcoded API key (Vulnerability #1)
   - Shows the HTTP endpoint (Vulnerability #9)
   - Shows your auth token in plain text (Vulnerability #2)
   - Shows your saved password (Vulnerability #13)

2. **Privacy & Permissions Section**
   - Lists excessive permissions requested (Vulnerability #11)
   - Camera, Location, Contacts - none needed for note-taking!

3. **Security Vulnerabilities List**
   - Complete list of all 15 vulnerabilities in the app

---

### Viewing Logs

To see the debug logging vulnerability in action:

**Android (using ADB):**

```bash
# View real-time logs
adb logcat | grep flutter

# You'll see sensitive data being logged:
# I/flutter: 🔓 Login attempt for user: testuser
# I/flutter: 🔑 Password hash: 5f4dcc3b5aa765d61d8327deb882cf99
# I/flutter: 🎫 Generated token: jwt_token_1699012345_testuser
```

**VS Code:**

1. The Debug Console automatically shows all print statements
2. Look for lines with 🔓, 🔑, and 🎫 emojis
3. You'll see usernames, password hashes, and tokens being logged

This demonstrates **Vulnerability #3: Debug Logging Sensitive Data**

---

### Accessing Stored Data

To see how insecure data storage works:

**Android - SharedPreferences:**

```bash
# Connect to device
adb shell

# Navigate to app data (requires root or debuggable app)
cd /data/data/com.example.vuln_note/shared_prefs/

# View the preferences file
cat FlutterSharedPreferences.xml

# You'll see:
# <string name="flutter.auth_token">jwt_token_1699012345_testuser</string>
# <string name="flutter.saved_password">testpassword</string>
```

This demonstrates:
- **Vulnerability #2: Insecure Token Storage**
- **Vulnerability #13: Plain Text Password Storage**

**Android - SQLite Database:**

```bash
# Still in adb shell
cd /data/data/com.example.vuln_note/databases/

# Open the database
sqlite3 notes.db

# View all notes
SELECT * FROM notes;

# You'll see all notes in plain text!
```

This demonstrates **Vulnerability #14: Unencrypted SQLite Database**

---

### Testing Network Communication

To see the HTTP vulnerability:

**Step 1: Install mitmproxy (optional, advanced)**

```bash
# Install mitmproxy
pip install mitmproxy

# Start mitmproxy
mitmproxy
```

**Step 2: Configure Device Proxy**

1. In the emulator, go to Settings → Network & Internet → Wi-Fi
2. Long-press on the connected network
3. Modify network → Advanced options
4. Set proxy to Manual
5. Hostname: `10.0.2.2` (for Android emulator)
6. Port: `8080`

**Step 3: Trigger Network Request**

1. In the VulnNote app, click the sync button (↻ icon)
2. In mitmproxy, you'll see the HTTP request
3. You can see the API key, token, and note content in plain text!

This demonstrates:
- **Vulnerability #9: HTTP Endpoint Usage**
- **Vulnerability #10: No Certificate Pinning**

---

## Troubleshooting

### Common Issues and Solutions

**Issue: "flutter: command not found"**

**Solution:**
- Make sure you added Flutter to your PATH
- Close and reopen your terminal/command prompt
- Verify with: `echo $PATH` (macOS/Linux) or `echo %PATH%` (Windows)

---

**Issue: "Android SDK not found"**

**Solution:**
- Run `flutter doctor` to see the exact issue
- Make sure Android Studio is installed
- Run `flutter doctor --android-licenses` and accept all licenses

---

**Issue: "No devices found"**

**Solution:**
- Make sure your emulator is running
- Run `flutter devices` to list available devices
- For physical device: Enable USB debugging in Developer Options

---

**Issue: "Gradle build failed"**

**Solution:**
- Make sure you have internet connection (Gradle downloads dependencies)
- Try running: `flutter clean` then `flutter pub get`
- Check if you have enough disk space (at least 5 GB free)

---

**Issue: "App crashes on startup"**

**Solution:**
- Check the logs: `flutter logs`
- Make sure all dependencies are installed: `flutter pub get`
- Try running on a different emulator or device

---

**Issue: "Cannot access /data/data/ directory"**

**Solution:**
- This is normal on non-rooted devices
- The app is intentionally set to `debuggable="true"` to allow access
- On a real device, you would need root access
- Use `adb backup` as an alternative:

```bash
adb backup -f backup.ab com.example.vuln_note
```

---

## Next Steps

Now that you have the app running, here's what you can do next:

### 1. Study the Code

Open the source code files and look for the vulnerability markers:

```dart
// 🚨 VULNERABILITY #1: Hardcoded API Key
// OWASP: M1 - Improper Credential Usage
// Risk: API key can be extracted through reverse engineering
```

Each vulnerability is clearly marked with:
- Vulnerability number
- OWASP category
- Risk description
- Reference links

### 2. Read the Documentation

- **VULNERABILITIES_AND_SOLUTIONS.md** - Detailed explanation of each vulnerability with solutions
- **README.md** - Overview of the app and vulnerability list

### 3. Try to Fix the Vulnerabilities

Challenge yourself to fix each vulnerability:

1. Start with one vulnerability at a time
2. Read the solution in VULNERABILITIES_AND_SOLUTIONS.md
3. Implement the fix in the code
4. Test to make sure it works
5. Move to the next vulnerability

### 4. Compare Before and After

Create a branch to keep the original vulnerable code:

```bash
git init
git add .
git commit -m "Original vulnerable version"
git branch vulnerable
git checkout -b secure
# Now make your fixes on the 'secure' branch
```

### 5. Learn More About Mobile Security

**Recommended Resources:**

- [OWASP Mobile Top 10 2024](https://owasp.org/www-project-mobile-top-10/2023-risks/)
- [Talsec OWASP Top 10 for Flutter Series](https://docs.talsec.app/appsec-articles/articles/)
- [Flutter Security Best Practices](https://flutter.dev/docs/deployment/security)
- [OWASP Mobile Application Security](https://mas.owasp.org/)

### 6. Practice Ethical Hacking

**Tools to Learn:**

- **Frida** - Dynamic instrumentation toolkit
- **APKTool** - Reverse engineering Android APKs
- **mitmproxy** - Intercepting HTTP/HTTPS traffic
- **Burp Suite** - Web application security testing

**Important:** Only practice on apps you own or have permission to test!

---

## Conclusion

Congratulations on setting up and running the VulnNote app! You now have a working environment to learn about mobile application security vulnerabilities.

**Remember:**
- This app is for educational purposes only
- Never use these vulnerable patterns in production apps
- Always follow security best practices
- Keep learning and stay curious!

**Need Help?**

If you encounter any issues or have questions:
1. Check the Troubleshooting section above
2. Review the Flutter documentation: [https://flutter.dev/docs](https://flutter.dev/docs)
3. Search for solutions on Stack Overflow
4. Review the OWASP Mobile Security documentation

---

**Document Version:** 1.0  
**Last Updated:** November 3, 2025  

Happy learning! 🚀🔒
