# AuthCraft Flutter - Setup Guide

This guide will help you set up and run the AuthCraft Flutter application.

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio or VS Code with Flutter extensions
- Android device or emulator
- Node.js (for backend server)

## Step 1: Install Flutter Dependencies

Navigate to the project directory and install dependencies:

```bash
cd AuthCraftFlutter
flutter pub get
```

## Step 2: Start the Backend Server

1. Navigate to the backend directory:
```bash
cd ../user-auth-backend
```

2. Install backend dependencies (if not already done):
```bash
npm install
```

3. Start the backend server:
```bash
npm start
```

The backend should be running on `http://localhost:3000`

## Step 3: Configure API Base URL

The app is already configured to work with Android emulator. The API base URL in `lib/services/api_service.dart` is set to:

```dart
static const String baseUrl = 'http://10.0.2.2:3000/api/v1';
```

**Note**:
- `10.0.2.2` is the special IP address for Android emulator to access `localhost` on your computer
- If using a physical device, replace with your computer's IP address (e.g., `http://192.168.1.100:3000/api/v1`)

To find your computer's IP:
- **Mac/Linux**: `ifconfig | grep inet`
- **Windows**: `ipconfig`

## Step 4: Run the Flutter App

### Using Android Emulator

1. Start your Android emulator from Android Studio
2. Run the app:
```bash
flutter run
```

### Using Physical Android Device

1. Enable Developer Options and USB Debugging on your device
2. Connect device via USB
3. Update the base URL in `lib/services/api_service.dart` with your computer's IP
4. Run the app:
```bash
flutter run
```

## Step 5: Testing the App

### Create a Test Account

1. Open the app
2. Click "Register"
3. Fill in the registration form:
   - Name: Test User
   - Mobile: 1234567890
   - Email: test@example.com
   - Password: test123
   - Confirm Password: test123
4. Click "Register"
5. After successful registration, you'll be redirected to login

### Login

1. Enter your email and password
2. Click "Login"
3. You should be logged into the home screen

### Test Other Features

- **Mobile Login**: Login using mobile number with OTP
- **Forgot Password**: Reset password via email verification
- **Profile**: View and update user profile
- **Change Password**: Change your account password

## Project Structure

```
AuthCraftFlutter/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── models/
│   │   └── user_model.dart                # User data models
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart          # Email login
│   │   │   ├── register_screen.dart       # User registration
│   │   │   ├── login_mobile_screen.dart   # Mobile OTP login
│   │   │   └── forgot_password_screen.dart # Password reset
│   │   ├── profile/
│   │   │   ├── profile_screen.dart        # User profile
│   │   │   └── change_password_screen.dart # Change password
│   │   └── home_screen.dart               # Home/Dashboard
│   ├── services/
│   │   ├── api_service.dart               # Backend API client
│   │   ├── auth_service.dart              # Authentication logic
│   │   └── secure_storage_service.dart    # Secure storage (Keychain)
│   └── utils/
│       └── validators.dart                # Input validation
├── android/
│   └── app/src/main/
│       └── AndroidManifest.xml            # Android permissions
├── pubspec.yaml                           # Dependencies
├── README.md                              # Project overview
├── SECURITY.md                            # Security documentation
└── SETUP.md                               # This file
```

## Key Dependencies

```yaml
dependencies:
  flutter_secure_storage: ^9.0.0  # Android Keystore integration
  http: ^1.1.0                     # HTTP client
  provider: ^6.1.1                 # State management
```

## Security Features

✅ **Secure Storage**: Uses Android Keychain/Keystore via `flutter_secure_storage`
✅ **Input Validation**: All inputs validated before submission
✅ **Session Management**: Secure session handling
✅ **Type Safety**: Dart's type system prevents many vulnerabilities

See [SECURITY.md](SECURITY.md) for detailed security documentation.

## Troubleshooting

### Issue: Cannot connect to backend
- **Solution**: Check that backend is running on port 3000
- **Solution**: Verify the IP address in `api_service.dart`
- **Solution**: For physical devices, ensure phone and computer are on same WiFi

### Issue: Secure storage error on Android
- **Solution**: Ensure minimum SDK version is 18 or higher
- **Solution**: Clear app data and reinstall

### Issue: Build errors
- **Solution**: Run `flutter clean` then `flutter pub get`
- **Solution**: Update Flutter: `flutter upgrade`

### Issue: CLEARTEXT communication not permitted
- **Solution**: For development, AndroidManifest.xml already has `usesCleartextTraffic="true"`
- **Solution**: For production, use HTTPS and remove this flag

## Development Tips

### Hot Reload
While the app is running, you can make changes and press `r` in the terminal for hot reload.

### Debug Mode
The app uses `kDebugMode` to print errors only in debug mode:
```dart
if (kDebugMode) {
  print('Error: $e');
}
```

### Release Build
To build a release APK:
```bash
flutter build apk --release
```

## Next Steps

1. Read [SECURITY.md](SECURITY.md) to understand security practices
2. Explore the code in `lib/` directory
3. Try modifying the UI or adding new features
4. Learn about Flutter state management with Provider

## Need Help?

- Flutter Documentation: https://docs.flutter.dev/
- Flutter Secure Storage: https://pub.dev/packages/flutter_secure_storage
- OWASP Mobile Security: https://owasp.org/www-project-mobile-top-10/

---

Happy coding! 🚀
