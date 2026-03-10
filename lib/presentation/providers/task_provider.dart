import 'package:flutter/material.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _repository = TaskRepository();
  List<TaskModel> _tasks = [];
  bool _isLoading = false;

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> loadTasks(String? token) async {
    _isLoading = true;
    notifyListeners();
    try {
      _tasks = await _repository.fetchTasks(token);
    } catch (e) {
      debugPrint('Error loading tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(
      String title, String name, String time, String? token) async {
    final newTask = TaskModel(title: title, name: name, time: time);
    try {
      final id = await _repository.createTask(newTask, token);
      _tasks.add(newTask.copyWith(id: id));
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding task: $e');
    }
  }

  Future<void> toggleTask(TaskModel task, String? token) async {
    final newStatus = !task.completed;
    try {
      await _repository.toggleStatus(task.id!, newStatus, token);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task.copyWith(completed: newStatus);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error toggling task: $e');
    }
  }

  Future<void> editTask(TaskModel task, String newTitle, String newName,
      String newTime, String? token) async {
    try {
      final updatedTask =
          task.copyWith(title: newTitle, name: newName, time: newTime);
      await _repository.updateTask(updatedTask, token);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error editing task: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId, String? token) async {
    try {
      await _repository.deleteTask(taskId, token);
      _tasks.removeWhere((t) => t.id == taskId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting task: $e');
    }
  }
}
