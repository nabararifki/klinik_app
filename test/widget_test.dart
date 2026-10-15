import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klinik_app/ui/login.dart';

void main() {
  testWidgets('Klinik App smoke test', (WidgetTester tester) async {
    // Build Widget Login
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF77216F),
            foregroundColor: Colors.white,
          ),
        ),
        home: const Login(),
      ),
    );

    // Verify that Login page is displayed
    expect(find.text('Login Admin'), findsOneWidget);
  });
}
