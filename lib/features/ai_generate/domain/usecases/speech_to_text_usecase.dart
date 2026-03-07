import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../core/errors/failures.dart';

/// SpeechToText işlemlerini saran use case.
///
/// Bu use case [UseCase<T, Params>] base class'ını extend etmez çünkü
/// tek bir `call` metodu yerine `startListening` ve `stopListening` gibi
/// birden fazla yaşam döngüsü metodu içermektedir.
/// Tüm metodlar [Either<Failure, T>] pattern'ini takip eder.
@injectable
class SpeechToTextUseCase {
  SpeechToTextUseCase(this._speechToText);

  final SpeechToText _speechToText;

  bool get isListening => _speechToText.isListening;

  /// Mikrofon iznini kontrol eder ve speech recognition'ı başlatır.
  ///
  /// İzin verilmemişse [PermissionFailure], başlatma hatası olursa
  /// [ServerFailure] döndürür. Başarılı olursa [Right(true)] döndürür.
  Future<Either<Failure, bool>> initialize() async {
    try {
      final bool available = await _speechToText.initialize(
        onError: (_) {},
      );

      if (!available) {
        return const Left(
          PermissionFailure('Mikrofon izni verilmedi veya cihaz desteklenmiyor'),
        );
      }

      return const Right(true);
    } catch (e) {
      return Left(ServerFailure('Speech recognition başlatılamadı: $e'));
    }
  }

  /// Dinlemeyi başlatır ve tanınan metni [onResult] callback ile iletir.
  ///
  /// [initialize] daha önce başarıyla çağrılmamışsa [ServerFailure] döndürür.
  Future<Either<Failure, bool>> startListening({
    required void Function(String recognizedText) onResult,
    String localeId = 'tr_TR',
  }) async {
    try {
      if (!_speechToText.isAvailable) {
        return const Left(
          PermissionFailure('Speech recognition kullanılabilir değil'),
        );
      }

      await _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            onResult(result.recognizedWords);
          }
        },
        localeId: localeId,
      );

      return const Right(true);
    } catch (e) {
      return Left(ServerFailure('Dinleme başlatılamadı: $e'));
    }
  }

  /// Aktif dinlemeyi durdurur ve son tanınan metni döndürür.
  ///
  /// Dinleme sırasında hiç metin tanınmamışsa boş [String] döner.
  Future<Either<Failure, String>> stopListening() async {
    try {
      await _speechToText.stop();
      final String lastWords = _speechToText.lastRecognizedWords;
      return Right(lastWords);
    } catch (e) {
      return Left(ServerFailure('Dinleme durdurulamadı: $e'));
    }
  }

  /// Speech recognition oturumunu tamamen kapatır.
  Future<void> cancel() async {
    await _speechToText.cancel();
  }
}
