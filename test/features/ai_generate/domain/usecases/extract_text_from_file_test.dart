import 'dart:io';

import 'package:card_mind_ai/core/errors/failures.dart';
import 'package:card_mind_ai/features/ai_generate/domain/usecases/extract_text_from_file.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ExtractTextFromFile usecase;

  setUp(() {
    usecase = ExtractTextFromFile();
  });

  group('ExtractTextFromFile', () {
    group('desteklenmeyen format', () {
      test(
        'docx extension verildiğinde Left(ServerFailure) döndürmeli',
        () async {
          const params = ExtractTextFromFileParams(
            filePath: '/herhangi/bir/dosya.docx',
            fileExtension: 'docx',
          );

          final result = await usecase(params);

          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<ServerFailure>());
              expect(
                failure.message,
                contains('Desteklenmeyen dosya formatı'),
              );
            },
            (_) => fail('Right döndü, Left bekleniyor'),
          );
        },
      );

      test(
        'büyük harf extension verildiğinde de Left(ServerFailure) döndürmeli',
        () async {
          const params = ExtractTextFromFileParams(
            filePath: '/herhangi/bir/dosya.DOCX',
            fileExtension: 'DOCX',
          );

          final result = await usecase(params);

          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (_) => fail('Right döndü, Left bekleniyor'),
          );
        },
      );
    });

    group('TXT dosya okuma', () {
      test(
        'geçerli içerikli txt dosyası için Right(metin) döndürmeli',
        () async {
          final tempDir = Directory.systemTemp;
          final tempFile = File(
            '${tempDir.path}/extract_text_test_${DateTime.now().millisecondsSinceEpoch}.txt',
          );

          const expectedContent = 'Bu bir test metnidir.\nİkinci satır.';
          await tempFile.writeAsString(expectedContent);

          try {
            final params = ExtractTextFromFileParams(
              filePath: tempFile.path,
              fileExtension: 'txt',
            );

            final result = await usecase(params);

            expect(result.isRight(), true);
            result.fold(
              (_) => fail('Left döndü, Right bekleniyor'),
              (text) => expect(text, expectedContent.trim()),
            );
          } finally {
            if (await tempFile.exists()) {
              await tempFile.delete();
            }
          }
        },
      );

      test(
        'başında ve sonunda boşluk olan txt dosyasında metni trim etmeli',
        () async {
          final tempDir = Directory.systemTemp;
          final tempFile = File(
            '${tempDir.path}/extract_text_trim_test_${DateTime.now().millisecondsSinceEpoch}.txt',
          );

          const rawContent = '  \n  Trim edilecek metin  \n  ';
          await tempFile.writeAsString(rawContent);

          try {
            final params = ExtractTextFromFileParams(
              filePath: tempFile.path,
              fileExtension: 'txt',
            );

            final result = await usecase(params);

            expect(result.isRight(), true);
            result.fold(
              (_) => fail('Left döndü, Right bekleniyor'),
              (text) => expect(text, 'Trim edilecek metin'),
            );
          } finally {
            if (await tempFile.exists()) {
              await tempFile.delete();
            }
          }
        },
      );

      test(
        'TXT büyük harf extension ile de çalışmalı',
        () async {
          final tempDir = Directory.systemTemp;
          final tempFile = File(
            '${tempDir.path}/extract_text_upper_test_${DateTime.now().millisecondsSinceEpoch}.txt',
          );

          const expectedContent = 'Büyük harf extension testi';
          await tempFile.writeAsString(expectedContent);

          try {
            final params = ExtractTextFromFileParams(
              filePath: tempFile.path,
              fileExtension: 'TXT',
            );

            final result = await usecase(params);

            expect(result.isRight(), true);
            result.fold(
              (_) => fail('Left döndü, Right bekleniyor'),
              (text) => expect(text, expectedContent),
            );
          } finally {
            if (await tempFile.exists()) {
              await tempFile.delete();
            }
          }
        },
      );
    });

    group('TXT boş dosya', () {
      test(
        'boş txt dosyası için Left(ServerFailure) döndürmeli',
        () async {
          final tempDir = Directory.systemTemp;
          final tempFile = File(
            '${tempDir.path}/extract_text_empty_test_${DateTime.now().millisecondsSinceEpoch}.txt',
          );

          await tempFile.writeAsString('');

          try {
            final params = ExtractTextFromFileParams(
              filePath: tempFile.path,
              fileExtension: 'txt',
            );

            final result = await usecase(params);

            expect(result.isLeft(), true);
            result.fold(
              (failure) {
                expect(failure, isA<ServerFailure>());
                expect(failure.message, 'Dosyadan metin çıkarılamadı');
              },
              (_) => fail('Right döndü, Left bekleniyor'),
            );
          } finally {
            if (await tempFile.exists()) {
              await tempFile.delete();
            }
          }
        },
      );

      test(
        'yalnızca boşluk ve newline içeren txt dosyası için Left(ServerFailure) döndürmeli',
        () async {
          final tempDir = Directory.systemTemp;
          final tempFile = File(
            '${tempDir.path}/extract_text_whitespace_test_${DateTime.now().millisecondsSinceEpoch}.txt',
          );

          await tempFile.writeAsString('   \n\n   \t   \n');

          try {
            final params = ExtractTextFromFileParams(
              filePath: tempFile.path,
              fileExtension: 'txt',
            );

            final result = await usecase(params);

            expect(result.isLeft(), true);
            result.fold(
              (failure) {
                expect(failure, isA<ServerFailure>());
                expect(failure.message, 'Dosyadan metin çıkarılamadı');
              },
              (_) => fail('Right döndü, Left bekleniyor'),
            );
          } finally {
            if (await tempFile.exists()) {
              await tempFile.delete();
            }
          }
        },
      );
    });

    group('var olmayan dosya', () {
      test(
        'var olmayan txt dosyası için Left(ServerFailure) döndürmeli',
        () async {
          const params = ExtractTextFromFileParams(
            filePath: '/var/olmayan/dizin/olmayan_dosya.txt',
            fileExtension: 'txt',
          );

          final result = await usecase(params);

          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (_) => fail('Right döndü, Left bekleniyor'),
          );
        },
      );

      test(
        'var olmayan pdf dosyası için Left(ServerFailure) döndürmeli',
        () async {
          const params = ExtractTextFromFileParams(
            filePath: '/var/olmayan/dizin/olmayan_dosya.pdf',
            fileExtension: 'pdf',
          );

          final result = await usecase(params);

          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (_) => fail('Right döndü, Left bekleniyor'),
          );
        },
      );
    });
  });
}
