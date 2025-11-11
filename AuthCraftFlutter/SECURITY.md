# Security Documentation

This document outlines the security practices implemented in AuthCraft Flutter, aligned with OWASP Mobile Top 10 (2024) security principles.

## Table of Contents
1. [Secure Data Storage](#secure-data-storage)
2. [Network Security](#network-security)
3. [Input Validation](#input-validation)
4. [Authentication & Session Management](#authentication--session-management)
5. [Code Quality & Security](#code-quality--security)
6. [Educational Limitations](#educational-limitations)

---

## 1. Secure Data Storage

### Implementation
**Package**: `flutter_secure_storage` v9.0.0

**Android Keystore Integration**:
- User credentials and session tokens are stored using Android Keychain/Keystore
- AES encryption is applied to all stored data
- Data is encrypted at rest and protected by hardware-backed keys (when available)

**What is stored securely**:
- User ID
- User name
- Email address
- Mobile number
- Login session flag

**Code Location**: [lib/services/secure_storage_service.dart](lib/services/secure_storage_service.dart)

```dart
final _storage = const FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
);
```

### OWASP M9: Insecure Data Storage - MITIGATED ✅
- ❌ **NOT USED**: SharedPreferences for sensitive data
- ✅ **USED**: Android Keystore via flutter_secure_storage
- ✅ Encryption at rest
- ✅ Hardware-backed security when available

---

## 2. Network Security

### HTTP Client Configuration
**Package**: `http` v1.1.0

**Security Measures**:
1. **Timeout Configuration**: All API calls have 30-second timeout
2. **HTTPS Ready**: While using HTTP for local development, the code is structured for HTTPS in production
3. **Clear Headers**: JSON content-type explicitly set
4. **No Certificate Pinning**: Not implemented (educational scope)

**Code Location**: [lib/services/api_service.dart](lib/services/api_service.dart)

```dart
final response = await _client
  .post(
    Uri.parse('$baseUrl/endpoint'),
    headers: _headers,
    body: jsonEncode(data),
  )
  .timeout(const Duration(seconds: 30));
```

### OWASP M5: Insecure Communication - PARTIALLY MITIGATED ⚠️
- ✅ Structured for HTTPS (production ready)
- ⚠️ Currently uses HTTP for local development
- ❌ No certificate pinning (educational scope)
- ✅ Proper error handling for network failures

**Production Recommendation**:
- Use HTTPS only
- Implement certificate pinning for critical applications
- Remove `android:usesCleartextTraffic="true"` from AndroidManifest.xml

---

## 3. Input Validation

### Client-Side Validation
**Code Location**: [lib/utils/validators.dart](lib/utils/validators.dart)

**Implemented Validators**:
1. **Email Validation**: Regex pattern matching
2. **Password Validation**: Minimum length enforcement
3. **Mobile Number Validation**: Format and length checks
4. **OTP Validation**: 6-digit numeric validation
5. **Name Validation**: Minimum length checks

```dart
// Example: Email validation
static String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email address is required';
  }
  final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  if (!emailRegex.hasMatch(value)) {
    return 'Invalid email address';
  }
  return null;
}
```

### OWASP M4: Insufficient Input/Output Validation - MITIGATED ✅
- ✅ All user inputs are validated before submission
- ✅ Type-safe data models prevent injection
- ✅ Regex patterns for format validation
- ✅ Server-side validation is also required (backend responsibility)

---

## 4. Authentication & Session Management

### Session Handling
**Code Location**: [lib/services/auth_service.dart](lib/services/auth_service.dart)

**Security Features**:
1. **Secure Session Storage**: Sessions stored in Android Keystore
2. **Auto-logout on Close**: Session cleared when logging out
3. **Session Validation**: Checks session on app startup
4. **No Token in Memory**: User data loaded from secure storage only

```dart
// Logout clears all secure storage
Future<void> logout() async {
  _currentUser = null;
  await _storage.clearSession();
  notifyListeners();
}
```

### OWASP M3: Insecure Authentication - MITIGATED ✅
- ✅ Password not stored locally (only on server)
- ✅ Session tokens in secure storage
- ✅ Proper logout functionality
- ✅ Session validation on app startup
- ⚠️ No biometric authentication (could be added)

---

## 5. Code Quality & Security

### No Hardcoded Secrets
- ✅ No API keys or secrets in code
- ✅ Base URL easily configurable
- ✅ No sensitive data in logs (when not in debug mode)

### Dependency Security
```yaml
dependencies:
  flutter_secure_storage: ^9.0.0  # Latest stable version
  http: ^1.1.0                     # Latest stable version
  provider: ^6.1.1                 # State management
```

### OWASP M10: Insufficient Cryptography - MITIGATED ✅
- ✅ Uses Android Keystore's hardware-backed encryption
- ✅ No custom crypto implementations
- ✅ Relies on platform-provided security
- ✅ AES encryption via flutter_secure_storage

---

## 6. Educational Limitations

This is an **educational project** and has the following limitations for production use:

### ⚠️ Not Production Ready
1. **Backend Security**: Backend uses plaintext passwords (demo only)
2. **No Rate Limiting**: No protection against brute force
3. **No Certificate Pinning**: Network requests not pinned
4. **Basic Error Handling**: Production needs more robust error handling
5. **No Logging/Monitoring**: No security event logging
6. **No Biometric Auth**: Could add fingerprint/face recognition
7. **No Token Refresh**: No automatic token refresh mechanism
8. **HTTP for Development**: Using cleartext HTTP for localhost

### Production Recommendations

To make this production-ready, you should:

1. **Backend**:
   - Hash passwords (bcrypt, argon2)
   - Implement JWT tokens
   - Add rate limiting
   - Use HTTPS only

2. **Mobile App**:
   - Add certificate pinning
   - Implement biometric authentication
   - Add token refresh mechanism
   - Implement security event logging
   - Add obfuscation for release builds
   - Remove debug logging
   - Add ProGuard/R8 rules

3. **Testing**:
   - Penetration testing
   - Code review
   - Dependency vulnerability scanning
   - Static code analysis

---

## OWASP Mobile Top 10 Coverage Summary

| Risk | Status | Implementation |
|------|--------|----------------|
| M1: Improper Platform Usage | ✅ Mitigated | Proper use of Android Keystore |
| M2: Insecure Data Storage | ✅ Mitigated | flutter_secure_storage with Keystore |
| M3: Insecure Communication | ⚠️ Partial | HTTPS ready, no pinning |
| M4: Insecure Authentication | ✅ Mitigated | Secure session management |
| M5: Insufficient Cryptography | ✅ Mitigated | Platform crypto, no custom crypto |
| M6: Insecure Authorization | ⚠️ Basic | User ID-based authorization |
| M7: Client Code Quality | ✅ Good | Type-safe, validated inputs |
| M8: Code Tampering | ❌ Not Implemented | No obfuscation/root detection |
| M9: Reverse Engineering | ❌ Not Implemented | No obfuscation (educational) |
| M10: Extraneous Functionality | ✅ Mitigated | No debug code in production |

---

## Questions?

For security questions or concerns, please review the code in:
- `lib/services/secure_storage_service.dart` - Secure storage
- `lib/services/api_service.dart` - Network security
- `lib/utils/validators.dart` - Input validation
- `lib/services/auth_service.dart` - Authentication logic
