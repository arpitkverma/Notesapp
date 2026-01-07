import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../providers/authentication_provider.dart';
import '../providers/notes_provider.dart';
import 'edit_note_screen.dart';

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notesProvider = context.watch<NotesProvider>();
    final notes = notesProvider.notes;
    final auth = context.read<AuthenticationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notesapp',
          style: TextStyle(color: Colors.deepPurple),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Search by title',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => notesProvider.searchQuery = value,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: notes.isEmpty
                    ? const Center(child: Text('No notes yet'))
                    : ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (_, i) {
                          final note = notes[i];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 5,
                            shadowColor: Color(note.color),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              tileColor: Color(note.color).withOpacity(0.3),
                              title: Text(note.title),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    note.content,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Created: ${note.formattedCreated} • Updated: ${note.formattedUpdated}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => EditNoteScreen(note: note),
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Color(note.color),
                                ),
                                onPressed: () =>
                                    _showDeleteDialog(context, note),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const EditNoteScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final auth = context.read<AuthenticationProvider>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Cancel
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Confirm
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await auth.logout();
      if (!context.mounted) return;
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  Future<void> _showDeleteDialog(BuildContext context, Note note) async {
    final notesProvider = context.read<NotesProvider>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: Text('"${note.title}" will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Cancel
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Confirm
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await notesProvider.deleteNote(note.id);
    }
  }

}
