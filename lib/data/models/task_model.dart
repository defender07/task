class TaskModel {
  final String? id;
  final String title;
  final bool completed;

  TaskModel({
    this.id,
    required this.title,
    this.completed = false,
  });

  /// Map Firebase unique keys (e.g., task1) to local task objects.
  factory TaskModel.fromJson(String id, Map<String, dynamic> json) {
    return TaskModel(
      id: id,
      title: json['title'] ?? '',
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'completed': completed,
    };
  }

  TaskModel copyWith({
    String? id,
    String? title,
    bool? completed,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
