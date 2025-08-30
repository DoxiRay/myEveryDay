import 'package:flutter/material.dart';
import '../services/todo_storage.dart';
import '../services/pomodoro_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int totalTasks = 0;
  int completedTasks = 0;
  double pomodoroHours = 0.0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    // Charger les tâches
    final tasksByDate = await TodoStorage.loadTodos();
    int total = 0;
    int done = 0;
    tasksByDate.forEach((key, tasks) {
      total += tasks.length;
      done += tasks.where((task) => task["done"] == true).length;
    });

    // Charger les heures Pomodoro
    double hours = await PomodoroStorage.getTotalHours(); // si service existant

    setState(() {
      totalTasks = total;
      completedTasks = done;
      pomodoroHours = hours;
    });
  }

  @override
  Widget build(BuildContext context) {
    double completionRate =
        totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Statistiques",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "Tâches terminées : $completedTasks / $totalTasks",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: completionRate / 100,
                      minHeight: 10,
                      backgroundColor: Colors.grey[300],
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Achèvement : ${completionRate.toStringAsFixed(1)} %",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Heures passées sur Pomodoro : $pomodoroHours",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
