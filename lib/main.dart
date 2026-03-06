import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'core/constants/api_keys.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/deck/data/models/deck_model.dart';
import 'features/deck/data/models/flashcard_model.dart';
import 'features/subscription/presentation/bloc/subscription_bloc.dart';
import 'shared/services/admob_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(DeckModelAdapter());
  Hive.registerAdapter(FlashcardModelAdapter());

  await configureDependencies();

  await MobileAds.instance.initialize();
  getIt<AdmobService>().loadInterstitialAd();

  if (ApiKeys.revenueCatApiKey.isNotEmpty) {
    await Purchases.configure(
      PurchasesConfiguration(ApiKeys.revenueCatApiKey),
    );
  }

  runApp(const CardMindApp());
}

class CardMindApp extends StatelessWidget {
  const CardMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<SubscriptionBloc>()..add(const LoadSubscription()),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: MaterialApp.router(
        title: 'CardMind AI',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
      ),
    );
  }
}
