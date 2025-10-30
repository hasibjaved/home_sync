import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/auth.dart';
import '../controllers/task.dart';
import '../controllers/health.dart';

class RoommateView extends StatefulWidget {
  const RoommateView({super.key});

  @override
  State<RoommateView> createState() => _RoommateViewState();
}

class _RoommateViewState extends State<RoommateView> {
  String _selectedFilter = 'assigned';

  @override
  void initState() {
    super.initState();
    final h = Get.find<HealthCtrl>();
    if (h.show) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showHealthDialog());
    }
  }

  void _showHealthDialog() {
    final h = Get.find<HealthCtrl>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple.shade50,
                Colors.pink.shade50,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.purple.shade300],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(Icons.favorite_rounded, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'How are you today?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Let us know your current status',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Health Options
              _buildHealthOption(
                icon: Icons.sentiment_very_satisfied_rounded,
                label: 'Healthy',
                color: Colors.green,
                onTap: () {
                  h.checkIn('healthy');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              _buildHealthOption(
                icon: Icons.sick_rounded,
                label: 'Sick',
                color: Colors.orange,
                onTap: () {
                  h.checkIn('sick');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              _buildHealthOption(
                icon: Icons.work_off_rounded,
                label: 'Busy',
                color: Colors.blue,
                onTap: () {
                  h.checkIn('busy');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              _buildHealthOption(
                icon: Icons.flight_takeoff_rounded,
                label: 'Away',
                color: Colors.purple,
                onTap: () {
                  h.checkIn('away');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final a = Get.find<AuthCtrl>();
    final t = Get.find<TaskCtrl>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade50,
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Profile Avatar
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.deepPurple, Colors.purple.shade300],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'HomeSync',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          Obx(() => Text(
                            a.user.value ?? 'Roommate',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          )),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Get.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                        color: Colors.deepPurple,
                      ),
                      onPressed: () async {
                        final p = await SharedPreferences.getInstance();
                        final s = p.getBool('use_system_theme') ?? true;
                        await p.setBool('use_system_theme', !s);
                        Get.forceAppUpdate();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout_rounded, color: Colors.deepPurple),
                      onPressed: a.signOut,
                    ),
                  ],
                ),
              ),

              // Filter Chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildFilterChip('Assigned', 'assigned'),
                    const SizedBox(width: 12),
                    _buildFilterChip('Working', 'working'),
                    const SizedBox(width: 12),
                    _buildFilterChip('Completed', 'completed'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tasks List
              Expanded(
                child: Obx(() {
                  final allTasks = t.tasks.where((tk) => tk.assignee == a.user.value).toList();

                  List filteredTasks;
                  if (_selectedFilter == 'assigned') {
                    filteredTasks = allTasks.where((tk) => !tk.done && tk.title != 'working').toList();
                  } else if (_selectedFilter == 'working') {
                    filteredTasks = allTasks.where((tk) => !tk.done && tk.title == 'working').toList();
                  } else {
                    filteredTasks = allTasks.where((tk) => tk.done).toList();
                  }

                  if (filteredTasks.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _selectedFilter == 'completed'
                                ? Icons.task_alt_rounded
                                : Icons.inbox_rounded,
                            size: 80,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _selectedFilter == 'completed'
                                ? 'No completed tasks yet'
                                : 'No tasks here!',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _selectedFilter == 'completed'
                                ? 'Complete tasks to see them here'
                                : 'You\'re all caught up! 🎉',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredTasks.length,
                    itemBuilder: (_, i) {
                      final tk = filteredTasks[i];
                      return _buildStickyNote(tk, i);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
              colors: [Colors.deepPurple, Colors.purple.shade300],
            )
                : null,
            color: isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.transparent : Colors.grey.shade300,
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStickyNote(dynamic task, int index) {
    final t = Get.find<TaskCtrl>();

    // Rotating colors for sticky notes
    final colors = [
      [Colors.yellow.shade100, Colors.yellow.shade200],
      [Colors.pink.shade100, Colors.pink.shade200],
      [Colors.blue.shade100, Colors.blue.shade200],
      [Colors.green.shade100, Colors.green.shade200],
      [Colors.orange.shade100, Colors.orange.shade200],
    ];
    final colorPair = colors[index % colors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Transform.rotate(
        angle: (index % 2 == 0 ? 0.01 : -0.01),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colorPair,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (!task.done)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task.status == 'working' ? 'Working' : 'Assigned',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                ],
              ),
              if (task.description != null && task.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade800,
                    height: 1.4,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!task.done && task.status != 'working')
                    OutlinedButton.icon(
                      // onPressed: () => t.updateStatus(task.id, 'working'),
                      onPressed: () => (),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                        side: const BorderSide(color: Colors.deepPurple),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.play_arrow_rounded, size: 18),
                      label: const Text('Start'),
                    ),
                  if (!task.done && task.status == 'working') ...[
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => t.done(task.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: const Text('Complete'),
                    ),
                  ],
                  if (task.done)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green.shade700, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'Done',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}