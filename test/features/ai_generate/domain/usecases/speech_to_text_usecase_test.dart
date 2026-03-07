import 'package:card_mind_ai/core/errors/failures.dart';
import 'package:card_mind_ai/features/ai_generate/domain/usecases/speech_to_text_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MockSpeechToText extends Mock implements SpeechToText {}

void main() {
  late MockSpeechToText mockSpeechToText;
  late SpeechToTextUseCase usecase;

  setUp(() {
    mockSpeechToText = MockSpeechToText();
    usecase = SpeechToTextUseCase(mockSpeechToText);
  });

  group('SpeechToTextUseCase', () {
    group('initialize', () {
      test(
        'mikrofon izni verilmediğinde Left(PermissionFailure) döndürmeli',
        () async {
          when(
            () => mockSpeechToText.initialize(
              onError: any(named: 'onError'),
            ),
          ).thenAnswer((_) async => false);

          final result = await usecase.initialize();

          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<PermissionFailure>());
              expect(
                failure.message,
                contains('Mikrofon izni verilmedi'),
              );
            },
            (_) => fail('Right döndü, Left(PermissionFailure) bekleniyor'),
          );
        },
      );

      test(
        'initialize exception fırlatırsa Left(ServerFailure) döndürmeli',
        () async {
          when(
            () => mockSpeechToText.initialize(
              onError: any(named: 'onError'),
            ),
          ).thenThrow(Exception('Beklenmedik hata'));

          final result = await usecase.initialize();

          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<ServerFailure>());
              expect(
                failure.message,
                contains('Speech recognition başlatılamadı'),
              );
            },
            (_) => fail('Right döndü, Left(ServerFailure) bekleniyor'),
          );
        },
      );

      test(
        'başarılı initialize durumunda Right(true) döndürmeli',
        () async {
          when(
            () => mockSpeechToText.initialize(
              onError: any(named: 'onError'),
            ),
          ).thenAnswer((_) async => true);

          final result = await usecase.initialize();

          expect(result.isRight(), true);
          result.fold(
            (_) => fail('Left döndü, Right(true) bekleniyor'),
            (value) => expect(value, true),
          );
        },
      );
    });

    group('startListening', () {
      test(
        'speech recognition kullanılabilir değilse Left(PermissionFailure) döndürmeli',
        () async {
          when(() => mockSpeechToText.isAvailable).thenReturn(false);

          final result = await usecase.startListening(
            onResult: (_) {},
          );

          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<PermissionFailure>());
              expect(
                failure.message,
                contains('Speech recognition kullanılabilir değil'),
              );
            },
            (_) => fail('Right döndü, Left(PermissionFailure) bekleniyor'),
          );
        },
      );

      test(
        'listen exception fırlatırsa Left(ServerFailure) döndürmeli',
        () async {
          when(() => mockSpeechToText.isAvailable).thenReturn(true);
          when(
            () => mockSpeechToText.listen(
              onResult: any(named: 'onResult'),
              localeId: any(named: 'localeId'),
            ),
          ).thenThrow(Exception('Dinleme hatası'));

          final result = await usecase.startListening(
            onResult: (_) {},
          );

          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<ServerFailure>());
              expect(
                failure.message,
                contains('Dinleme başlatılamadı'),
              );
            },
            (_) => fail('Right döndü, Left(ServerFailure) bekleniyor'),
          );
        },
      );

      test(
        'başarılı dinleme başlatıldığında Right(true) döndürmeli',
        () async {
          when(() => mockSpeechToText.isAvailable).thenReturn(true);
          when(
            () => mockSpeechToText.listen(
              onResult: any(named: 'onResult'),
              localeId: any(named: 'localeId'),
            ),
          ).thenAnswer((_) async {});

          final result = await usecase.startListening(
            onResult: (_) {},
          );

          expect(result.isRight(), true);
          result.fold(
            (_) => fail('Left döndü, Right(true) bekleniyor'),
            (value) => expect(value, true),
          );
        },
      );

      test(
        'onResult callback, final result geldiğinde tanınan metni iletmeli',
        () async {
          String? capturedText;

          when(() => mockSpeechToText.isAvailable).thenReturn(true);
          when(
            () => mockSpeechToText.listen(
              onResult: any(named: 'onResult'),
              localeId: any(named: 'localeId'),
            ),
          ).thenAnswer((invocation) async {
            final onResult = invocation.namedArguments[#onResult]
                as void Function(SpeechRecognitionResult);
            onResult(
              SpeechRecognitionResult(
                [
                  SpeechRecognitionWords('merhaba dünya', null, 1.0),
                ],
                true,
              ),
            );
          });

          await usecase.startListening(
            onResult: (text) => capturedText = text,
          );

          expect(capturedText, 'merhaba dünya');
        },
      );

      test(
        'onResult callback, final olmayan result için çağrılmamalı',
        () async {
          int callCount = 0;

          when(() => mockSpeechToText.isAvailable).thenReturn(true);
          when(
            () => mockSpeechToText.listen(
              onResult: any(named: 'onResult'),
              localeId: any(named: 'localeId'),
            ),
          ).thenAnswer((invocation) async {
            final onResult = invocation.namedArguments[#onResult]
                as void Function(SpeechRecognitionResult);
            onResult(
              SpeechRecognitionResult(
                [
                  SpeechRecognitionWords('ara sonuç', null, 0.8),
                ],
                false,
              ),
            );
          });

          await usecase.startListening(
            onResult: (_) => callCount++,
          );

          expect(callCount, 0);
        },
      );
    });

    group('stopListening', () {
      test(
        'başarılı durdurma sonrası son tanınan metni Right olarak döndürmeli',
        () async {
          when(() => mockSpeechToText.stop()).thenAnswer((_) async {});
          when(() => mockSpeechToText.lastRecognizedWords)
              .thenReturn('tanınan metin');

          final result = await usecase.stopListening();

          expect(result.isRight(), true);
          result.fold(
            (_) => fail('Left döndü, Right(metin) bekleniyor'),
            (text) => expect(text, 'tanınan metin'),
          );
        },
      );

      test(
        'dinleme sırasında hiç metin tanınmamışsa Right(boş string) döndürmeli',
        () async {
          when(() => mockSpeechToText.stop()).thenAnswer((_) async {});
          when(() => mockSpeechToText.lastRecognizedWords).thenReturn('');

          final result = await usecase.stopListening();

          expect(result.isRight(), true);
          result.fold(
            (_) => fail('Left döndü, Right(\'\') bekleniyor'),
            (text) => expect(text, ''),
          );
        },
      );

      test(
        'stop exception fırlatırsa Left(ServerFailure) döndürmeli',
        () async {
          when(() => mockSpeechToText.stop())
              .thenThrow(Exception('Durdurma hatası'));

          final result = await usecase.stopListening();

          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<ServerFailure>());
              expect(
                failure.message,
                contains('Dinleme durdurulamadı'),
              );
            },
            (_) => fail('Right döndü, Left(ServerFailure) bekleniyor'),
          );
        },
      );

      test(
        'stopListening çağrıldığında SpeechToText.stop() bir kez çağrılmalı',
        () async {
          when(() => mockSpeechToText.stop()).thenAnswer((_) async {});
          when(() => mockSpeechToText.lastRecognizedWords).thenReturn('');

          await usecase.stopListening();

          verify(() => mockSpeechToText.stop()).called(1);
        },
      );
    });

    group('cancel', () {
      test(
        'cancel çağrıldığında SpeechToText.cancel() çağrılmalı',
        () async {
          when(() => mockSpeechToText.cancel()).thenAnswer((_) async {});

          await usecase.cancel();

          verify(() => mockSpeechToText.cancel()).called(1);
        },
      );
    });

    group('isListening', () {
      test(
        'isListening SpeechToText.isListening değerini yansıtmalı',
        () {
          when(() => mockSpeechToText.isListening).thenReturn(true);
          expect(usecase.isListening, true);

          when(() => mockSpeechToText.isListening).thenReturn(false);
          expect(usecase.isListening, false);
        },
      );
    });
  });
}
