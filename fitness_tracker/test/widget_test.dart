import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_tracker/main.dart';
import 'package:provider/provider.dart';
import 'package:fitness_tracker/domain/profile_provider.dart';
import 'package:fitness_tracker/domain/routine_provider.dart';
import 'package:fitness_tracker/data/profile_repository.dart';
import 'package:fitness_tracker/data/routine_repository.dart';

void main() {
  testWidgets('App shell renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ProfileProvider(ProfileRepository()),
          ),
          ChangeNotifierProvider(
            create: (_) => RoutineProvider(RoutineRepository()),
          ),
        ],
        child: const FitnessApp(),
      ),
    );

    expect(find.text('FitTrack'), findsOneWidget);
  });
}
