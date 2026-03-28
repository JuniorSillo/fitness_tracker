import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/bmi_screen.dart';
import 'screens/add_exercise_screen.dart';
import 'screens/exercise_list_screen.dart';
import 'screens/exercise_detail_screen.dart';

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
            return ExerciseListScreen(args: args as ExerciseListArgs);
          case AppRoute.exerciseDetail:
            return ExerciseDetailScreen(args: args as ExerciseDetailArgs);
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
