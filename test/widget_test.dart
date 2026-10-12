// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:tugasmobileprogramingjamil/main.dart';

void main() {
  testWidgets('menu utama membuka latihan for loop', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Tugas Mobile Programming'), findsOneWidget);
    expect(find.text('1. Angka 1 Sampai 50 (For Loop)'), findsOneWidget);

    await tester.tap(find.text('1. Angka 1 Sampai 50 (For Loop)'));
    await tester.pumpAndSettle();

    expect(find.text('Angka 1 sampai 50'), findsOneWidget);
  });
}
