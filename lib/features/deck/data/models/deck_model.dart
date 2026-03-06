import 'package:hive/hive.dart';

import '../../domain/entities/deck.dart';

part 'deck_model.g.dart';

@HiveType(typeId: 0)
class DeckModel extends Deck {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  const DeckModel({
    required this.id,
    required this.name,
  }) : super(id: id, name: name);
}
