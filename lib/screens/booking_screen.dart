import 'package:flutter/material.dart';
import '../app_state.dart';
import '../constants.dart';
import '../models.dart';

// شاشة اختيار اليوم والوقت (تستقبل الخدمة من الشاشة الرئيسية)
class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // الأيام السبعة القادمة
  late final List<DateTime> days;
  int dayIndex = 0;
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    days = List.generate(7, (i) => now.add(Duration(days: i + 1)));
  }

  @override
  Widget build(BuildContext context) {
    // نستقبل الخدمة المرسلة من شاشة الخدمات
    final service = ModalRoute.of(context)!.settings.arguments as Service;
    DateTime selectedDay = days[dayIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('اختيار الموعد')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معلومات الخدمة
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: service.color.withAlpha(35),
                    child: Icon(service.icon, color: service.color, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: navy,
                          ),
                        ),
                        Text(service.doctor),
                        const SizedBox(height: 4),
                        Text(service.description,
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            sectionTitle('اختر اليوم'),
            SizedBox(
              height: 86,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                itemBuilder: (context, index) {
                  DateTime d = days[index];
                  bool selected = index == dayIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        dayIndex = index;
                        // نلغي الوقت المختار عند تغيير اليوم
                        selectedTime = null;
                      });
                    },
                    child: Container(
                      width: 78,
                      margin: const EdgeInsetsDirectional.only(end: 10),
                      decoration: BoxDecoration(
                        color: selected ? navy : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected ? gold : Colors.black12,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dayNames[d.weekday - 1],
                            style: TextStyle(
                              fontSize: 13,
                              color: selected ? Colors.white70 : Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${d.day}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: selected ? gold : navy,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            sectionTitle('اختر الوقت'),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: AppState.times.map((time) {
                // الوقت المحجوز مسبقًا يكون معطل
                bool taken = AppState.isTaken(service, selectedDay, time);
                return ChoiceChip(
                  label: Text(
                    time,
                    style: TextStyle(
                      decoration: taken ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  selected: selectedTime == time,
                  selectedColor: gold,
                  onSelected: taken
                      ? null
                      : (value) {
                          setState(() {
                            selectedTime = time;
                          });
                        },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: Colors.black45),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'الأوقات المشطوبة محجوزة مسبقًا',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
            // الزر معطل حتى نختار وقتًا
            onPressed: selectedTime == null
                ? null
                : () {
                    Navigator.pushNamed(
                      context,
                      '/confirm',
                      arguments: BookingDraft(
                        service: service,
                        day: selectedDay,
                        time: selectedTime!,
                      ),
                    );
                  },
            child: const Text('متابعة', style: TextStyle(fontSize: 18)),
          ),
        ),
      ),
    );
  }
}
