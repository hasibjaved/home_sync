import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/supabase.dart';

class HealthCtrl extends GetxController {
  final last = Rxn<DateTime>();
  final status = ''.obs;
  final show = true.obs;

  @override
  void onInit() async {
    super.onInit();
    final p = await SharedPreferences.getInstance();
    final m = p.getInt('health_check');
    if (m != null) last.value = DateTime.fromMillisecondsSinceEpoch(m);
  }

  Future<void> checkIn(String s) async {
    final uid = Supa.client.auth.currentUser?.id;
    if (uid == null) return;

    // Update in Supabase
    await Supa.client.from('roommates').update({'status': s}).eq('id', uid);

    // Save locally
    final p = await SharedPreferences.getInstance();
    final now = DateTime.now();
    await p.setInt('health_check', now.millisecondsSinceEpoch);

    // Update reactive values
    last.value = now;
    status.value = s;
    show.value = false;
  }

  bool get shouldShow => last.value == null || DateTime.now().difference(last.value!).inHours >= 20;
}
