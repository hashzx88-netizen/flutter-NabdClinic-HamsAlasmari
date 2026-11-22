import 'package:flutter/material.dart';

// الخدمة (التخصص الطبي)
class Service {
  final String name;
  final String doctor;
  final String description;
  final int price;
  final IconData icon;
  final Color color;

  const Service({
    required this.name,
    required this.doctor,
    required this.description,
    required this.price,
    required this.icon,
    required this.color,
  });
}

// الحجز بعد التأكيد
class Booking {
  final int id;
  final String user;
  final Service service;
  final DateTime day;
  final String time;

  Booking({
    required this.id,
    required this.user,
    required this.service,
    required this.day,
    required this.time,
  });
}

// بيانات الحجز قبل التأكيد (تنتقل من شاشة الموعد إلى شاشة التأكيد)
class BookingDraft {
  final Service service;
  final DateTime day;
  final String time;

  BookingDraft({required this.service, required this.day, required this.time});
}
