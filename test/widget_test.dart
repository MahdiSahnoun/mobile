import 'package:flutter_test/flutter_test.dart';
import 'package:mini_projet/main.dart';
import 'package:mini_projet/Page/inscription.page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Initial page should be InscriptionPage when not connected', (WidgetTester tester) async {
    // Set up mock SharedPreferences
    SharedPreferences.setMockInitialValues({'connect': false});

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for FutureBuilder
    await tester.pump(Duration.zero);

    // Verify that InscriptionPage is shown
    expect(find.byType(InscriptionPage), findsOneWidget);
    expect(find.text('Page Inscription'), findsOneWidget);
  });
}
