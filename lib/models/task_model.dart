class Task {
  final String id, title;
  final String? assignee;
  final bool done;
  final DateTime due;
  Task({required this.id, required this.title, this.assignee, required this.done, required this.due});
  factory Task.fromJson(m) => Task(
    id: m['id'],
    title: m['title'],
    assignee: m['assignee'],
    done: m['is_completed'] ?? false,
    due: DateTime.parse(m['due_date']),
  );
}