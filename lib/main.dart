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
import 'features/stats/data/models/study_session_record_model.dart';
import 'features/stats/data/models/user_stats_model.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/stats/presentation/bloc/stats_bloc.dart';
import 'features/subscription/presentation/bloc/subscription_bloc.dart';
import 'shared/services/admob_service.dart';
import 'shared/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(DeckModelAdapter());
  Hive.registerAdapter(FlashcardModelAdapter());
  Hive.registerAdapter(UserStatsModelAdapter());
  Hive.registerAdapter(StudySessionRecordModelAdapter());

  await configureDependencies();

  await getIt<NotificationService>().init();

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<SubscriptionBloc>()..add(const LoadSubscription()),
        ),
        BlocProvider(
          create: (_) => getIt<StatsBloc>()..add(const LoadStats()),
        ),
        BlocProvider(
          create: (_) => getIt<SettingsBloc>()..add(const LoadSettings()),
        ),
      ],
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            final themeMode = state is SettingsLoaded
                ? state.settings.themeMode
                : ThemeMode.dark;
            return MaterialApp.router(
              title: 'CardMind AI',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              routerConfig: appRouter,
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }
}
