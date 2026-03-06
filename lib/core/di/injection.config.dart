// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:card_mind_ai/core/di/register_module.dart' as _i62;
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
import 'package:card_mind_ai/features/deck/presentation/bloc/deck_bloc.dart'
    as _i1034;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:injectable/injectable.dart' as _i526;

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
    gh.lazySingleton<_i837.DeckLocalDatasource>(
      () => _i837.DeckLocalDatasourceImpl(
        gh<_i979.Box<_i550.DeckModel>>(),
        gh<_i979.Box<_i421.FlashcardModel>>(),
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
    gh.factory<_i1034.DeckBloc>(
      () => _i1034.DeckBloc(
        gh<_i573.GetDecks>(),
        gh<_i110.CreateDeck>(),
        gh<_i260.DeleteDeck>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i62.RegisterModule {}
