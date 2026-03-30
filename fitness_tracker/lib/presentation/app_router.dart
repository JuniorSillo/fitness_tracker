import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../bmi_screen.dart';
import '../screens/add_exercise_screen.dart';
import '../screens/exercise_list_screen.dart';
import '../screens/exercise_detail_screen.dart';
import '../app_router.dart' as global;

class ExerciseListArgs {
  final String categoryName;
  final Color themeColor;
  final IconData iconData;

  const ExerciseListArgs({
    required this.categoryName,
    required this.themeColor,
    required this.iconData,
  });
}

class ExerciseDetailArgs {
  final String exerciseName;
  final String muscleGroup;
  final int sets;
  final int reps;
  final double weight;

  const ExerciseDetailArgs({
    required this.exerciseName,
    required this.muscleGroup,
    required this.sets,
    required this.reps,
    required this.weight,
  });
}

enum AppRoute<T> {
  home<void>(),
  bmi<void>(),
  addExercise<void>(),
  exerciseList<ExerciseListArgs>(),
  exerciseDetail<ExerciseDetailArgs>();

  MaterialPageRoute<T> route([T? args]) {
    return MaterialPageRoute<T>(
      settings: RouteSettings(name: name),
      builder: (context) {
        switch (this) {
          case AppRoute.home:
            return const HomeScreen();
          case AppRoute.bmi:
            return const BmiScreen();
          case AppRoute.addExercise:
            return const AddExerciseScreen();
          case AppRoute.exerciseList:
            final castedArgs = args as ExerciseListArgs;
            return ExerciseListScreen(
              args: global.ExerciseListArgs(
                categoryName: castedArgs.categoryName,
                themeColor: castedArgs.themeColor,
                iconData: castedArgs.iconData,
              ),
            );
          case AppRoute.exerciseDetail:
            final castedArgs = args as ExerciseDetailArgs;
            return ExerciseDetailScreen(
              args: global.ExerciseDetailArgs(
                exerciseName: castedArgs.exerciseName,
                muscleGroup: castedArgs.muscleGroup,
                sets: castedArgs.sets,
                reps: castedArgs.reps,
                weight: castedArgs.weight,
              ),
            );
        }
      },
    );
  }

  String get name => toString().split('.').last;
}

extension NavigatorExtensions on NavigatorState {
  Future<dynamic> pushRoute<T>(AppRoute<T> route, [T? args]) =>
      push(route.route(args));

  Future<T?> pushRouteWithArgs<T extends Object?>(AppRoute<T> route, T args) =>
      push(route.route(args));
}
