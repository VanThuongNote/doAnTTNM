import 'package:flutter_test/flutter_test.dart';
import 'package:health_track/main.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const HealthTrackApp());
    expect(find.text('HealthTrack'), findsOneWidget);
  });
}
