import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/deck.dart';

part 'deck_event.dart';
part 'deck_state.dart';

class DeckBloc extends Bloc<DeckEvent, DeckState> {
  DeckBloc() : super(DeckInitial());
}
