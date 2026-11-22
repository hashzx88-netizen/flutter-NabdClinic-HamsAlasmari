import 'package:flutter/material.dart';
import '../app_state.dart';
import '../constants.dart';
import '../models.dart';

// شاشة تأكيد الحجز (تستقبل بيانات الحجز من شاشة الموعد)
class ConfirmScreen extends StatelessWidget {
  const ConfirmScreen({super.key});

  Widget infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Icon(icon, size: 22, color: navy),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Colors.black54)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void confirm(BuildContext context, BookingDraft draft) {
    // نتأكد أن الموعد لم يُحجز قبل قليل
    if (AppState.isTaken(draft.service, draft.day, draft.time)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('عذرًا، هذا الموعد تم حجزه للتو')),
      );
      return;
    }

    AppState.addBooking(draft);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تأكيد حجزك بنجاح')),
    );

    // نذهب إلى حجوزاتي ونبقي الرئيسية خلفها
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/mybookings',
      ModalRoute.withName('/home'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final draft = ModalRoute.of(context)!.settings.arguments as BookingDraft;

    return Scaffold(
      appBar: AppBar(title: const Text('تأكيد الحجز')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: draft.service.color.withAlpha(35),
                    child: Icon(draft.service.icon,
                        size: 36, color: draft.service.color),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'راجع تفاصيل حجزك',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  const Divider(height: 28),
                  infoRow(Icons.person_outline, 'المريض', AppState.currentUser),
                  infoRow(Icons.local_hospital_outlined, 'الخدمة',
                      draft.service.name),
                  infoRow(Icons.badge_outlined, 'الطبيب', draft.service.doctor),
                  infoRow(
                      Icons.calendar_today, 'اليوم', dayText(draft.day)),
                  infoRow(Icons.access_time, 'الوقت', draft.time),
                  const Divider(height: 28),
                  infoRow(Icons.payments_outlined, 'الرسوم',
                      '${draft.service.price} ريال'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'الدفع يتم في العيادة عند الحضور',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton(
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52)),
                onPressed: () => confirm(context, draft),
                child: const Text('تأكيد الحجز', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('تعديل الموعد'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
