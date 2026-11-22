import 'package:flutter/material.dart';
import '../app_state.dart';
import '../constants.dart';

// شاشة إنشاء حساب
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String? usernameError;
  String? passwordError;
  bool hidePassword = true;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void register() {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    // حقل فارغ
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        usernameError = username.isEmpty ? 'هذا الحقل مطلوب' : null;
        passwordError = password.isEmpty ? 'هذا الحقل مطلوب' : null;
      });
      return;
    }

    // اسم المستخدم مسجل من قبل
    bool exists = AppState.users.any((u) => u['username'] == username);
    if (exists) {
      setState(() {
        usernameError = 'اسم المستخدم مسجّل مسبقًا';
        passwordError = null;
      });
      return;
    }

    AppState.users.add({'username': username, 'password': password});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إنشاء الحساب، يمكنك تسجيل الدخول الآن')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حساب جديد')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const CircleAvatar(
              radius: 34,
              backgroundColor: gold,
              child: Icon(Icons.person_add, size: 34, color: navy),
            ),
            const SizedBox(height: 16),
            const Text(
              'أنشئ حسابك',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: navy,
              ),
            ),
            const SizedBox(height: 4),
            const Text('أدخل اسم مستخدم وكلمة مرور للبدء'),
            const SizedBox(height: 24),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'اسم المستخدم',
                prefixIcon: const Icon(Icons.person_outline),
                errorText: usernameError,
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: hidePassword,
              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                ),
                errorText: passwordError,
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: register,
                child:
                    const Text('إنشاء الحساب', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
