import 'package:hive/hive.dart';

import '../../domain/entities/study_session_record.dart';

class StudySessionRecordModel {
  const StudySessionRecordModel({
    required this.deckId,
    required this.date,
    required this.cardsStudied,
    required this.correctCount,
    required this.xpEarned,
    required this.durationSeconds,
  });

  final String deckId;
  final DateTime date;
  final int cardsStudied;
  final int correctCount;
  final int xpEarned;
  final int durationSeconds;

  StudySessionRecord toEntity() {
    return StudySessionRecord(
      deckId: deckId,
      date: date,
      cardsStudied: cardsStudied,
      correctCount: correctCount,
      xpEarned: xpEarned,
      durationSeconds: durationSeconds,
    );
  }

  factory StudySessionRecordModel.fromEntity(StudySessionRecord record) {
    return StudySessionRecordModel(
      deckId: record.deckId,
      date: record.date,
      cardsStudied: record.cardsStudied,
      correctCount: record.correctCount,
      xpEarned: record.xpEarned,
      durationSeconds: record.durationSeconds,
    );
  }
}

class StudySessionRecordModelAdapter
    extends TypeAdapter<StudySessionRecordModel> {
  @override
  final int typeId = 3;

  @override
  StudySessionRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudySessionRecordModel(
      deckId: fields[0] as String,
      date: fields[1] as DateTime,
      cardsStudied: fields[2] as int,
      correctCount: fields[3] as int,
      xpEarned: fields[4] as int,
      durationSeconds: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StudySessionRecordModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.deckId)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.cardsStudied)
      ..writeByte(3)
      ..write(obj.correctCount)
      ..writeByte(4)
      ..write(obj.xpEarned)
      ..writeByte(5)
      ..write(obj.durationSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudySessionRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
