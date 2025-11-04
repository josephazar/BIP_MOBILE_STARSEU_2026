import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../config/api_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _savedPassword = '';
  String _authToken = '';

  @override
  void initState() {
    super.initState();
    _loadDebugInfo();
  }

  Future<void> _loadDebugInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedPassword = prefs.getString('saved_password') ?? 'Not saved';
      _authToken = prefs.getString('auth_token') ?? 'No token';
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'User Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  _buildInfoRow('Username', user?.username ?? 'Unknown'),
                  _buildInfoRow('Admin Status', user?.isAdmin == true ? 'Yes' : 'No'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Debug Information Section - Should never be in production!
          Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bug_report, color: Colors.red),
                      const SizedBox(width: 8),
                      const Text(
                        'Debug Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const Text(
                    '⚠️ This section exposes sensitive data!',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('API Key', ApiConfig.apiKey),
                  _buildInfoRow('Base URL', ApiConfig.baseUrl),
                  _buildInfoRow('Auth Token', _authToken),
                  _buildInfoRow('Saved Password', _savedPassword),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // 🚨 VULNERABILITY #11: Excessive Permissions
          // OWASP: M6 - Inadequate Privacy Controls
          // Risk: App requests unnecessary permissions
          // Solution: Only request permissions that are actually needed
          // Reference: https://owasp.org/www-project-mobile-top-10/2023-risks/
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.privacy_tip, color: Colors.orange),
                      const SizedBox(width: 8),
                      const Text(
                        'Privacy & Permissions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const Text(
                    '⚠️ This app requests excessive permissions:',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPermissionRow('📷 Camera', 'Not needed for note-taking'),
                  _buildPermissionRow('📍 Location', 'Not needed for note-taking'),
                  _buildPermissionRow('📞 Contacts', 'Not needed for note-taking'),
                  const SizedBox(height: 12),
                  const Text(
                    'These permissions are requested in AndroidManifest.xml but serve no purpose for this app.',
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Security Vulnerabilities in This App',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  const Text(
                    'This app intentionally contains 15 security vulnerabilities:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildVulnRow('M1', 'Hardcoded API keys'),
                  _buildVulnRow('M1', 'Insecure token storage'),
                  _buildVulnRow('M1', 'Debug logging'),
                  _buildVulnRow('M3', 'Weak passwords'),
                  _buildVulnRow('M3', 'Hardcoded admin credentials'),
                  _buildVulnRow('M3', 'Client-side authorization'),
                  _buildVulnRow('M4', 'SQL injection'),
                  _buildVulnRow('M4', 'No input validation'),
                  _buildVulnRow('M5', 'HTTP endpoints'),
                  _buildVulnRow('M5', 'No certificate pinning'),
                  _buildVulnRow('M6', 'Excessive permissions'),
                  _buildVulnRow('M8', 'Debug mode enabled'),
                  _buildVulnRow('M9', 'Plain text passwords'),
                  _buildVulnRow('M9', 'Unencrypted database'),
                  _buildVulnRow('M10', 'MD5 hashing'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionRow(String permission, String reason) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(permission),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              reason,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVulnRow(String owaspId, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              owaspId,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(description, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
