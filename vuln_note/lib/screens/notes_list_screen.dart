import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../database/notes_database.dart';
import 'add_note_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  List<Note> _notes = [];
  bool _isLoading = false;
  final _searchController = TextEditingController();
  final _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _apiService.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    
    final authService = context.read<AuthService>();
    final userId = authService.currentUser?.username ?? '';
    
    final notes = await NotesDatabase.instance.readAllNotes(userId);
    
    setState(() {
      _notes = notes;
      _isLoading = false;
    });
  }

  Future<void> _searchNotes(String query) async {
    if (query.isEmpty) {
      _loadNotes();
      return;
    }

    setState(() => _isLoading = true);
    
    final authService = context.read<AuthService>();
    final userId = authService.currentUser?.username ?? '';
    
    // This will use the vulnerable SQL injection method
    final notes = await NotesDatabase.instance.searchNotes(query, userId);
    
    setState(() {
      _notes = notes;
      _isLoading = false;
    });
  }

  Future<void> _deleteNote(Note note) async {
    await NotesDatabase.instance.delete(note.id!);
    _loadNotes();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note deleted')),
      );
    }
  }

  // 🚨 VULNERABILITY #6: Client-Side Authorization Check
  // OWASP: M3 - Insecure Authentication/Authorization
  // Risk: Can be bypassed through code modification or reverse engineering
  // Solution: Always verify permissions on the server-side
  // Reference: https://docs.talsec.app/appsec-articles/articles/owasp-top-10-for-flutter-m3-insecure-authentication-and-authorization-in-flutter
  Future<void> _deleteAllNotes() async {
    final authService = context.read<AuthService>();
    
    // VULNERABLE: Only checking isAdmin flag on client-side
    // An attacker can modify this check or the isAdmin value
    if (!authService.isAdmin) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Admin access required')),
        );
      }
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Notes'),
        content: const Text('Are you sure you want to delete ALL notes? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final userId = authService.currentUser?.username ?? '';
      await NotesDatabase.instance.deleteAllNotes(userId);
      _loadNotes();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All notes deleted')),
        );
      }
    }
  }

  Future<void> _syncNotes() async {
    final authService = context.read<AuthService>();
    final token = authService.currentUser?.token ?? '';
    
    setState(() => _isLoading = true);
    
    final notesData = _notes.map((note) => note.toMap()).toList();
    final result = await _apiService.syncNotes(token, notesData);
    
    setState(() => _isLoading = false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result != null 
              ? 'Notes synced successfully (simulated)' 
              : 'Sync failed - server not available'
          ),
        ),
      );
    }
  }

  Future<void> _logout() async {
    final authService = context.read<AuthService>();
    await authService.logout();
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final isAdmin = authService.isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Notes${isAdmin ? ' (Admin)' : ''}'),
        backgroundColor: isAdmin ? Colors.red : Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Sync notes (HTTP)',
            onPressed: _syncNotes,
          ),
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              tooltip: 'Delete all notes (Admin only)',
              onPressed: _deleteAllNotes,
            ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search notes',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _loadNotes();
                        },
                      )
                    : null,
                helperText: 'Try: \' OR \'1\'=\'1\' -- (SQL injection)',
                helperStyle: const TextStyle(color: Colors.red, fontSize: 10),
              ),
              onChanged: _searchNotes,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _notes.isEmpty
                    ? const Center(
                        child: Text(
                          'No notes yet.\nTap + to add your first note!',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: _notes.length,
                        itemBuilder: (context, index) {
                          final note = _notes[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: ListTile(
                              title: Text(
                                note.title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    note.content,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Created: ${note.createdAt.toString().substring(0, 16)}',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteNote(note),
                              ),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddNoteScreen(note: note),
                                  ),
                                );
                                _loadNotes();
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNoteScreen()),
          );
          _loadNotes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
