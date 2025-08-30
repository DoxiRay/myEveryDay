import 'package:intl/intl.dart';

class TaskService {
  // Map<Date, Liste de tâches>
  static Map<String, List<Map<String, dynamic>>> tasksByDate = {};

  static void addTask(DateTime date, String title) {
    String key = DateFormat('yyyy-MM-dd').format(date);
    if (!tasksByDate.containsKey(key)) {
      tasksByDate[key] = [];
    }
    tasksByDate[key]!.add({"title": title, "done": false});
  }

  static List<Map<String, dynamic>> getTasksForToday() {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return tasksByDate[today] ?? [];
  }
}
