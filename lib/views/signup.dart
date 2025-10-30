import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/supabase.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _isAdmin = false.obs; // Toggle for admin role

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Full Name
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),

            // Email
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),

            // Password
            TextField(
              controller: _passCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 24),

            // Admin Toggle (Optional – hide in prod)
            Obx(() => SwitchListTile(
              title: const Text('Sign up as Admin'),
              value: _isAdmin.value,
              onChanged: (v) => _isAdmin.value = v,
            )),

            const SizedBox(height: 24),

            // Sign Up Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: _loading ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                ) : const Icon(Icons.person_add),
                label: Text(_loading ? 'Creating...' : 'Sign Up'),
                onPressed: _loading ? null : _signUp,
              ),
            ),

            const SizedBox(height: 16),

            // Login Link
            TextButton(
              onPressed: () => Get.offAllNamed('/login'),
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    if (_emailCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      Get.snackbar('Error', 'Fill all fields');
      return;
    }

    setState(() => _loading = true);

    try {
      await Supa.client.auth.signUp(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
        data: {
          'full_name': _nameCtrl.text.trim().isEmpty
              ? _emailCtrl.text.split('@').first
              : _nameCtrl.text.trim(),
          if (_isAdmin.value) 'role': 'admin', // Only if toggled
        },
      );

      Get.snackbar('Success', 'Account created! Check your email.');
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }
}