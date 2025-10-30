import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/auth.dart';
import '../controllers/roommate.dart';
import '../controllers/task.dart';
import '../models/roommate.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final a = Get.find<AuthCtrl>();
    final r = Get.find<RoommateCtrl>();
    final t = Get.find<TaskCtrl>();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: () => Get.snackbar('Link', 'roommate.app/join?code=123')),
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
      body: Row(children: [
        // Roommates
        Expanded(
          child: Obx(() => ListView.separated(
            itemCount: r.list.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final rm = r.list[i];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: rm.free ? scheme.primaryContainer : scheme.errorContainer,
                  child: Text(rm.name[0], style: TextStyle(color: scheme.onPrimaryContainer)),
                ),
                title: Text(rm.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Wrap(spacing: 6, children: [
                  Chip(label: Text(rm.free ? 'Free' : 'Busy'), backgroundColor: rm.free ? scheme.primaryContainer : scheme.errorContainer),
                  Chip(label: Text(rm.status), backgroundColor: rm.status == 'healthy' ? scheme.tertiaryContainer : scheme.secondaryContainer),
                  Text('${rm.rating.toStringAsFixed(1)} stars'),
                ]),
              );
            },
          )),
        ),
        const VerticalDivider(width: 1),
        // Tasks
        Expanded(
          flex: 2,
          child: Column(children: [
            const Padding(padding: EdgeInsets.all(16), child: Text('Tasks', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            Expanded(child: Obx(() {
              final pending = t.tasks.where((tk) => !tk.done).toList();
              return ListView.builder(
                itemCount: pending.length,
                itemBuilder: (_, i) {
                  final tk = pending[i];
                  final name = r.list.firstWhereOrNull((rm) => rm.id == tk.assignee)?.name ?? '—';
                  final left = tk.due.difference(DateTime.now());
                  final overdue = left.isNegative;
                  return Card(
                    color: overdue ? scheme.errorContainer.withOpacity(0.3) : null,
                    child: ListTile(
                      title: Text(tk.title),
                      subtitle: Text('To: $name'),
                      trailing: Chip(
                        label: Text(overdue ? 'Late' : '${left.inHours}h left'),
                        backgroundColor: overdue ? scheme.error : scheme.primary,
                        labelStyle: TextStyle(color: overdue ? scheme.onError : scheme.onPrimary),
                      ),
                    ),
                  );
                },
              );
            })),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.icon(
                icon: const Icon(Icons.add_task),
                label: const Text('Assign Task'),
                onPressed: () {
                  final free = r.list.where((rm) => rm.free && rm.status == 'healthy').toList();
                  if (free.isEmpty)  Get.snackbar('No one free', 'All healthy roommates are busy.');
                  _assignDialog(context, free);
                },
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  void _assignDialog(BuildContext ctx, List<Roommate> free) {
    String title = '';
    Roommate? assignee;
    Get.dialog(
      AlertDialog(
        title: const Text('Assign Task'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(decoration: const InputDecoration(hintText: 'Task title'), onChanged: (v) => title = v),
          DropdownButton<Roommate>(
            isExpanded: true,
            hint: const Text('Select roommate'),
            value: assignee,
            items: free.map((rm) => DropdownMenuItem(value: rm, child: Text(rm.name))).toList(),
            onChanged: (v) => assignee = v,
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: assignee == null ? null : () {
              Get.find<TaskCtrl>().assign(title, assignee!.id, DateTime.now().add(const Duration(hours: 2)));
              Get.back();
            },
            child: const Text('Assign'),
          ),
        ],
      ),
    );
  }
}