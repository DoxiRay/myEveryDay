import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  Map<String, List<Map<String, dynamic>>> tasksByDate = {};
  DateTime? _selectedDate;

  void _createCard() async {
    List<TextEditingController> taskControllers = [TextEditingController()];
    _selectedDate = DateTime.now();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.purple[50],

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                "Nouvelle tâche",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.deepPurple[700],
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...taskControllers.asMap().entries.map((entry) {
                      int index = entry.key;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TextField(
                          controller: entry.value,
                          decoration: InputDecoration(
                            labelText: "Tâche ${index + 1}",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon:
                                index > 0
                                    ? IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        setStateDialog(() {
                                          taskControllers.removeAt(index);
                                        });
                                      },
                                    )
                                    : null,
                          ),
                        ),
                      );
                    }).toList(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () {
                          setStateDialog(() {
                            taskControllers.add(TextEditingController());
                          });
                        },
                        icon: const Icon(Icons.add, color: Colors.deepPurple),
                        label: const Text(
                          "Ajouter une tâche",
                          style: TextStyle(color: Colors.deepPurple),
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
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple[700],
                          ),
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
                              setStateDialog(() {
                                _selectedDate = picked;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
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
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_selectedDate != null) {
                      String key = DateFormat(
                        'yyyy-MM-dd',
                      ).format(_selectedDate!);
                      if (!tasksByDate.containsKey(key)) tasksByDate[key] = [];

                      for (var controller in taskControllers) {
                        if (controller.text.isNotEmpty) {
                          tasksByDate[key]!.add({
                            "title": controller.text,
                            "done": false,
                          });
                        }
                      }
                      setState(() {});
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Créer"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text(
          "ToDo ",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createCard,
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body:
          tasksByDate.isEmpty
              ? Center(
                child: Text(
                  "Aucune tâche pour l'instant",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.deepPurple[300],
                  ),
                ),
              )
              : ListView(
                padding: const EdgeInsets.all(12),
                children:
                    tasksByDate.entries.map((entry) {
                      String date = entry.key;
                      List<Map<String, dynamic>> tasks = entry.value;

                      return Card(
                        color: Colors.white,
                        shadowColor: Colors.deepPurple[100],
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
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple[700],
                            ),
                          ),
                          children: [
                            ...tasks.asMap().entries.map((taskEntry) {
                              int index = taskEntry.key;
                              Map<String, dynamic> task = taskEntry.value;

                              return ListTile(
                                leading: Checkbox(
                                  activeColor: Colors.deepPurple,
                                  value: task["done"],
                                  onChanged: (val) {
                                    setState(() {
                                      task["done"] = val!;
                                    });
                                  },
                                ),
                                title: Text(
                                  task["title"],
                                  style: GoogleFonts.poppins(
                                    decoration:
                                        task["done"]
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                      ),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {},
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
                                onPressed: () {},
                                icon: const Icon(Icons.add),
                                label: const Text("Ajouter une tâche"),
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
