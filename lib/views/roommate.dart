import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/auth.dart';
import '../controllers/task.dart';
import '../controllers/health.dart';

class RoommateView extends StatelessWidget {
  RoommateView({super.key});

  @override
  Widget build(BuildContext context) {
    final a = Get.find<AuthCtrl>();
    final t = Get.find<TaskCtrl>();
    final h = Get.find<HealthCtrl>();

    if (h.show) WidgetsBinding.instance.addPostFrameCallback((_) => Get.dialog(
      AlertDialog(
        title: const Text('How are you today?'),
        actions: ['Healthy', 'Sick', 'Away'].map((s) => TextButton(
          onPressed: () {
            h.checkIn(s.toLowerCase());
            Get.back();
          },
          child: Text(s),
        )).toList(),
      ),
      barrierDismissible: false,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () async {
              final p = await SharedPreferences.getInstance();
              final s = p.getBool('use_system_theme') ?? true;
              await p.setBool('use_system_theme', !s);
              Get.forceAppUpdate();
            },
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: a.signOut),
        ],
      ),
      body: Obx(() {
        final mine = t.tasks.where((tk) => tk.assignee == a.user.value && !tk.done).toList();
        return mine.isEmpty
            ? const Center(child: Text('You are free!', style: TextStyle(fontSize: 18)))
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: mine.length,
          itemBuilder: (_, i) {
            final tk = mine[i];
            return Card(
              child: ListTile(
                title: Text(tk.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: FilledButton.tonal(
                  child: const Text('Done'),
                  onPressed: () => t.done(tk.id),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}