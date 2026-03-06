import 'package:hive/hive.dart';

import '../../domain/entities/deck.dart';

class DeckModel extends HiveObject {
  DeckModel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    this.cardCount = 0,
  });

  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final int cardCount;

  Deck toEntity() {
    return Deck(
      id: id,
      name: name,
      description: description,
      createdAt: createdAt,
      cardCount: cardCount,
    );
  }

  factory DeckModel.fromEntity(Deck deck) {
    return DeckModel(
      id: deck.id,
      name: deck.name,
      description: deck.description,
      createdAt: deck.createdAt,
      cardCount: deck.cardCount,
    );
  }
}

class DeckModelAdapter extends TypeAdapter<DeckModel> {
  @override
  final int typeId = 0;

  @override
  DeckModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeckModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      createdAt: fields[3] as DateTime,
      cardCount: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DeckModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.cardCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
