import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Exemple de données : nombre de tâches terminées et total
  final int totalTasks = 50;
  final int completedTasks = 37;
  final double pomodoroHours = 12.5;

  @override
  Widget build(BuildContext context) {
    // Calcul du pourcentage de tâches terminées
    double completionRate =
        totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("assets/avatar.png"),
          ),
          const SizedBox(height: 20),
          const Text(
            "Nom de l'utilisateur",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text("email@exemple.com"),
          const SizedBox(height: 30),

          const Text(
            "Statistiques",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Tâches terminées : ${completedTasks} / $totalTasks",
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
                    "Heures passées sur Pomodoro : $pomodoroHours h",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
