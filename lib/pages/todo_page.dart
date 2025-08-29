import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  Map<String, List<Map<String, dynamic>>> tasksByDate = {};
  final TextEditingController _taskController = TextEditingController();
  DateTime? _selectedDate;

  void _createCard() async {
    _taskController.clear();
    _selectedDate = DateTime.now();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Nouvelle Card"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                decoration: InputDecoration(
                  labelText: "Première tâche",
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
                if (_taskController.text.isNotEmpty && _selectedDate != null) {
                  String key = DateFormat('yyyy-MM-dd').format(_selectedDate!);
                  if (!tasksByDate.containsKey(key)) tasksByDate[key] = [];
                  tasksByDate[key]!.add({
                    "title": _taskController.text,
                    "done": false,
                  });
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
  }

  void _addTask(String dateKey) {
    _taskController.clear();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text("Nouvelle tâche"),
            content: TextField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: "Tâche",
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
                  if (_taskController.text.isNotEmpty) {
                    setState(() {
                      tasksByDate[dateKey]!.add({
                        "title": _taskController.text,
                        "done": false,
                      });
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

  void _editTask(String dateKey, int index) {
    _taskController.text = tasksByDate[dateKey]![index]["title"];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text("Modifier tâche"),
            content: TextField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: "Tâche",
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
                  if (_taskController.text.isNotEmpty) {
                    setState(() {
                      tasksByDate[dateKey]![index]["title"] =
                          _taskController.text;
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
        title: const Text("ToDo par Date"),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createCard,
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
      body:
          tasksByDate.isEmpty
              ? const Center(child: Text("Aucune Card pour l'instant"))
              : ListView(
                padding: const EdgeInsets.all(12),
                children:
                    tasksByDate.entries.map((entry) {
                      String date = entry.key;
                      List<Map<String, dynamic>> tasks = entry.value;

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
                                  style: TextStyle(
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
                                      onPressed: () => _editTask(date, index),
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
                                onPressed: () => _addTask(date),
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
