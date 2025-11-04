import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

class ApiService {
  // 🚨 VULNERABILITY #10: No Certificate Pinning
  // OWASP: M5 - Insecure Communication
  // Risk: Vulnerable to Man-in-the-Middle (MITM) attacks
  // Solution: Implement certificate pinning for critical API endpoints
  // Reference: https://docs.talsec.app/appsec-articles/articles/owasp-top-10-for-flutter-m5-insecure-communication-for-flutter-and-dart
  
  // Standard HTTP client without any certificate validation or pinning
  final http.Client _client = http.Client();

  Future<Map<String, dynamic>?> syncNotes(String token, List<Map<String, dynamic>> notes) async {
    try {
      // 🚨 Using HTTP endpoint from ApiConfig (Vulnerability #9)
      print('📡 Syncing notes to: ${ApiConfig.syncEndpoint}');
      print('🔑 Using API key: ${ApiConfig.apiKey}');
      
      final response = await _client.post(
        Uri.parse(ApiConfig.syncEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'X-API-Key': ApiConfig.apiKey, // Sending hardcoded API key
        },
        body: jsonEncode({
          'notes': notes,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      print('❌ Sync error: $e');
    }
    return null;
  }

  Future<bool> validateToken(String token) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/auth/validate'),
        headers: {
          'Authorization': 'Bearer $token',
          'X-API-Key': ApiConfig.apiKey,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Token validation error: $e');
      return false;
    }
  }

  void dispose() {
    _client.close();
  }
}
