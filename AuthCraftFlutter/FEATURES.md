# AuthCraft Flutter - Features Overview

## 📱 Complete Authentication System

### 1. User Registration
**Screen**: `register_screen.dart`

**Features**:
- Full name input
- Mobile number validation
- Email address validation
- Password with visibility toggle
- Password confirmation
- Client-side validation
- Success/Error dialog handling

**Security**:
- ✅ Email format validation with regex
- ✅ Password length enforcement (minimum 3 characters)
- ✅ Password match verification
- ✅ Mobile number format validation

---

### 2. Email/Password Login
**Screen**: `login_screen.dart`

**Features**:
- Email address input
- Password input with visibility toggle
- Loading state indicator
- Navigation to forgot password
- Navigation to mobile login
- Navigation to registration
- Secure session creation

**Security**:
- ✅ Credentials stored in Android Keystore
- ✅ No credentials cached in memory
- ✅ Automatic session validation on app start

---

### 3. Mobile OTP Login
**Screen**: `login_mobile_screen.dart`

**Features**:
- Two-step verification process:
  1. Enter mobile number → Receive OTP
  2. Enter 6-digit OTP → Verify and login
- Change mobile number option
- OTP resend capability
- Loading states for both steps

**Backend Integration**:
- Sends OTP via SMS (backend implementation)
- OTP verification with mobile number
- Secure session creation after verification

---

### 4. Forgot Password
**Screen**: `forgot_password_screen.dart`

**Features**:
- Three-step password reset:
  1. Enter email address
  2. Receive and enter 6-digit verification code
  3. Create new password
- Step indicator UI
- Email verification
- Password strength validation

**Security**:
- ✅ Email-based verification
- ✅ Time-limited verification codes (backend)
- ✅ Password confirmation required

---

### 5. User Profile
**Screen**: `profile_screen.dart`

**Features**:
- View current profile information
- Edit name, mobile, email
- Real-time validation
- Update profile data
- Sync with secure storage

**Data Stored Securely**:
- User ID
- Name
- Mobile Number
- Email Address

---

### 6. Change Password
**Screen**: `change_password_screen.dart`

**Features**:
- Old password verification
- New password input
- Password confirmation
- Password visibility toggles
- Success notification

**Security**:
- ✅ Old password validation required
- ✅ Password match verification
- ✅ No password stored locally

---

### 7. Home Dashboard
**Screen**: `home_screen.dart`

**Features**:
- Welcome message with user name
- Navigation to profile
- Navigation to change password
- Logout functionality with confirmation
- Clean, card-based UI

---

## 🔒 Security Features

### Secure Storage (Android Keystore)
**Implementation**: `secure_storage_service.dart`

```dart
// Encrypted storage using Android Keystore
final _storage = const FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
);
```

**What's Secured**:
- ✅ User session tokens
- ✅ User ID
- ✅ User personal information
- ✅ Login state

**How It Works**:
1. Data is encrypted with AES
2. Encryption keys stored in Android Keystore
3. Keys are hardware-backed when available
4. Data protected even if device is rooted

---

### API Security
**Implementation**: `api_service.dart`

**Features**:
- ✅ Timeout configuration (30 seconds)
- ✅ Proper error handling
- ✅ Type-safe requests/responses
- ✅ JSON encoding for all requests
- ✅ HTTPS-ready architecture

**Error Handling**:
```dart
try {
  final response = await _client.post(...)
    .timeout(const Duration(seconds: 30));
  return _handleResponse(response);
} catch (e) {
  return ApiResponse(success: false, message: 'Network error: $e');
}
```

---

### Input Validation
**Implementation**: `validators.dart`

**Validators**:
1. **Email**: Regex pattern matching
2. **Password**: Minimum length, required field
3. **Mobile**: Format and length validation
4. **OTP**: 6-digit numeric validation
5. **Name**: Minimum 2 characters

**Usage**:
```dart
TextFormField(
  validator: Validators.validateEmail,
  // Automatically validates on form submission
)
```

---

### Session Management
**Implementation**: `auth_service.dart`

**Features**:
- ✅ Automatic session restoration on app start
- ✅ Centralized authentication state
- ✅ Reactive UI updates via Provider
- ✅ Secure logout (clears all stored data)
- ✅ Loading states for all operations

**State Management**:
```dart
class AuthService extends ChangeNotifier {
  User? _currentUser;

  Future<void> login(...) async {
    // Login logic
    _currentUser = user;
    notifyListeners(); // Updates all listening widgets
  }
}
```

---

## 🎨 UI/UX Features

### Material Design 3
- Modern, clean interface
- Consistent color scheme
- Proper spacing and padding
- Accessibility-friendly

### Loading States
- Loading indicators on all API calls
- Disabled buttons during loading
- Visual feedback for user actions

### Error Handling
- Dialog boxes for errors
- Success confirmations
- User-friendly error messages
- Network error handling

### Navigation
- Named routes for easy navigation
- Back button handling
- Automatic navigation on success
- Route guards for authentication

