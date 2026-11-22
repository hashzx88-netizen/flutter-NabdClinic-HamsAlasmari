import 'package:flutter/material.dart';
import '../constants.dart';

// الشاشة الافتتاحية: تظهر ثلاث ثوان ثم تنتقل لتسجيل الدخول تلقائيًا
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 60), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      body: Center(
        // حركة ظهور تدريجي
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 1200),
          builder: (context, value, child) {
            return Opacity(opacity: value, child: child);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: gold, width: 3),
                ),
                child: const Icon(Icons.monitor_heart, size: 80, color: gold),
              ),
              const SizedBox(height: 26),
              const Text(
                'نبض',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Nabd Clinic',
                style: TextStyle(fontSize: 20, color: gold, letterSpacing: 2),
              ),
              const SizedBox(height: 8),
              const Text(
                'احجز موعدك بسهولة',
                style: TextStyle(fontSize: 15, color: Colors.white70),
              ),
              const SizedBox(height: 60),
              const Text(
                'إعداد الطالبة: همس',
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
              const Text(
                'Prepared by: Hams',
                style: TextStyle(fontSize: 15, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
