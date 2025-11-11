# AuthCraft Flutter - Developer Cheat Sheet

## 🚀 Quick Commands

```bash
# Get dependencies
flutter pub get

# Run app
flutter run

# Run on specific device
flutter run -d <device-id>

# Hot reload (while running)
Press 'r' in terminal

# Hot restart (while running)
Press 'R' in terminal

# Clean build
flutter clean && flutter pub get

# Build APK
flutter build apk --release

# Check devices
flutter devices

# Analyze code
flutter analyze
```

## 📁 File Reference

### Core Files
```dart
main.dart                          // App entry, routes, splash
models/user_model.dart             // User & ApiResponse models
services/api_service.dart          // All API calls
services/auth_service.dart         // Auth logic + state
services/secure_storage_service.dart // Keystore wrapper
utils/validators.dart              // Input validation
```

### Screens
```dart
screens/auth/login_screen.dart              // Email login
screens/auth/register_screen.dart           // Registration
screens/auth/login_mobile_screen.dart       // OTP login
screens/auth/forgot_password_screen.dart    // Password reset
screens/home_screen.dart                    // Dashboard
screens/profile/profile_screen.dart         // Edit profile
screens/profile/change_password_screen.dart // Change password
```

## 🔑 Key Code Snippets

### Using Secure Storage
```dart
// Save data
await _storage.saveUserSession(
  userId: '123',
  name: 'John',
  mobileNumber: '1234567890',
  emailAddress: 'john@example.com',
);

// Read data
final userId = await _storage.getUserId();
final name = await _storage.getName();

// Check login status
final isLoggedIn = await _storage.isLoggedIn();

// Clear all (logout)
await _storage.clearSession();
```

### Making API Calls
```dart
// Example: Login
final response = await apiService.login(
  emailAddress: 'user@example.com',
  password: 'password123',
);

if (response.success && response.result != null) {
  // Success
  final user = response.result;
  print('Logged in: ${user.name}');
} else {
  // Error
  print('Error: ${response.message}');
}
```

### Using Auth Service with Provider
```dart
// In build method
final authService = context.watch<AuthService>();

// Or read once (doesn't rebuild on change)
final authService = context.read<AuthService>();

// Access user
final user = authService.currentUser;

// Check loading state
if (authService.isLoading) {
  return CircularProgressIndicator();
}

// Login
final response = await authService.login(
  emailAddress: email,
  password: password,
);
```

### Form Validation
```dart
// Form key
final _formKey = GlobalKey<FormState>();

// TextFormField with validation
TextFormField(
  validator: Validators.validateEmail,
  // or custom
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Required field';
    }
    return null;
  },
)

// Validate all fields
if (_formKey.currentState!.validate()) {
  // All fields valid
  submitForm();
}
```

### Navigation
```dart
// Push new screen
Navigator.pushNamed(context, '/profile');

// Replace current screen
Navigator.pushReplacementNamed(context, '/home');

// Pop back
Navigator.pop(context);

// Pop with data
Navigator.pop(context, someData);
```

### Dialogs
```dart
// Show dialog
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Title'),
    content: Text('Message'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('OK'),
      ),
    ],
  ),
);

// Show confirmation dialog
final confirm = await showDialog<bool>(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Confirm'),
    content: Text('Are you sure?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: Text('Cancel'),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context, true),
        child: Text('Yes'),
      ),
    ],
  ),
);

if (confirm == true) {
  // User confirmed
}
```

## 🔧 Common Tasks

### Add New Screen
1. Create file: `lib/screens/my_screen.dart`
2. Create StatefulWidget or StatelessWidget
3. Add route in `main.dart`:
   ```dart
   routes: {
     '/my-screen': (context) => const MyScreen(),
   }
   ```
4. Navigate: `Navigator.pushNamed(context, '/my-screen')`

### Add New API Endpoint
1. Add method in `ApiService`:
   ```dart
   Future<ApiResponse<User>> myEndpoint() async {
     final response = await _client.post(
       Uri.parse('$baseUrl/my-endpoint'),
       headers: _headers,
       body: jsonEncode({...}),
     ).timeout(const Duration(seconds: 30));
     return _handleResponse<User>(response, (json) => User.fromJson(json));
   }
   ```
2. Add method in `AuthService` to use it
3. Call from UI with Provider

### Add New Validator
```dart
// In validators.dart
static String? validateMyField(String? value) {
  if (value == null || value.isEmpty) {
    return 'Required field';
  }
  // Your validation logic
  return null;
}
```

