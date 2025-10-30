import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth.dart';

class LoginView extends StatelessWidget {
  final e = TextEditingController(), p = TextEditingController();
  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final a = Get.find<AuthCtrl>();
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          TextField(controller: e, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email))),
          const SizedBox(height: 16),
          TextField(controller: p, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock)), obscureText: true),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.login),
            label: const Text('Sign In'),
            onPressed: () => a.signIn(e.text, p.text).then((_) => Get.offAllNamed(a.role.value == 'admin' ? '/admin' : '/roommate')),
          ),
          TextButton(
            onPressed: () => Get.toNamed('/signup'),
            child: const Text('Don\'t have an account? Sign Up'),
          ),
        ]),
      ),
    );
  }
}