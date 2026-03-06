import 'package:hive/hive.dart';

import '../../domain/entities/flashcard.dart';

class FlashcardModel extends HiveObject {
  FlashcardModel({
    required this.id,
    required this.deckId,
    required this.front,
    required this.back,
    this.easeFactor = 2.5,
    this.interval = 1,
    this.repetitions = 0,
    required this.dueDate,
  });

  final String id;
  final String deckId;
  final String front;
  final String back;
  final double easeFactor;
  final int interval;
  final int repetitions;
  final DateTime dueDate;

  Flashcard toEntity() {
    return Flashcard(
      id: id,
      deckId: deckId,
      front: front,
      back: back,
      easeFactor: easeFactor,
      interval: interval,
      repetitions: repetitions,
      dueDate: dueDate,
    );
  }

  factory FlashcardModel.fromEntity(Flashcard card) {
    return FlashcardModel(
      id: card.id,
      deckId: card.deckId,
      front: card.front,
      back: card.back,
      easeFactor: card.easeFactor,
      interval: card.interval,
      repetitions: card.repetitions,
      dueDate: card.dueDate,
    );
  }
}

class FlashcardModelAdapter extends TypeAdapter<FlashcardModel> {
  @override
  final int typeId = 1;

  @override
  FlashcardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlashcardModel(
      id: fields[0] as String,
      deckId: fields[1] as String,
      front: fields[2] as String,
      back: fields[3] as String,
      easeFactor: fields[4] as double,
      interval: fields[5] as int,
      repetitions: fields[6] as int,
      dueDate: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FlashcardModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.deckId)
      ..writeByte(2)
      ..write(obj.front)
      ..writeByte(3)
      ..write(obj.back)
      ..writeByte(4)
      ..write(obj.easeFactor)
      ..writeByte(5)
      ..write(obj.interval)
      ..writeByte(6)
      ..write(obj.repetitions)
      ..writeByte(7)
      ..write(obj.dueDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashcardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