### Form Features
- Auto-focus management
- Keyboard action buttons (Next, Done)
- Password visibility toggles
- Real-time validation
- Error messages on fields

---

## 📦 Dependencies

```yaml
dependencies:
  # Core
  flutter:
    sdk: flutter

  # Network
  http: ^1.1.0                      # HTTP client for API calls

  # Security
  flutter_secure_storage: ^9.0.0   # Android Keystore integration

  # State Management
  provider: ^6.1.1                  # Reactive state management

  # UI
  cupertino_icons: ^1.0.6          # Icons
```

---

## 🔄 API Endpoints Used

All endpoints connect to `user-auth-backend`:

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/register` | POST | User registration |
| `/login` | POST | Email/password login |
| `/login_with_mobile` | POST | Send OTP to mobile |
| `/check_otp` | POST | Verify OTP code |
| `/send_password_reset_code` | POST | Send reset code to email |
| `/check_verification_code` | POST | Verify reset code |
| `/reset_password` | POST | Reset user password |
| `/user_details/:id` | GET | Get user information |
| `/user_update/:id` | PUT | Update user profile |
| `/change_password/:id` | PUT | Change user password |

---

## 🎯 OWASP Security Coverage

### M1: Improper Platform Usage ✅
- Proper use of Android Keystore
- Following platform security guidelines

### M2: Insecure Data Storage ✅
- Using flutter_secure_storage
- No sensitive data in SharedPreferences
- Encrypted storage for all credentials

### M3: Insecure Communication ⚠️
- HTTPS-ready (using HTTP for dev)
- Timeout handling
- No certificate pinning (educational scope)

### M4: Insecure Authentication ✅
- Secure session management
- Proper logout functionality
- Session validation on startup

### M5: Insufficient Cryptography ✅
- Platform-provided encryption
- No custom crypto implementations
- Android Keystore for key management

### M6: Insecure Authorization ⚠️
- User ID-based authorization
- Basic server-side validation

### M7: Client Code Quality ✅
- Type-safe Dart code
- Input validation
- Error handling
- No hardcoded secrets

### M8: Code Tampering ❌
- No obfuscation (educational)
- No root detection

### M9: Reverse Engineering ❌
- No obfuscation (educational)
- Source code available for learning

### M10: Extraneous Functionality ✅
- No debug backdoors
- Clean production code
- Minimal permissions

---

## 🚀 Performance

### Optimizations
- **State Management**: Provider pattern for efficient UI updates
- **Network**: Request timeout to prevent hanging
- **Forms**: Validation only on submission (not on every keystroke)
- **Navigation**: Efficient route management

### App Size
- Base APK: ~15-20 MB (includes Flutter engine)
- First-time install: ~20 MB
- Subsequent updates: ~5-10 MB

---

## 📚 Learning Objectives

This project demonstrates:

1. **Flutter Basics**:
   - StatefulWidget vs StatelessWidget
   - Form handling and validation
   - Navigation and routing
   - Async/await patterns

2. **Architecture**:
   - Service layer pattern
   - Repository pattern for API
   - State management with Provider
   - Separation of concerns

3. **Security**:
   - Secure storage best practices
   - Input validation
   - Session management
   - OWASP guidelines

4. **Real-World Skills**:
   - API integration
   - Error handling
   - User feedback (dialogs, loading states)
   - Professional code organization

---

## 🎓 Educational Value

**What You'll Learn**:
- How to build a complete authentication system
- Secure data storage on mobile devices
- RESTful API integration
- State management in Flutter
- Form validation and user input handling
- Navigation and routing
- OWASP mobile security principles

**Comparison to Android**:
- See [COMPARISON.md](COMPARISON.md) for detailed Android vs Flutter comparison
- Understand why Flutter's approach to secure storage is superior
- Learn cross-platform development benefits

---

## 🛠️ Customization Ideas

Want to extend this project? Try:

1. **Biometric Authentication**: Add fingerprint/face login
2. **Dark Mode**: Implement theme switching
3. **Profile Picture**: Add image upload functionality
4. **Email Verification**: Add email verification on registration
5. **Remember Me**: Add persistent login option
6. **Social Login**: Google, Facebook, Apple sign-in
7. **2FA**: Two-factor authentication
8. **Push Notifications**: Password change alerts
9. **Localization**: Multi-language support
10. **Offline Mode**: Cache data for offline access

---

## 📄 Documentation

- [README.md](README.md) - Project overview
- [SETUP.md](SETUP.md) - Installation and setup guide
- [SECURITY.md](SECURITY.md) - Detailed security documentation
- [COMPARISON.md](COMPARISON.md) - Android vs Flutter comparison
- [FEATURES.md](FEATURES.md) - This file

---

## 🤝 Contributing

This is an educational project. Feel free to:
- Fork and experiment
- Add new features
- Improve security
- Enhance UI/UX
- Add tests

---

Built with ❤️ for learning mobile security and Flutter development
