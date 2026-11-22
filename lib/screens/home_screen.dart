import 'package:flutter/material.dart';
import '../app_state.dart';
import '../constants.dart';
import '../models.dart';

// الشاشة الرئيسية: قائمة الخدمات مع قائمة جانبية (Drawer)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void openMyBookings() {
    Navigator.pushNamed(context, '/mybookings').then((value) {
      // نحدث الشاشة عند الرجوع لتتحدث عدد الحجوزات
      setState(() {});
    });
  }

  void logout() {
    AppState.currentUser = '';
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    int bookingsCount = AppState.myBookings().length;

    return Scaffold(
      appBar: AppBar(title: const Text('نبض')),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: navy,
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: gold,
                    child: Icon(Icons.person, size: 34, color: navy),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppState.currentUser,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text('مريض', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('الرئيسية'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.event_note_outlined),
              title: const Text('حجوزاتي'),
              trailing: Text('$bookingsCount'),
              onTap: () {
                Navigator.pop(context);
                openMyBookings();
              },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('تسجيل الخروج'),
              onTap: logout,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // بطاقة الترحيب
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: navy,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'أهلًا ${AppState.currentUser}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        bookingsCount == 0
                            ? 'ليس لديك حجوزات بعد'
                            : 'لديك $bookingsCount حجز قادم',
                        style: const TextStyle(color: gold, fontSize: 15),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: gold),
                  ),
                  onPressed: openMyBookings,
                  child: const Text('حجوزاتي'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          sectionTitle('اختر الخدمة'),
          ...AppState.services.map((service) => serviceCard(service)),
        ],
      ),
    );
  }

  Widget serviceCard(Service service) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // ننقل الخدمة المختارة إلى شاشة اختيار الموعد
          Navigator.pushNamed(context, '/booking', arguments: service)
              .then((value) {
            setState(() {});
          });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: Colors.white,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(width: 7, color: service.color),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: service.color.withAlpha(35),
                      child: Icon(service.icon, color: service.color, size: 28),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            service.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: navy,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(service.doctor,
                              style: const TextStyle(color: Colors.black54)),
                          const SizedBox(height: 4),
                          Text(
                            '${service.price} ريال',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB07A00),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.chevron_left, color: Colors.black38),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
