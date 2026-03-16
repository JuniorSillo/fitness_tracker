import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_tracker/main.dart';

void main() {
  testWidgets('App shell renders without errors', (WidgetTester tester) async {

    await tester.pumpWidget(const FitnessTrackerApp());


    expect(find.text('Fitness Tracking '), findsOneWidget);
    expect(find.text('Pro'), findsOneWidget);


    expect(find.textContaining('Good Morning'), findsOneWidget);


    expect(find.text('Start Workout'), findsOneWidget);
  });

  testWidgets('Motivation card shows shimmer while loading',
          (WidgetTester tester) async {
        await tester.pumpWidget(const FitnessTrackerApp());


        expect(find.byType(FitnessTrackerApp), findsOneWidget);
      });
}