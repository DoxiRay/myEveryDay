import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/todo_storage.dart';
import '../services/quotes.dart';

class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key});

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  Map<String, List<Map<String, dynamic>>> tasksByDate = {};
  String? dailyQuote;

  // Pomodoro timer variables
  Timer? _pomodoroTimer;
  int _remainingSeconds = 25 * 60; // 25 minutes
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    loadTasks();
    dailyQuote = QuotesLibrary.getRandomQuote();
  }

  void loadTasks() async {
    tasksByDate = await TodoStorage.loadTodos();
    setState(() {});
  }

  List<Map<String, dynamic>> getTodayTasks() {
    String today = DateTime.now().toIso8601String().substring(0, 10);
    return tasksByDate[today] ?? [];
  }

  // Pomodoro functions
  void _togglePomodoro() {
    if (_isRunning) {
      _pomodoroTimer?.cancel();
      setState(() => _isRunning = false);
    } else {
      _pomodoroTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _pomodoroTimer?.cancel();
            _isRunning = false;
          }
        });
      });
      setState(() => _isRunning = true);
    }
  }

  void _resetPomodoro() {
    _pomodoroTimer?.cancel();
    setState(() {
      _remainingSeconds = 25 * 60;
      _isRunning = false;
    });
  }

  String get _formattedTime {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FB),
      appBar: AppBar(
        title: Text(
          "Memoa",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Pomodoro Timer
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.timer, color: Colors.redAccent),
                        SizedBox(width: 8),
                        Text(
                          "Pomodoro Timer",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _formattedTime,
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _togglePomodoro,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          child: Text(_isRunning ? "Pause" : "Start"),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _resetPomodoro,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          child: const Text("Reset"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Météo statique
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Antananarivo",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text("Soleil", style: TextStyle(fontSize: 16)),
                        SizedBox(height: 4),
                        Text(
                          "28°C",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.wb_sunny,
                      size: 50,
                      color: Colors.orangeAccent,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Citation du jour
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.format_quote, color: Colors.blueAccent),
                        SizedBox(width: 8),
                        Text(
                          "Citation du jour",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "\"$dailyQuote\"",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tâches du jour
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.deepPurple,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Mes tâches du jour",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children:
                          getTodayTasks().map((task) {
                            return CheckboxListTile(
                              value: task["done"],
                              onChanged: (val) {
                                setState(() {
                                  task["done"] = val!;
                                });
                                TodoStorage.saveTodos(tasksByDate);
                              },
                              title: Text(
                                task["title"],
                                style: GoogleFonts.poppins(
                                  decoration:
                                      task["done"]
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                ),
                              ),
                            );
                          }).toList(),
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

  @override
  void dispose() {
    _pomodoroTimer?.cancel();
    super.dispose();
  }
}
