import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  // Map qui contient les entrées par date
  Map<String, List<String>> entriesByDate = {};
  final TextEditingController _entryController = TextEditingController();
  DateTime? _selectedDate;

  // Créer une Card pour une date ou ajouter une entrée à une date existante
  void _createEntry() async {
    _entryController.clear();
    _selectedDate = DateTime.now();

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text("Nouvelle entrée"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _entryController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Écrire ici...",
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
                  if (_entryController.text.isNotEmpty &&
                      _selectedDate != null) {
                    String key = DateFormat(
                      'yyyy-MM-dd',
                    ).format(_selectedDate!);
                    if (!entriesByDate.containsKey(key))
                      entriesByDate[key] = [];
                    entriesByDate[key]!.add(_entryController.text);
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
                child: const Text("Ajouter"),
              ),
            ],
          ),
    );
  }

  // Modifier une entrée
  void _editEntry(String dateKey, int index) {
    _entryController.text = entriesByDate[dateKey]![index];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text("Modifier entrée"),
            content: TextField(
              controller: _entryController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Écrire ici...",
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
                  if (_entryController.text.isNotEmpty) {
                    setState(() {
                      entriesByDate[dateKey]![index] = _entryController.text;
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
        title: const Text("Mon Journal Intime"),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createEntry,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
      body:
          entriesByDate.isEmpty
              ? const Center(child: Text("Aucune entrée pour l'instant"))
              : ListView(
                padding: const EdgeInsets.all(12),
                children:
                    entriesByDate.entries.map((entry) {
                      String date = entry.key;
                      List<String> entries = entry.value;

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
                            ...entries.asMap().entries.map((entryMap) {
                              int index = entryMap.key;
                              String content = entryMap.value;

                              return ListTile(
                                title: Text(content),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                      ),
                                      onPressed: () => _editEntry(date, index),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          entries.removeAt(index);
                                          if (entries.isEmpty)
                                            entriesByDate.remove(date);
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
                                onPressed: () async {
                                  // Ajouter une nouvelle entrée dans cette Card
                                  _selectedDate = DateFormat(
                                    'yyyy-MM-dd',
                                  ).parse(date);
                                  _createEntry();
                                },
                                icon: const Icon(Icons.add),
                                label: const Text("Ajouter une entrée"),
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
