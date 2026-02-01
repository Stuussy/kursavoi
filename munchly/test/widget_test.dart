import 'package:flutter_test/flutter_test.dart';
import 'package:munchly/main.dart';

void main() {
  testWidgets('App initializes', (WidgetTester tester) async {
    await tester.pumpWidget(const MunchlyApp());
    expect(find.text('Login'), findsOneWidget);
  });
}
