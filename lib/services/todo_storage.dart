import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TodoStorage {
  // Sauvegarder toutes les tâches
  static Future<void> saveTodos(
    Map<String, List<Map<String, dynamic>>> todosByDate,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('todos', jsonEncode(todosByDate));
  }

  // Charger toutes les tâches
  static Future<Map<String, List<Map<String, dynamic>>>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    String? todosString = prefs.getString('todos');
    if (todosString != null) {
      Map<String, dynamic> decoded = jsonDecode(todosString);
      return decoded.map((key, value) {
        List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(
          value,
        );
        return MapEntry(key, list);
      });
    }
    return {};
  }
}
