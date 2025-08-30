import 'package:shared_preferences/shared_preferences.dart';

class PomodoroStorage {
  static const String _key = "pomodoro_hours";

  static Future<void> addHours(double hours) async {
    final prefs = await SharedPreferences.getInstance();
    double current = prefs.getDouble(_key) ?? 0.0;
    await prefs.setDouble(_key, current + hours);
  }

  static Future<double> getTotalHours() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_key) ?? 0.0;
  }

  static Future<void> resetHours() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_key, 0.0);
  }
}
