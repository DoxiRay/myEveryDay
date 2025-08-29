import 'package:flutter/material.dart';

class AccueilPage extends StatelessWidget {
  const AccueilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Memoa"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🌤️ Météo
            _buildCard(
              title: "Météo",
              child: Column(
                children: const [
                  Icon(Icons.wb_sunny, size: 50, color: Colors.orange),
                  SizedBox(height: 8),
                  Text("Antananarivo - 26°C, Ensoleillé"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 💡 Citation du jour
            _buildCard(
              title: "Citation du jour",
              child: const Text(
                "\"Le succès est la somme de petits efforts répétés jour après jour.\"",
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),

            const SizedBox(height: 16),

            // 📅 Événements Google Calendar
            _buildCard(
              title: "Événements à venir",
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.event),
                    title: Text("Réunion projet Flutter"),
                    subtitle: Text("Aujourd'hui, 14:00"),
                  ),
                  ListTile(
                    leading: Icon(Icons.event),
                    title: Text("Anniversaire Sarah 🎉"),
                    subtitle: Text("Demain"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ✅ Tâches
            _buildCard(
              title: "Mes tâches",
              child: Column(
                children: [
                  CheckboxListTile(
                    value: false,
                    onChanged: (val) {},
                    title: const Text("Avancer sur le projet Memoa"),
                  ),
                  CheckboxListTile(
                    value: true,
                    onChanged: (val) {},
                    title: const Text("Réviser cours Flutter"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ⏱️ Pomodoro Timer
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Naviguer vers une page Pomodoro
              },
              icon: const Icon(Icons.timer),
              label: const Text("Lancer un Pomodoro"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Petite fonction utilitaire pour éviter de répéter les Card
  static Widget _buildCard({required String title, required Widget child}) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
