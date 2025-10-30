class Template {
  final String id, title;
  Template({required this.id, required this.title});
  factory Template.fromJson(m) => Template(id: m['id'], title: m['title']);
}