import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/todo_storage.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  Map<String, List<Map<String, dynamic>>> tasksByDate = {};
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    loadSavedTodos();
  }

  void loadSavedTodos() async {
    tasksByDate = await TodoStorage.loadTodos();
    setState(() {});
  }

  void _saveTodos() {
    TodoStorage.saveTodos(tasksByDate);
  }

  void _createOrEditTask({String? dateKey, int? taskIndex}) async {
    TextEditingController controller = TextEditingController();
    _selectedDate = dateKey != null ? DateTime.parse(dateKey) : DateTime.now();

    if (dateKey != null && taskIndex != null) {
      controller.text = tasksByDate[dateKey]![taskIndex]["title"];
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.purple[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            taskIndex != null ? "Modifier tâche" : "Nouvelle tâche",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.deepPurple[700],
            ),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Titre de la tâche",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
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
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (_selectedDate != null && controller.text.isNotEmpty) {
                  String key = DateFormat('yyyy-MM-dd').format(_selectedDate!);
                  if (!tasksByDate.containsKey(key)) tasksByDate[key] = [];

                  if (taskIndex != null) {
                    tasksByDate[key]![taskIndex]["title"] = controller.text;
                  } else {
                    tasksByDate[key]!.add({
                      "title": controller.text,
                      "done": false,
                    });
                  }
                  setState(() {});
                  _saveTodos();
                  Navigator.pop(context);
                }
              },
              child: Text(taskIndex != null ? "Modifier" : "Créer"),
            ),
          ],
        );
      },
    );
  }

  void _createCard() => _createOrEditTask();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text(
          "ToDo",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
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
                          children:
                              tasks.asMap().entries.map((taskEntry) {
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
                                      _saveTodos();
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
                                          color: Colors.blueAccent,
                                        ),
                                        onPressed:
                                            () => _createOrEditTask(
                                              dateKey: date,
                                              taskIndex: index,
                                            ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            tasks.removeAt(index);
                                            if (tasks.isEmpty)
                                              tasksByDate.remove(date);
                                          });
                                          _saveTodos();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                        ),
                      );
                    }).toList(),
              ),
    );
  }
}
