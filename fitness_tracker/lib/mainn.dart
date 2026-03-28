import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'data/profile_repository.dart';
import 'data/routine_repository.dart';


import 'domain/profile_provider.dart';
import 'domain/routine_provider.dart';


import 'presentation/screens/home_screen.dart';

void main() {
  runApp(const FitnessApp());
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Repositories are being  created here, injected into providers
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(ProfileRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => RoutineProvider(RoutineRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'FitTrack',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2DE394),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF0D2B1F),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
