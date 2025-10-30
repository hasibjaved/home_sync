class Roommate {
  final String id, name;
  final bool free;
  final String status;
  final double rating;
  final int total, onTime;

  Roommate({
    required this.id,
    required this.name,
    required this.free,
    this.status = 'healthy',
    this.rating = 0,
    this.total = 0,
    this.onTime = 0,
  });

  factory Roommate.fromJson(m) => Roommate(
    id: m['id'],
    name: m['name'],
    free: m['is_free'] ?? true,
    status: m['status'] ?? 'healthy',
    rating: (m['rating'] ?? 0).toDouble(),
    total: m['total_tasks'] ?? 0,
    onTime: m['on_time_tasks'] ?? 0,
  );
}