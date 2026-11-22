import 'package:flutter/material.dart';
import 'constants.dart';
import 'models.dart';

// أسماء الأيام (weekday: 1 = الإثنين ... 7 = الأحد)
const List<String> dayNames = [
  'الإثنين',
  'الثلاثاء',
  'الأربعاء',
  'الخميس',
  'الجمعة',
  'السبت',
  'الأحد',
];

// تنسيق التاريخ مثل: الأحد 22/11
String dayText(DateTime d) {
  return '${dayNames[d.weekday - 1]} ${d.day}/${d.month}';
}

// كل البيانات تتخزن في الذاكرة فقط (بدون قاعدة بيانات)
class AppState {
  // المستخدمين المسجلين: كل مستخدم Map فيه username و password
  static List<Map<String, String>> users = [];

  // المستخدم الحالي
  static String currentUser = '';

  // عداد أرقام الحجوزات
  static int nextId = 1;

  // الأوقات المتاحة في اليوم
  static const List<String> times = [
    '9:00 ص',
    '10:00 ص',
    '11:00 ص',
    '12:00 م',
    '4:00 م',
    '5:00 م',
    '6:00 م',
  ];

  // الخدمات
  static final List<Service> services = [
    const Service(
      name: 'طب الأسنان',
      doctor: 'د. ليان الشهري',
      description: 'فحص وتنظيف وحشوات وعلاج مشاكل الفم والأسنان.',
      price: 150,
      icon: Icons.medical_services,
      color: Color(0xFF1E88E5),
    ),
    const Service(
      name: 'أمراض القلب',
      doctor: 'د. خالد المطيري',
      description: 'فحص القلب وقياس الضغط وتخطيط القلب ومتابعة الحالات.',
      price: 300,
      icon: Icons.monitor_heart,
      color: Color(0xFFE53935),
    ),
    const Service(
      name: 'طب العيون',
      doctor: 'د. سارة القحطاني',
      description: 'فحص النظر وقياس العدسات ومتابعة صحة العين.',
      price: 200,
      icon: Icons.visibility,
      color: Color(0xFF00897B),
    ),
    const Service(
      name: 'طب الأطفال',
      doctor: 'د. نورة العتيبي',
      description: 'متابعة نمو الطفل والتطعيمات وعلاج أمراض الطفولة.',
      price: 180,
      icon: Icons.child_care,
      color: Color(0xFFFB8C00),
    ),
    const Service(
      name: 'الجلدية والتجميل',
      doctor: 'د. ريم الدوسري',
      description: 'علاج مشاكل البشرة والشعر والعناية الجلدية.',
      price: 250,
      icon: Icons.spa,
      color: Color(0xFF8E24AA),
    ),
    const Service(
      name: 'الصحة النفسية',
      doctor: 'د. فهد الزهراني',
      description: 'جلسات استشارية ودعم نفسي في بيئة هادئة وسرية.',
      price: 350,
      icon: Icons.psychology,
      color: Color(0xFF3949AB),
    ),
  ];

  // كل الحجوزات (فيها حجوزات جاهزة من "النظام" لتظهر بعض الأوقات محجوزة)
  static final List<Booking> bookings = _seed();

  static List<Booking> _seed() {
    DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
    DateTime later = DateTime.now().add(const Duration(days: 2));
    return [
      Booking(
          id: nextId++,
          user: 'النظام',
          service: services[0],
          day: tomorrow,
          time: '10:00 ص'),
      Booking(
          id: nextId++,
          user: 'النظام',
          service: services[0],
          day: tomorrow,
          time: '11:00 ص'),
      Booking(
          id: nextId++,
          user: 'النظام',
          service: services[1],
          day: tomorrow,
          time: '4:00 م'),
      Booking(
          id: nextId++,
          user: 'النظام',
          service: services[2],
          day: later,
          time: '9:00 ص'),
    ];
  }

  // هل نفس الخدمة في نفس اليوم والوقت محجوزة؟
  static bool isTaken(Service service, DateTime day, String time) {
    for (var b in bookings) {
      bool sameDay =
          b.day.year == day.year && b.day.month == day.month && b.day.day == day.day;
      if (b.service == service && sameDay && b.time == time) {
        return true;
      }
    }
    return false;
  }

  // حجوزات المستخدم الحالي فقط
  static List<Booking> myBookings() {
    return bookings.where((b) => b.user == currentUser).toList();
  }

  static void addBooking(BookingDraft draft) {
    bookings.add(Booking(
      id: nextId++,
      user: currentUser,
      service: draft.service,
      day: draft.day,
      time: draft.time,
    ));
  }

  static void cancelBooking(Booking booking) {
    bookings.remove(booking);
  }
}

// عنوان صغير يتكرر في الشاشات
Widget sectionTitle(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 12),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
        color: navy,
      ),
    ),
  );
}
