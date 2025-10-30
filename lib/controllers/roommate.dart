import 'package:get/get.dart';
import '../models/roommate.dart';
import '../core/supabase.dart';

class RoommateCtrl extends GetxController {
  final list = <Roommate>[].obs;

  @override
  void onInit() {
    Supa.client.from('roommates').stream(primaryKey: ['id']).listen((d) {
      list.assignAll(d.map(Roommate.fromJson));
    });
    super.onInit();
  }

  add(name, uid) => Supa.client.from('roommates').insert({
    'id': uid,
    'name': name,
    'is_free': true,
    'status': 'healthy',
  });

  rate(id, onTime) async {
    final r = list.firstWhere((e) => e.id == id);
    final total = r.total + 1, on = r.onTime + (onTime ? 1 : 0);
    final rating = total > 0 ? on / total * 5 : 0;
    await Supa.client.from('roommates').update({
      'total_tasks': total,
      'on_time_tasks': on,
      'rating': rating,
    }).eq('id', id);
  }
}