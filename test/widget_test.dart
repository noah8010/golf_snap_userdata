import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf_stats_app/main.dart';

void main() {
  testWidgets('App renders successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: GolfStatsApp(),
      ),
    );

    // Verify that the dashboard title is present
    expect(find.text('Overview'), findsOneWidget);
  });
}
