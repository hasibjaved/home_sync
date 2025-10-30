import 'package:get/get.dart';
import '../models/task.dart';
import '../core/supabase.dart';
import 'roommate.dart';

class TaskCtrl extends GetxController {
  final tasks = <Task>[].obs;

  @override
  void onInit() {
    Supa.client.from('tasks').stream(primaryKey: ['id']).listen((d) {
      tasks.assignAll(d.map(Task.fromJson));
    });
    super.onInit();
  }

  assign(title, uid, due) async {
    final rc = Get.find<RoommateCtrl>();
    if (rc.list.firstWhere((r) => r.id == uid).status != 'healthy') return;
    await Supa.client.from('tasks').insert({
      'title': title,
      'assignee': uid,
      'due_date': due.toIso8601String(),
    });
    await Supa.client.from('roommates').update({'is_free': false}).eq('id', uid);
  }

  done(id) async {
    final t = tasks.firstWhere((e) => e.id == id);
    final onTime = DateTime.now().difference(t.due).inMinutes < 30;
    await Supa.client.from('tasks').update({
      'is_completed': true,
      'completed_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
    if (t.assignee != null) {
      await Get.find<RoommateCtrl>().rate(t.assignee!, onTime);
      await Supa.client.from('roommates').update({'is_free': true}).eq('id', t.assignee!);
    }
  }
}