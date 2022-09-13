const String tableNotes = 'todos';

class TodoFields {
  static final List<String> values = [
    id,
    isDone,
    title,
    description,
    createdDate,
  ];

  static const String id = '_id';
  static const String isDone = 'isDone';
  static const String title = 'title';
  static const String description = 'description';
  static const String createdDate = 'date';
}

class Todo {
  final int? id;
  final bool isDone;
  final String title;
  final String description;
  final DateTime createdDate;

  const Todo({
    this.id,
    required this.isDone,
    required this.title,
    required this.description,
    required this.createdDate,
  });

  Todo copy({
    int? id,
    bool? isDone,
    String? title,
    String? description,
    DateTime? createdDate,
  }) =>
      Todo(
        id: id ?? this.id,
        isDone: isDone ?? this.isDone,
        title: title ?? this.title,
        description: description ?? this.description,
        createdDate: createdDate ?? this.createdDate,
      );

  static Todo fromJson(Map<String, Object?> json) => Todo(
        id: json[TodoFields.id] as int?,
        isDone: json[TodoFields.isDone] == 1,
        title: json[TodoFields.title] as String,
        description: json[TodoFields.description] as String,
        createdDate: DateTime.parse(json[TodoFields.createdDate] as String),
      );

  Map<String, Object?> toJson() => {
        TodoFields.id: id,
        TodoFields.title: title,
        TodoFields.isDone: isDone ? 1 : 0,
        TodoFields.description: description,
        TodoFields.createdDate: createdDate.toIso8601String(),
      };
}
