# VulnNote - Intentionally Vulnerable Flutter App

⚠️ **WARNING: This app is intentionally insecure for educational purposes only!**

## Overview

VulnNote is a simple note-taking Flutter application that intentionally contains **15 security vulnerabilities** based on the **OWASP Mobile Top 10 (2024)**. This app is designed for educational purposes to help developers learn about mobile application security vulnerabilities and how to fix them.

## Purpose

This app demonstrates common security mistakes in Flutter applications, including:
- Improper credential usage
- Insecure authentication and authorization
- Insufficient input/output validation
- Insecure communication
- Inadequate privacy controls
- Security misconfiguration
- Insecure data storage
- Insufficient cryptography

## Features

- 📝 Simple note-taking functionality
- 🔐 User authentication (intentionally weak)
- 👑 Admin access (hardcoded credentials)
- 🔍 Note search (vulnerable to SQL injection)
- 🔄 Cloud sync (over HTTP)
- ⚙️ Settings with debug information

## Intentional Vulnerabilities (15 Total)

### M1: Improper Credential Usage (3 vulnerabilities)

1. **Hardcoded API Key** - API key embedded in source code
2. **Insecure Token Storage** - JWT token stored in plain SharedPreferences
3. **Debug Logging** - Sensitive data logged to console

### M3: Insecure Authentication/Authorization (3 vulnerabilities)

4. **Weak Password Validation** - Accepts any password (even "1")
5. **Hardcoded Admin Credentials** - admin/admin123
6. **Client-Side Authorization** - Admin check only on client

### M4: Insufficient Input/Output Validation (2 vulnerabilities)

7. **SQL Injection** - Search query vulnerable to SQL injection
8. **No Input Sanitization** - No validation on note content

### M5: Insecure Communication (2 vulnerabilities)

9. **HTTP Endpoints** - API calls over HTTP instead of HTTPS
10. **No Certificate Pinning** - No SSL/TLS certificate validation

### M6: Inadequate Privacy Controls (1 vulnerability)

11. **Excessive Permissions** - Requests camera, location, contacts unnecessarily

### M8: Security Misconfiguration (1 vulnerability)

12. **Debug Mode in Production** - android:debuggable="true"

### M9: Insecure Data Storage (2 vulnerabilities)

13. **Plain Text Password Storage** - "Remember Me" stores password in plain text
14. **Unencrypted Database** - SQLite database not encrypted

### M10: Insufficient Cryptography (1 vulnerability)

15. **Weak Password Hashing** - Uses MD5 instead of bcrypt/Argon2

## Demo Credentials

- **Regular User**: Any username and password
- **Admin User**: `admin` / `admin123`

## SQL Injection Demo

Try searching for: `' OR '1'='1' --`

This will bypass the search filter and return all notes.

## Project Structure

```
vuln_note/
├── lib/
│   ├── main.dart
│   ├── config/
│   │   └── api_config.dart          # V1: Hardcoded API key
│   ├── models/
│   │   ├── note.dart
│   │   └── user.dart
│   ├── screens/
│   │   ├── login_screen.dart        # V4: Weak password validation
│   │   ├── notes_list_screen.dart   # V6: Client-side authorization
│   │   ├── add_note_screen.dart     # V8: No input validation
│   │   └── settings_screen.dart     # V11: Privacy issues
│   ├── services/
│   │   ├── auth_service.dart        # V2, V3, V5, V13, V15
│   │   └── api_service.dart         # V9, V10
│   └── database/
│       └── notes_database.dart      # V7, V14
├── android/
│   └── app/src/main/
│       └── AndroidManifest.xml      # V11, V12
└── pubspec.yaml
```

## Dependencies

- `shared_preferences` - For insecure storage demonstration
- `sqflite` - For unencrypted database demonstration
- `http` - For HTTP communication demonstration
- `crypto` - For weak MD5 hashing demonstration
- `provider` - State management

## Educational Use Only

⚠️ **DO NOT use this code in production applications!**

This app is designed solely for educational purposes to demonstrate security vulnerabilities. Every vulnerability is clearly marked with comments explaining:
- What the vulnerability is
- Which OWASP category it belongs to
- What the risk is
- How to fix it
- Reference links for more information

## Learning Resources

- [OWASP Mobile Top 10 2024](https://owasp.org/www-project-mobile-top-10/2023-risks/)
- [Talsec OWASP Top 10 for Flutter Series](https://docs.talsec.app/appsec-articles/articles/)
- [Flutter Security Best Practices](https://flutter.dev/docs/deployment/security)

## License

This project is provided for educational purposes only. Use at your own risk.

## Disclaimer

This application intentionally contains security vulnerabilities and should never be used in a production environment or with real user data. The creators are not responsible for any misuse of this code.
