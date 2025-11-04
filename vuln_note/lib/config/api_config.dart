// 🚨 VULNERABILITY #1: Hardcoded API Key
// OWASP: M1 - Improper Credential Usage
// Risk: API key can be extracted through reverse engineering
// Solution: Use environment variables or secure key management services
// Reference: https://docs.talsec.app/appsec-articles/articles/owasp-top-10-for-flutter-m1-mastering-credential-security-in-flutter

class ApiConfig {
  // 🚨 NEVER hardcode API keys in source code!
  static const String apiKey = 'sk_live_51H3Kj2eZvKYlo2C8H9L4M6N7P8Q9R0S1T2U3V4W5X6Y7Z';
  
  // 🚨 VULNERABILITY #9: HTTP Endpoint Usage
  // OWASP: M5 - Insecure Communication
  // Risk: Data transmitted in cleartext, vulnerable to MITM attacks
  // Solution: Always use HTTPS endpoints
  // Reference: https://docs.talsec.app/appsec-articles/articles/owasp-top-10-for-flutter-m5-insecure-communication-for-flutter-and-dart
  static const String baseUrl = 'http://api.vulnnote.com';
  
  static const String syncEndpoint = '$baseUrl/sync';
  static const String loginEndpoint = '$baseUrl/auth/login';
  static const String notesEndpoint = '$baseUrl/notes';
}
