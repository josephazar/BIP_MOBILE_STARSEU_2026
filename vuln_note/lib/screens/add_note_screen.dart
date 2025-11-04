import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../services/auth_service.dart';
import '../database/notes_database.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;

  const AddNoteScreen({super.key, this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final authService = context.read<AuthService>();
      final userId = authService.currentUser?.username ?? '';

      final note = Note(
        id: widget.note?.id,
        title: _titleController.text,
        content: _contentController.text,
        createdAt: widget.note?.createdAt ?? DateTime.now(),
        userId: userId,
      );

      if (widget.note == null) {
        await NotesDatabase.instance.create(note);
      } else {
        await NotesDatabase.instance.update(note);
      }

      setState(() => _isLoading = false);

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'Add Note'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🚨 VULNERABILITY #8: No Input Sanitization
              // OWASP: M4 - Insufficient Input/Output Validation
              // Risk: Accepts any input without validation or sanitization
              // Solution: Implement proper input validation (length, characters, format)
              // Reference: https://docs.talsec.app/appsec-articles/articles/owasp-top-10-for-flutter-m4-insufficient-input-output-validation-in-flutter
              
              const Card(
                color: Colors.orange,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '⚠️ No Input Validation',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'This form accepts any input without validation!',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // VULNERABLE: No maximum length validation
              // No character type validation
              // No sanitization of special characters
              // No XSS protection
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  hintText: 'Enter note title',
                ),
                maxLines: 1,
                validator: (value) {
                  // VULNERABLE: Only checks if not empty
                  // Should also check:
                  // - Maximum length (e.g., 100 characters)
                  // - No special characters that could cause issues
                  // - No SQL injection attempts
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // VULNERABLE: No validation at all for content
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                  hintText: 'Enter note content',
                  helperText: 'Try entering: <script>alert("XSS")</script>',
                  helperStyle: TextStyle(color: Colors.red, fontSize: 10),
                ),
                maxLines: 10,
                validator: (value) {
                  // VULNERABLE: Only checks if not empty
                  // Should also check:
                  // - Maximum length (e.g., 10000 characters)
                  // - Sanitize HTML/script tags
                  // - Validate against malicious patterns
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: _isLoading ? null : _saveNote,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        isEditing ? 'Update Note' : 'Save Note',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
              const SizedBox(height: 16),
              
              const Card(
                color: Colors.red,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🚨 Security Issues',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• No length limits',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Text(
                        '• No character type validation',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Text(
                        '• No sanitization of special characters',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Text(
                        '• Vulnerable to buffer overflow attacks',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
