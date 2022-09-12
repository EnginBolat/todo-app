const String tableNotes = 'todos';

class TodoFields {
  static final List<String> values = [
    id, isDone, title, description, time,
  ];

  static const String id = '_id';
  static const String isDone = 'isDone';
  static const String title = 'title';
  static const String description = 'description';
  static const String time = 'time';
}

class Todo {
  final int? id;
  final bool isDone;
  final String title;
  final String description;
  final DateTime createdTime;

  const Todo({
    this.id,
    required this.isDone,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  Todo copy({
    int? id,
    bool? isDone,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Todo(
        id: id ?? this.id,
        isDone: isDone ?? this.isDone,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static Todo fromJson(Map<String, Object?> json) => Todo(
        id: json[TodoFields.id] as int?,
        isDone: json[TodoFields.isDone] == 1,
        title: json[TodoFields.title] as String,
        description: json[TodoFields.description] as String,
        createdTime: DateTime.parse(json[TodoFields.time] as String),
      );

  Map<String, Object?> toJson() => {
        TodoFields.id: id,
        TodoFields.title: title,
        TodoFields.isDone: isDone ? 1 : 0,
        TodoFields.description: description,
        TodoFields.time: createdTime.toIso8601String(),
      };
}