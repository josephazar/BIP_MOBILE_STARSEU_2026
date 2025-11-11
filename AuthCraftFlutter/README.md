# AuthCraft Flutter 🔐

> A complete Flutter authentication system demonstrating **secure credential storage** and **OWASP security best practices** for educational purposes.

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 🎯 Overview

AuthCraft Flutter is an **educational project** that demonstrates how to build a secure authentication system using:
- ✅ **Android Keystore** for secure credential storage (NOT SharedPreferences!)
- ✅ **OWASP Mobile Top 10** security guidelines
- ✅ **Clean architecture** with separation of concerns
- ✅ **Modern Flutter** best practices

### Why This Project?

The accompanying Android version (AuthCraftAndroid) uses **insecure SharedPreferences** for storing user data. This Flutter version shows the **correct, secure approach** using Android Keychain/Keystore via `flutter_secure_storage`.

**Key Difference**:
- ❌ Android version: Plain text XML files (SharedPreferences)
- ✅ Flutter version: AES-encrypted storage with hardware-backed keys (Keystore)

## ✨ Features

### Authentication
- 📧 **Email/Password Login** - Traditional login with secure session management
- 📱 **Mobile OTP Login** - Two-factor authentication via SMS
- ✍️ **User Registration** - Complete signup flow with validation
- 🔑 **Password Reset** - Three-step email-based password recovery

### User Management
- 👤 **Profile Management** - View and edit user information
- 🔒 **Change Password** - Secure password update functionality
- 🚪 **Logout** - Proper session cleanup

### Security Features
- 🔐 **Secure Storage** - Android Keystore integration
- ✅ **Input Validation** - Client-side validation for all inputs
- 🌐 **API Integration** - RESTful API with error handling
- 🔄 **Session Management** - Automatic session restoration

## 🔒 Security Highlights

### OWASP Mobile Top 10 Coverage

| Risk | Status | Implementation |
|------|--------|----------------|
| M2: Insecure Data Storage | ✅ | flutter_secure_storage with Keystore |
| M3: Insecure Communication | ⚠️ | HTTPS ready (HTTP for dev) |
| M4: Insecure Authentication | ✅ | Secure session management |
| M5: Insufficient Cryptography | ✅ | Platform crypto, AES encryption |
| M7: Client Code Quality | ✅ | Type-safe, validated inputs |

See **[SECURITY.md](SECURITY.md)** for complete security documentation.

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.0+
- Android Studio / VS Code
- Node.js (for backend)

### Installation

```bash
# 1. Navigate to the AuthCraftFlutter directory
cd "/Users/josephazar/Desktop/Android/BIP/BIP-Mobile Technologies and Programming/AuthCraftFlutter"

# 2. Install Flutter dependencies
flutter pub get

# 3. Fix Android v1 embedding error (IMPORTANT - run this to avoid build errors)
flutter create --platforms=android .

# 4. Start the backend server (in a new terminal)
cd "../user-auth-backend"
npm install
npm start

# 5. Update API URL (if needed)
# Edit lib/services/api_service.dart
# For emulator: http://10.0.2.2:3000/api/v1
# For device: http://YOUR_IP:3000/api/v1

# 6. Run the app
flutter run
```

**⚠️ Important**: If you encounter `Build failed due to use of deleted Android v1 embedding` error:
- Run `flutter create --platforms=android .` in the AuthCraftFlutter directory
- This regenerates the Android platform files with v2 embedding
- The AndroidManifest.xml is already configured for v2, but MainActivity needs to be created

**Detailed setup instructions**: [SETUP.md](SETUP.md)

## 📁 Project Structure

```
AuthCraftFlutter/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── models/
│   │   └── user_model.dart                # User & API response models
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart          # Email/password login
│   │   │   ├── register_screen.dart       # User registration
│   │   │   ├── login_mobile_screen.dart   # Mobile OTP login
│   │   │   └── forgot_password_screen.dart # Password reset
│   │   ├── profile/
│   │   │   ├── profile_screen.dart        # Edit profile
│   │   │   └── change_password_screen.dart # Change password
│   │   └── home_screen.dart               # Dashboard
│   ├── services/
│   │   ├── api_service.dart               # Backend API client
│   │   ├── auth_service.dart              # Authentication logic
│   │   └── secure_storage_service.dart    # Secure storage wrapper
│   └── utils/
│       └── validators.dart                # Input validators
├── android/                               # Android configuration
├── SECURITY.md                            # Security documentation
├── SETUP.md                               # Setup instructions
├── COMPARISON.md                          # Android vs Flutter
└── FEATURES.md                            # Feature details
```

