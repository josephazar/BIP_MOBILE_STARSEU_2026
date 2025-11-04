# BIP Mobile Flutter

This repository contains Flutter mobile applications for the BIP project.

## Projects

### vuln_note/
An intentionally vulnerable Flutter application designed for educational purposes to demonstrate OWASP Mobile Top 10 (2024) security vulnerabilities.

**⚠️ WARNING:** This app contains 15 intentional security vulnerabilities and should NEVER be used in production.

**Purpose:** Educational tool for learning mobile application security, penetration testing, and secure coding practices.

**Key Features:**
- 15 OWASP Mobile Top 10 vulnerabilities
- SQL injection demonstration
- Insecure authentication & authorization
- Weak cryptography examples
- Insecure data storage
- Debug mode vulnerabilities

**Documentation:**
- [Installation Guide](vuln_note/INSTALLATION_GUIDE.md)
- [Project README](vuln_note/README.md)

## Prerequisites

- Flutter SDK 3.0.0 or higher
- Android Studio with Android SDK
- Android Emulator or physical device
- Xcode (for iOS development - optional)

## Quick Start

### Setup Flutter Environment

1. **Install Flutter:**
   ```bash
   # Download Flutter SDK from https://flutter.dev/docs/get-started/install
   # Add to PATH:
   export PATH="$PATH:/path/to/flutter/bin"
   ```

2. **Verify Installation:**
   ```bash
   flutter doctor
   ```

3. **Accept Android Licenses:**
   ```bash
   flutter doctor --android-licenses
   ```

### Running vuln_note

```bash
cd vuln_note
flutter pub get
flutter run
```

## Development Setup

### Android Development

1. Install Android Studio
2. Install Android SDK Command-line Tools
3. Set up Android Emulator via AVD Manager
4. Accept Android licenses: `flutter doctor --android-licenses`

### iOS Development (macOS only)

1. Install Xcode from Mac App Store
2. Install CocoaPods: `sudo gem install cocoapods`
3. Set up iOS Simulator

## Project Structure

```
BIP_MOBILE_FLUTTER/
├── vuln_note/              # Vulnerable demo app
│   ├── lib/                # Dart source code
│   ├── android/            # Android platform files
│   ├── ios/                # iOS platform files
│   └── pubspec.yaml        # Dependencies
└── README.md               # This file
```

## Educational Use Only

The applications in this repository, particularly `vuln_note`, are designed for educational and training purposes only. They demonstrate security vulnerabilities and should not be used as templates for production applications.

**DO NOT:**
- Use this code in production applications
- Deploy these apps to app stores
- Use with real user data
- Practice attacks on apps you don't own

**DO:**
- Learn about mobile security vulnerabilities
- Practice secure coding techniques
- Understand OWASP Mobile Top 10
- Use for security training and education

## Resources

- [OWASP Mobile Top 10 2024](https://owasp.org/www-project-mobile-top-10/)
- [Flutter Security Best Practices](https://flutter.dev/docs/deployment/security)
- [Talsec Mobile Security Articles](https://docs.talsec.app/appsec-articles/articles/)
- [Flutter Documentation](https://flutter.dev/docs)

## License

Educational use only. See individual project folders for specific licensing information.

## Disclaimer

This repository contains intentionally vulnerable code for educational purposes. The creators are not responsible for any misuse of this code. Always follow ethical guidelines and only test security on applications you own or have explicit permission to test.
