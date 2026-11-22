import 'package:flutter_test/flutter_test.dart';
import 'package:nabd_clinic/main.dart';

void main() {
  testWidgets('الشاشة الافتتاحية ثم تسجيل الدخول', (WidgetTester tester) async {
    await tester.pumpWidget(const NabdApp());

    expect(find.text('نبض'), findsOneWidget);
    expect(find.text('Nabd Clinic'), findsOneWidget);

    // ننتظر الانتقال التلقائي بعد 3 ثوان
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    expect(find.text('تسجيل الدخول'), findsWidgets);
  });
}
