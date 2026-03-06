// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:card_mind_ai/core/di/register_module.dart' as _i62;
import 'package:card_mind_ai/core/network/dio_client.dart' as _i466;
import 'package:card_mind_ai/features/ai_generate/data/datasources/ai_card_remote_datasource.dart'
    as _i310;
import 'package:card_mind_ai/features/ai_generate/data/repositories/ai_generate_repository_impl.dart'
    as _i790;
import 'package:card_mind_ai/features/ai_generate/domain/repositories/ai_generate_repository.dart'
    as _i609;
import 'package:card_mind_ai/features/ai_generate/domain/usecases/generate_cards_from_text.dart'
    as _i251;
import 'package:card_mind_ai/features/ai_generate/presentation/bloc/ai_generate_bloc.dart'
    as _i379;
import 'package:card_mind_ai/features/deck/data/datasources/deck_local_datasource.dart'
    as _i837;
import 'package:card_mind_ai/features/deck/data/models/deck_model.dart'
    as _i550;
import 'package:card_mind_ai/features/deck/data/models/flashcard_model.dart'
    as _i421;
import 'package:card_mind_ai/features/deck/data/repositories/deck_repository_impl.dart'
    as _i581;
import 'package:card_mind_ai/features/deck/domain/repositories/deck_repository.dart'
    as _i430;
import 'package:card_mind_ai/features/deck/domain/usecases/add_card.dart'
    as _i908;
import 'package:card_mind_ai/features/deck/domain/usecases/create_deck.dart'
    as _i110;
import 'package:card_mind_ai/features/deck/domain/usecases/delete_deck.dart'
    as _i260;
import 'package:card_mind_ai/features/deck/domain/usecases/get_cards_by_deck.dart'
    as _i292;
import 'package:card_mind_ai/features/deck/domain/usecases/get_decks.dart'
    as _i573;
import 'package:card_mind_ai/features/deck/domain/usecases/get_due_cards.dart'
    as _i923;
import 'package:card_mind_ai/features/deck/domain/usecases/update_card.dart'
    as _i747;
import 'package:card_mind_ai/features/deck/presentation/bloc/deck_bloc.dart'
    as _i1034;
import 'package:card_mind_ai/features/study/presentation/bloc/study_bloc.dart'
    as _i354;
import 'package:card_mind_ai/features/subscription/data/datasources/subscription_remote_datasource.dart'
    as _i273;
import 'package:card_mind_ai/features/subscription/data/repositories/subscription_repository_impl.dart'
    as _i844;
import 'package:card_mind_ai/features/subscription/domain/repositories/subscription_repository.dart'
    as _i401;
import 'package:card_mind_ai/features/subscription/domain/usecases/get_subscription_status.dart'
    as _i29;
import 'package:card_mind_ai/features/subscription/domain/usecases/purchase_premium.dart'
    as _i511;
import 'package:card_mind_ai/features/subscription/domain/usecases/restore_purchases.dart'
    as _i29;
import 'package:card_mind_ai/features/subscription/presentation/bloc/subscription_bloc.dart'
    as _i145;
import 'package:card_mind_ai/shared/services/admob_service.dart' as _i573;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i979.Box<_i550.DeckModel>>(
      () => registerModule.decksBox,
      preResolve: true,
    );
    await gh.factoryAsync<_i979.Box<_i421.FlashcardModel>>(
      () => registerModule.cardsBox,
      preResolve: true,
    );
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i466.DioClient>(() => _i466.DioClient());
    gh.singleton<_i573.AdmobService>(() => _i573.AdmobService());
    gh.lazySingleton<_i837.DeckLocalDatasource>(
      () => _i837.DeckLocalDatasourceImpl(
        gh<_i979.Box<_i550.DeckModel>>(),
        gh<_i979.Box<_i421.FlashcardModel>>(),
      ),
    );
    gh.lazySingleton<_i273.SubscriptionRemoteDatasource>(
      () => _i273.SubscriptionRemoteDatasourceImpl(),
    );
    gh.lazySingleton<_i310.AiCardRemoteDatasource>(
      () => _i310.AiCardRemoteDatasourceImpl(gh<_i466.DioClient>()),
    );
    gh.lazySingleton<_i401.SubscriptionRepository>(
      () => _i844.SubscriptionRepositoryImpl(
        gh<_i273.SubscriptionRemoteDatasource>(),
      ),
    );
    gh.lazySingleton<_i430.DeckRepository>(
      () => _i581.DeckRepositoryImpl(gh<_i837.DeckLocalDatasource>()),
    );
    gh.factory<_i908.AddCard>(() => _i908.AddCard(gh<_i430.DeckRepository>()));
    gh.factory<_i110.CreateDeck>(
      () => _i110.CreateDeck(gh<_i430.DeckRepository>()),
    );
    gh.factory<_i260.DeleteDeck>(
      () => _i260.DeleteDeck(gh<_i430.DeckRepository>()),
    );
    gh.factory<_i292.GetCardsByDeck>(
      () => _i292.GetCardsByDeck(gh<_i430.DeckRepository>()),
    );
    gh.factory<_i573.GetDecks>(
      () => _i573.GetDecks(gh<_i430.DeckRepository>()),
    );
    gh.factory<_i923.GetDueCards>(
      () => _i923.GetDueCards(gh<_i430.DeckRepository>()),
    );
    gh.factory<_i747.UpdateCard>(
      () => _i747.UpdateCard(gh<_i430.DeckRepository>()),
    );
    gh.lazySingleton<_i609.AiGenerateRepository>(
      () => _i790.AiGenerateRepositoryImpl(gh<_i310.AiCardRemoteDatasource>()),
    );
    gh.factory<_i1034.DeckBloc>(
      () => _i1034.DeckBloc(
        gh<_i573.GetDecks>(),
        gh<_i110.CreateDeck>(),
        gh<_i260.DeleteDeck>(),
      ),
    );
    gh.factory<_i354.StudyBloc>(
      () => _i354.StudyBloc(gh<_i923.GetDueCards>(), gh<_i747.UpdateCard>()),
    );
    gh.factory<_i29.GetSubscriptionStatus>(
      () => _i29.GetSubscriptionStatus(gh<_i401.SubscriptionRepository>()),
    );
    gh.factory<_i511.PurchasePremium>(
      () => _i511.PurchasePremium(gh<_i401.SubscriptionRepository>()),
    );
    gh.factory<_i29.RestorePurchases>(
      () => _i29.RestorePurchases(gh<_i401.SubscriptionRepository>()),
    );
    gh.factory<_i251.GenerateCardsFromText>(
      () => _i251.GenerateCardsFromText(
        gh<_i609.AiGenerateRepository>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.factory<_i145.SubscriptionBloc>(
      () => _i145.SubscriptionBloc(
        gh<_i29.GetSubscriptionStatus>(),
        gh<_i511.PurchasePremium>(),
        gh<_i29.RestorePurchases>(),
      ),
    );
    gh.factory<_i379.AiGenerateBloc>(
      () => _i379.AiGenerateBloc(gh<_i251.GenerateCardsFromText>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i62.RegisterModule {}