## 🎨 UI Patterns

### Loading Button
```dart
Consumer<AuthService>(
  builder: (context, authService, _) {
    return ElevatedButton(
      onPressed: authService.isLoading ? null : _handleSubmit,
      child: authService.isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text('Submit'),
    );
  },
)
```

### Password Field with Toggle
```dart
bool _obscurePassword = true;

TextFormField(
  obscureText: _obscurePassword,
  decoration: InputDecoration(
    labelText: 'Password',
    suffixIcon: IconButton(
      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
      onPressed: () {
        setState(() {
          _obscurePassword = !_obscurePassword;
        });
      },
    ),
  ),
)
```

### Async Init in StatefulWidget
```dart
@override
void initState() {
  super.initState();
  _loadData();
}

Future<void> _loadData() async {
  final data = await fetchData();
  if (mounted) {
    setState(() {
      _data = data;
    });
  }
}
```

## 🐛 Debugging Tips

### Print Statements (Debug Only)
```dart
import 'package:flutter/foundation.dart';

if (kDebugMode) {
  print('Debug info: $data');
}
```

### Check Network Issues
```dart
try {
  final response = await apiCall();
  print('Response: $response');
} catch (e) {
  print('Error: $e');
  // Check if it's timeout, network, or server error
}
```

### Check Secure Storage
```dart
// Clear storage for testing
await _storage.clearSession();

// Check what's stored
final userId = await _storage.getUserId();
print('Stored user ID: $userId');
```

### Check if Mounted
```dart
// After async operation
if (!mounted) return;

// Before setState
if (mounted) {
  setState(() {
    _data = newData;
  });
}
```

## 🔒 Security Checklist

Before deploying:

- [ ] Remove debug prints
- [ ] Use HTTPS (not HTTP)
- [ ] Remove `usesCleartextTraffic` from AndroidManifest
- [ ] Update API base URL to production
- [ ] Add certificate pinning (if needed)
- [ ] Enable ProGuard/R8
- [ ] Obfuscate code: `flutter build apk --obfuscate --split-debug-info=/<directory>`
- [ ] Test on physical device
- [ ] Run security audit

## 📱 Device Testing

### Android Emulator IP
```dart
// To access localhost from emulator
static const String baseUrl = 'http://10.0.2.2:3000/api/v1';
```

### Physical Device IP
```dart
// Replace with your computer's IP
static const String baseUrl = 'http://192.168.1.100:3000/api/v1';
```

### Find Your IP
```bash
# Mac/Linux
ifconfig | grep inet

# Windows
ipconfig
```

## ⚡ Performance Tips

1. **Use const constructors** where possible
   ```dart
   const Text('Hello')  // Better than Text('Hello')
   ```

2. **Extract widgets** to avoid unnecessary rebuilds
   ```dart
   class MyWidget extends StatelessWidget {
     const MyWidget({super.key});
     // Widget stays const, won't rebuild
   }
   ```

3. **Use ListView.builder** for long lists
   ```dart
   ListView.builder(
     itemCount: items.length,
     itemBuilder: (context, index) => ItemWidget(items[index]),
   )
   ```

## 🧪 Testing

### Run Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test

# Coverage
flutter test --coverage
```

### Basic Test Structure
```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Email validator works', () {
    final result = Validators.validateEmail('test@example.com');
    expect(result, null);  // null means valid
  });
}
```

## 📦 Build & Release

### Debug APK
```bash
flutter build apk --debug
```

### Release APK
```bash
flutter build apk --release
```

### App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

### Obfuscated Release
```bash
flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols
```

## 🆘 Common Issues

### Issue: Cannot connect to backend
```bash
# Check backend is running
cd user-auth-backend
npm start

# Check IP address in api_service.dart
# For emulator: http://10.0.2.2:3000
# For device: http://YOUR_IP:3000
```

### Issue: Secure storage error
```bash
# Clear app data
# Or uninstall and reinstall
flutter clean
flutter run
```

### Issue: Build fails
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: Hot reload not working
```bash
# Press R for hot restart (capital R)
# Or stop and restart: flutter run
```

## 📚 Quick Reference URLs

- Flutter Docs: https://docs.flutter.dev/
- Pub.dev: https://pub.dev/
- Flutter Secure Storage: https://pub.dev/packages/flutter_secure_storage
- Provider: https://pub.dev/packages/provider
- HTTP: https://pub.dev/packages/http

---

**Pro Tip**: Keep this file open while coding for quick reference! 🚀
