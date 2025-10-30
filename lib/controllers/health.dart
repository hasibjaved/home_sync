import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/supabase.dart';

class HealthCtrl extends GetxController {
  final last = Rxn<DateTime>();

  @override
  void onInit() async {
    final p = await SharedPreferences.getInstance();
    final m = p.getInt('health_check');
    if (m != null) last.value = DateTime.fromMillisecondsSinceEpoch(m);
    super.onInit();
  }

  checkIn(s) async {
    final uid = Supa.client.auth.currentUser?.id;
    if (uid == null) return;
    await Supa.client.from('roommates').update({'status': s}).eq('id', uid);
    final p = await SharedPreferences.getInstance();
    await p.setInt('health_check', DateTime.now().millisecondsSinceEpoch);
    last.value = DateTime.now();
  }

  bool get show => last.value == null || DateTime.now().difference(last.value!).inHours >= 20;
}