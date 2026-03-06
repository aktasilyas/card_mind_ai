import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../di/injection.dart';
import '../../features/ai_generate/presentation/bloc/ai_generate_bloc.dart';
import '../../features/ai_generate/presentation/pages/ai_generate_page.dart';
import '../../features/deck/presentation/bloc/deck_bloc.dart';
import '../../features/deck/presentation/pages/deck_detail_page.dart';
import '../../features/deck/presentation/pages/deck_page.dart';
import '../../features/study/presentation/pages/study_session_page.dart';
import '../../features/subscription/presentation/bloc/subscription_bloc.dart';
import '../../features/subscription/presentation/pages/subscription_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<DeckBloc>()..add(const LoadDecks()),
        child: const DeckPage(),
      ),
    ),
    GoRoute(
      path: '/deck/:id',
      builder: (context, state) {
        final deckId = state.pathParameters['id']!;
        return BlocProvider(
          create: (_) => getIt<DeckBloc>()..add(const LoadDecks()),
          child: DeckDetailPage(deckId: deckId),
        );
      },
    ),
    GoRoute(
      path: '/study/:id',
      builder: (context, state) {
        final deckId = state.pathParameters['id']!;
        return StudySessionPage(deckId: deckId);
      },
    ),
    GoRoute(
      path: '/ai-generate/:id',
      builder: (context, state) {
        final deckId = state.pathParameters['id']!;
        return BlocProvider(
          create: (_) => getIt<AiGenerateBloc>(),
          child: AiGeneratePage(deckId: deckId),
        );
      },
    ),
    GoRoute(
      path: '/subscription',
      builder: (context, state) => BlocProvider(
        create: (_) =>
            getIt<SubscriptionBloc>()..add(const LoadSubscription()),
        child: const SubscriptionPage(),
      ),
    ),
  ],
);
