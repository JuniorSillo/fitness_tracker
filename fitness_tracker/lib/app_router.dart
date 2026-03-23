import 'package:flutter/material.dart';

import 'screens/exercise_detail_screen.dart';
import 'screens/exercise_list_screen.dart';
import 'screens/home_screen.dart';



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
  exerciseList<ExerciseListArgs>(),
  exerciseDetail<ExerciseDetailArgs>();

  MaterialPageRoute route(T args) {
    return MaterialPageRoute(
      settings: RouteSettings(name: name),
      builder: (context) {
        switch (this) {
          case AppRoute.home:
            return const HomeScreen();

          case AppRoute.exerciseList:
            final realArgs = args as ExerciseListArgs;
            return ExerciseListScreen(args: realArgs);

          case AppRoute.exerciseDetail:
            final realArgs = args as ExerciseDetailArgs;
            return ExerciseDetailScreen(args: realArgs);
        }
      },
    );
  }

  String get name => toString().split('.').last;
}



extension NavigatorExtensions on NavigatorState {
  Future<void> pushRoute(AppRoute<void> route) {
    return push(route.route(null as void));
  }

  Future<R?> pushRouteWithArgs<R extends Object?, A>(
    AppRoute<A> route,
    A args,
  ) {
    return push(route.route(args));
  }
}
