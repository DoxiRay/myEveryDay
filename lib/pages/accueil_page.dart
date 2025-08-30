import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key});

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  // ✅ Variables pour l'état des tâches
  bool task1 = false;
  bool task2 = true;

  // ⏱️ Variables Pomodoro
  static const int workDuration = 25 * 60; // 25 minutes
  int remainingSeconds = workDuration;
  Timer? timer;
  bool isRunning = false;

  /// Formater mm:ss
  String get timeFormatted {
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void startTimer() {
    if (timer != null && timer!.isActive) return;

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        t.cancel();
        setState(() {
          isRunning = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⏰ Temps écoulé ! Pause 🎉")),
        );
      }
    });

    setState(() {
      isRunning = true;
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      remainingSeconds = workDuration;
      isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FB), // fond clair et doux
      appBar: AppBar(
        title: Text(
          "Memoa",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🌤️ Météo
            _buildCard(
              title: "Météo",
              icon: Icons.wb_sunny,
              color: Colors.orange,
              child: Text(
                "Antananarivo - 26°C, Ensoleillé",
                style: GoogleFonts.nunito(fontSize: 16),
              ),
            ),

            const SizedBox(height: 20),

            // 💡 Citation du jour
            _buildCard(
              title: "Citation du jour",
              icon: Icons.format_quote,
              color: Colors.blueAccent,
              child: Text(
                "\"Le succès est la somme de petits efforts répétés jour après jour.\"",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 📅 Événements Google Calendar
            _buildCard(
              title: "Événements à venir",
              icon: Icons.event,
              color: Colors.green,
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.work_outline, color: Colors.green),
                    title: Text("Réunion projet Flutter"),
                    subtitle: Text("Aujourd'hui, 14:00"),
                  ),
                  ListTile(
                    leading: Icon(Icons.cake, color: Colors.pink),
                    title: Text("Anniversaire Sarah 🎉"),
                    subtitle: Text("Demain"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Tâches (CLICABLES)
            _buildCard(
              title: "Mes tâches",
              icon: Icons.check_circle_outline,
              color: Colors.deepPurple,
              child: Column(
                children: [
                  CheckboxListTile(
                    value: task1,
                    onChanged: (val) {
                      setState(() {
                        task1 = val ?? false;
                      });
                    },
                    title: const Text("Avancer sur le projet Memoa"),
                  ),
                  CheckboxListTile(
                    value: task2,
                    onChanged: (val) {
                      setState(() {
                        task2 = val ?? false;
                      });
                    },
                    title: const Text("Réviser cours Flutter"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ⏱️ Pomodoro Timer
            _buildCard(
              title: "Pomodoro Timer",
              icon: Icons.timer,
              color: Colors.deepPurple,
              child: Column(
                children: [
                  Text(
                    timeFormatted,
                    style: GoogleFonts.poppins(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: isRunning ? null : startTimer,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text("Démarrer"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: isRunning ? stopTimer : null,
                        icon: const Icon(Icons.pause),
                        label: const Text("Pause"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: resetTimer,
                        icon: const Icon(Icons.refresh),
                        label: const Text("Reset"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Petite fonction utilitaire pour éviter de répéter les Card
  Widget _buildCard({
    required String title,
    required Widget child,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
