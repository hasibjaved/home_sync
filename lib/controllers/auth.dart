import 'package:get/get.dart';
import '../core/supabase.dart';

class AuthCtrl extends GetxController {
  final user = Rxn<String>();
  final role = 'roommate'.obs;

  @override
  void onInit() {
    Supa.client.auth.onAuthStateChange.listen((d) {
      user.value = d.session?.user.id;
      role.value = d.session?.user.appMetadata['role'] ?? 'roommate';
    });
    super.onInit();
  }

  signIn(e, p) => Supa.client.auth.signInWithPassword(email: e, password: p);
  signOut() => Supa.client.auth.signOut().then((_) => Get.offAllNamed('/login'));
}