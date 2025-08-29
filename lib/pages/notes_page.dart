import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  Map<String, List<String>> notesByDate = {};
  final TextEditingController _noteController = TextEditingController();
  DateTime? _selectedDate;

  // Créer une nouvelle Card pour une date
  void _createCard() async {
    _noteController.clear();
    _selectedDate = DateTime.now();

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text("Nouvelle Note"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    labelText: "Première note",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      _selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                          : "Choisir une date",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Colors.deepPurple,
                      ),
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Annuler"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_noteController.text.isNotEmpty &&
                      _selectedDate != null) {
                    String key = DateFormat(
                      'yyyy-MM-dd',
                    ).format(_selectedDate!);
                    if (!notesByDate.containsKey(key)) notesByDate[key] = [];
                    notesByDate[key]!.add(_noteController.text);
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
                child: const Text("Créer"),
              ),
            ],
          ),
    );
  }

  // Ajouter une note à une Card existante
  void _addNote(String dateKey) {
    _noteController.clear();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text("Nouvelle note"),
            content: TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: "Note",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Annuler"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_noteController.text.isNotEmpty) {
                    setState(() {
                      notesByDate[dateKey]!.add(_noteController.text);
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text("Ajouter"),
              ),
            ],
          ),
    );
  }

  // Modifier une note
  void _editNote(String dateKey, int index) {
    _noteController.text = notesByDate[dateKey]![index];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text("Modifier note"),
            content: TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: "Note",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Annuler"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_noteController.text.isNotEmpty) {
                    setState(() {
                      notesByDate[dateKey]![index] = _noteController.text;
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text("Modifier"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Notes"),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createCard,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
      body:
          notesByDate.isEmpty
              ? const Center(child: Text("Aucune note pour l'instant"))
              : ListView(
                padding: const EdgeInsets.all(12),
                children:
                    notesByDate.entries.map((entry) {
                      String date = entry.key;
                      List<String> notes = entry.value;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          title: Text(
                            date,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          children: [
                            ...notes.asMap().entries.map((noteEntry) {
                              int index = noteEntry.key;
                              String note = noteEntry.value;

                              return ListTile(
                                title: Text(note),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                      ),
                                      onPressed: () => _editNote(date, index),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          notes.removeAt(index);
                                          if (notes.isEmpty)
                                            notesByDate.remove(date);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: TextButton.icon(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.deepPurple,
                                ),
                                onPressed: () => _addNote(date),
                                icon: const Icon(Icons.add),
                                label: const Text("Ajouter une note"),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
    );
  }
}
