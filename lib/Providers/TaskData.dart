//Providers
import 'package:flutter/material.dart';

import '../task.dart';

class TaskData extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;
  List<String> _recipients = [];
  List<String> get recipients => _recipients;

  void addTask(
      String taskNumber, String description, String status, String date) {
    _tasks.add(Task(
      taskNumber: taskNumber,
      description: description,
      status: status,
      date: date,
    ));
    print(_tasks.length);

    notifyListeners();
  }

  void addRecipient(String email) {
    _recipients.add(email);
    print(_tasks.length);
    notifyListeners();
  }

  void clearTasks() {
    _tasks.clear();
    notifyListeners();
  }
}
