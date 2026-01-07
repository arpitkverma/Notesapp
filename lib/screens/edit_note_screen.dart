import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';

class EditNoteScreen extends StatefulWidget {
  final Note? note;
  const EditNoteScreen({super.key, this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _contentCtrl;
  late int _selectedColor;


  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.note?.title ?? '');
    _contentCtrl = TextEditingController(text: widget.note?.content ?? '');
    _selectedColor = widget.note?.color ?? kNoteColors[0].value;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final notes = context.read<NotesProvider>();
    final title = _titleCtrl.text.trim();
    final content = _contentCtrl.text.trim();
    if (title.isEmpty && content.isEmpty) return;

    if (widget.note == null) {
      await notes.addNote(title, content,_selectedColor);
    } else {
      await notes.updateNote(
        Note(
          id: widget.note!.id,
          title: title,
          content: content,
          createdAt: widget.note!.createdAt,
          updatedAt: DateTime.now(),
          userId: widget.note!.userId,
          color: _selectedColor,
        ),
      );
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.note != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Note' : 'New Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _save,
          )
        ],
      ),
      body: Material(
        color: Color(_selectedColor).withValues(alpha: 0.3),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Color: ', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: kNoteColors.map((color) {
                            final isSelected = color.value == _selectedColor;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedColor = color.value),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check, size: 20, color: Colors.white)
                                    : null,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16,),
                TextField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const Divider(),
                Expanded(
                  child: TextField(
                    controller: _contentCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Note...',
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// Predefined colors (ARGB ints)
const List<Color> kNoteColors = [
  Color(0xFF2196F3), // Blue
  Color(0xFF4CAF50), // Green
  Color(0xFFFF9800), // Orange
  Color(0xFFE91E63), // Pink
  Color(0xFF9C27B0), // Purple
  Color(0xFF607D8B), // Blue Grey
  Color(0xFFFFEB3B), // Yellow
  Color(0xFF795548), // Brown
];

