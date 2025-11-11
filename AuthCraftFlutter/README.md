# AuthCraft Flutter 🔐

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.0+
- Android Studio / VS Code
- Node.js (for backend)

### Installation

```bash
# 1. Navigate to the AuthCraftFlutter directory
cd "your_path/AuthCraftFlutter"

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
