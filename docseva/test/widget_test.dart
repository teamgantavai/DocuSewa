import 'package:flutter_test/flutter_test.dart';
import 'package:docusewa/main.dart';

void main() {
  testWidgets('DocuSewaApp renders phone auth screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DocuSewaApp());

    // Verify that DocuSewa branding and phone auth screen are displayed.
    expect(find.text('Welcome to DocuSewa'), findsWidgets);
  });
}