## 📦 Dependencies

```yaml
dependencies:
  flutter_secure_storage: ^9.0.0   # Android Keystore integration
  http: ^1.1.0                     # API client
  provider: ^6.1.1                 # State management
```

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [README.md](README.md) | This file - project overview |
| [SETUP.md](SETUP.md) | Complete setup and installation guide |
| [SECURITY.md](SECURITY.md) | Detailed security documentation |
| [FEATURES.md](FEATURES.md) | Feature descriptions and implementation |
| [COMPARISON.md](COMPARISON.md) | Android vs Flutter comparison |
| [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) | Comprehensive project summary |
| [CHEATSHEET.md](CHEATSHEET.md) | Quick reference for developers |

## 🎓 What You'll Learn

- ✅ How to implement **secure storage** on Android using Keystore
- ✅ Why **SharedPreferences is insecure** for sensitive data
- ✅ **OWASP Mobile security** best practices
- ✅ **Flutter authentication patterns** and state management
- ✅ **API integration** with error handling
- ✅ **Form validation** and user input handling
- ✅ **Professional code organization** and architecture

## 🔄 Android vs Flutter

| Feature | Android (Kotlin) | Flutter (Dart) |
|---------|------------------|----------------|
| **Storage** | SharedPreferences ❌ | Android Keystore ✅ |
| **Security** | Insecure (plain XML) | Secure (encrypted) |
| **Cross-platform** | Android only | Android + iOS |
| **Development** | Slower | Faster (hot reload) |

See [COMPARISON.md](COMPARISON.md) for detailed comparison.

## 🎨 Screenshots

### Login Flow
```
[Splash] → [Login] → [Home]
            ↓
        [Register]
            ↓
    [Mobile Login]
            ↓
   [Forgot Password]
```

## 🧪 Testing

Create a test account:
1. Click "Register"
2. Fill in details (use any valid email format)
3. Login with created credentials
4. Test all features (profile, password change, logout)

## ⚠️ Educational Limitations

This is for **learning purposes**. Not included (but recommended for production):

- Certificate pinning
- Biometric authentication
- Token refresh mechanism
- Root/jailbreak detection
- Code obfuscation
- Backend password hashing (uses plaintext in demo)

## 🛠️ Tech Stack

- **Frontend**: Flutter 3.0+, Dart 3.0+
- **State Management**: Provider
- **Storage**: flutter_secure_storage (Android Keystore)
- **HTTP Client**: http package
- **Backend**: Node.js + Express (user-auth-backend)

## 📖 API Integration

Works with the included Node.js backend (`user-auth-backend`):

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/register` | POST | User registration |
| `/login` | POST | Email/password login |
| `/login_with_mobile` | POST | Send OTP |
| `/check_otp` | POST | Verify OTP |
| `/send_password_reset_code` | POST | Send reset code |
| `/check_verification_code` | POST | Verify code |
| `/reset_password` | POST | Reset password |
| `/user_details/:id` | GET | Get user data |
| `/user_update/:id` | PUT | Update profile |
| `/change_password/:id` | PUT | Change password |

## 🤝 Contributing

This is an educational project. Feel free to:
- Fork and experiment
- Add new features
- Improve security
- Enhance documentation

## 📄 License

MIT License - see LICENSE file for details

## 🎯 Key Takeaways

1. **Never use SharedPreferences** for sensitive data
2. **Use platform-provided security** (Android Keystore, iOS Keychain)
3. **Validate inputs** on both client and server
4. **Follow OWASP guidelines** for mobile security
5. **Separate concerns** (UI, logic, storage)

## 🌟 Next Steps

After exploring this project:

1. Read [SECURITY.md](SECURITY.md) to understand security practices
2. Compare with Android version in [COMPARISON.md](COMPARISON.md)
3. Try adding biometric authentication
4. Implement certificate pinning
5. Add unit tests

## 📞 Support

For questions about this educational project:
- 📖 Check the documentation files
- 🔍 Review the code comments
- 🎓 Study OWASP Mobile Top 10

---

**Built for Education** | **Security First** | **Modern Flutter** | **OWASP Compliant**

⭐ Star this repo if you found it helpful for learning secure Flutter development!
