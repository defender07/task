import 'package:dio/dio.dart';
import '../models/task_model.dart';

class TaskRepository {
  final Dio _dio = Dio();
  final String _baseUrl =
      'https://myname-a73b1-default-rtdb.asia-southeast1.firebasedatabase.app/task1.json';
  final String _itemBaseUrl =
      'https://myname-a73b1-default-rtdb.asia-southeast1.firebasedatabase.app/task1/';

  Future<List<TaskModel>> fetchTasks(String? token) async {
    final response = await _dio.get('$_baseUrl?auth=$token');
    if (response.data == null) return [];

    final Map<String, dynamic> data = response.data;
    return data.entries.map((e) => TaskModel.fromJson(e.key, e.value)).toList();
  }

  Future<String> createTask(TaskModel task, String? token) async {
    final response =
        await _dio.post('$_baseUrl?auth=$token', data: task.toJson());
    // Firebase returns {"name": "unique_id"}
    return response.data['name'];
  }

  Future<void> toggleStatus(
      String taskId, bool completed, String? token) async {
    await _dio.patch('$_itemBaseUrl$taskId.json?auth=$token',
        data: {'completed': completed});
  }

  Future<void> updateTask(TaskModel task, String? token) async {
    await _dio.patch('$_itemBaseUrl${task.id}.json?auth=$token',
        data: task.toJson());
  }

  Future<void> deleteTask(String taskId, String? token) async {
    await _dio.delete('$_itemBaseUrl$taskId.json?auth=$token');
  }
}
