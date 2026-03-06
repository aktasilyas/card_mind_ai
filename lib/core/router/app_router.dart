import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../di/injection.dart';
import '../../features/ai_generate/presentation/bloc/ai_generate_bloc.dart';
import '../../features/ai_generate/presentation/pages/ai_generate_page.dart';
import '../../features/deck/presentation/bloc/deck_bloc.dart';
import '../../features/deck/presentation/pages/deck_detail_page.dart';
import '../../features/deck/presentation/pages/deck_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/stats/presentation/bloc/stats_bloc.dart';
import '../../features/stats/presentation/pages/stats_page.dart';
import '../../features/study/presentation/pages/study_complete_page.dart';
import '../../features/study/presentation/pages/study_session_page.dart';
import '../../features/subscription/presentation/bloc/subscription_bloc.dart';
import '../../features/subscription/presentation/pages/subscription_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => BlocProvider(
                create: (_) => getIt<DeckBloc>()..add(const LoadDecks()),
                child: const DeckPage(),
              ),
              routes: [
                GoRoute(
                  path: 'deck/:id',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final deckId = state.pathParameters['id']!;
                    return BlocProvider(
                      create: (_) =>
                          getIt<DeckBloc>()..add(const LoadDecks()),
                      child: DeckDetailPage(deckId: deckId),
                    );
                  },
                ),
                GoRoute(
                  path: 'study/:id',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final deckId = state.pathParameters['id']!;
                    return StudySessionPage(deckId: deckId);
                  },
                ),
                GoRoute(
                  path: 'ai-generate/:id',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final deckId = state.pathParameters['id']!;
                    return BlocProvider(
                      create: (_) => getIt<AiGenerateBloc>(),
                      child: AiGeneratePage(deckId: deckId),
                    );
                  },
                ),
                GoRoute(
                  path: 'study-complete',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final total = int.tryParse(
                            state.uri.queryParameters['total'] ?? '') ??
                        0;
                    final avg = double.tryParse(
                            state.uri.queryParameters['avg'] ?? '') ??
                        0.0;
                    final xp = int.tryParse(
                            state.uri.queryParameters['xp'] ?? '') ??
                        0;
                    return StudyCompletePage(
                      totalCards: total,
                      averageRating: avg,
                      xpEarned: xp,
                    );
                  },
                ),
                GoRoute(
                  path: 'subscription',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => BlocProvider(
                    create: (_) => getIt<SubscriptionBloc>()
                      ..add(const LoadSubscription()),
                    child: const SubscriptionPage(),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/stats',
              builder: (context, state) {
                context.read<StatsBloc>().add(const RefreshStats());
                return const StatsPage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class _ScaffoldWithNavBar extends StatelessWidget {
  const _ScaffoldWithNavBar({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Istatistik',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
      ),
    );
  }
}
