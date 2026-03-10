class TaskModel {
  final String? id;
  final String title;
  final String name;
  final String time;
  final bool completed;

  TaskModel({
    this.id,
    required this.title,
    this.name = '',
    this.time = '',
    this.completed = false,
  });

  /// Map Firebase unique keys (e.g., task1) to local task objects.
  factory TaskModel.fromJson(String id, Map<String, dynamic> json) {
    return TaskModel(
      id: id,
      title: json['title'] ?? '',
      name: json['name'] ?? '',
      time: json['time'] ?? '',
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'name': name,
      'time': time,
      'completed': completed,
    };
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? name,
    String? time,
    bool? completed,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      name: name ?? this.name,
      time: time ?? this.time,
      completed: completed ?? this.completed,
    );
  }
}
