import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'features/deck/data/models/deck_model.dart';
import 'features/deck/data/models/flashcard_model.dart';
import 'features/deck/presentation/pages/deck_page.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DeckPage(),
    ),
  ],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(DeckModelAdapter());
  Hive.registerAdapter(FlashcardModelAdapter());

  await configureDependencies();

  runApp(const CardMindApp());
}

class CardMindApp extends StatelessWidget {
  const CardMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CardMind AI',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
