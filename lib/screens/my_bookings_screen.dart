import 'package:flutter/material.dart';
import '../app_state.dart';
import '../constants.dart';
import '../models.dart';

// شاشة حجوزاتي
class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  // إلغاء الحجز مع رسالة تأكيد (الميزة الإضافية)
  Future<void> cancel(Booking booking) async {
    bool? sure = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('إلغاء الحجز'),
          content: Text(
            'هل تريد إلغاء موعد ${booking.service.name} يوم ${dayText(booking.day)} الساعة ${booking.time}؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('تراجع'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('نعم، ألغِ الحجز',
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (sure == true) {
      setState(() {
        AppState.cancelBooking(booking);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Booking> list = AppState.myBookings();

    return Scaffold(
      appBar: AppBar(title: const Text('حجوزاتي')),
      body: list.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.event_busy, size: 80, color: Colors.black26),
                  const SizedBox(height: 12),
                  const Text('لا توجد حجوزات حاليًا',
                      style: TextStyle(fontSize: 18, color: Colors.black54)),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('احجز موعدًا'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                Booking b = list[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: b.service.color.withAlpha(35),
                            child: Icon(b.service.icon, color: b.service.color),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  b.service.name,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: navy,
                                  ),
                                ),
                                Text(b.service.doctor),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text('مؤكد',
                                style: TextStyle(color: Colors.green.shade800)),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 18, color: Colors.black45),
                          const SizedBox(width: 6),
                          Text(dayText(b.day)),
                          const SizedBox(width: 20),
                          const Icon(Icons.access_time,
                              size: 18, color: Colors.black45),
                          const SizedBox(width: 6),
                          Text(b.time),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () => cancel(b),
                            icon: const Icon(Icons.close, color: Colors.red),
                            label: const Text('إلغاء',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
