import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class ExtractTextFromFileParams {
  const ExtractTextFromFileParams({
    required this.filePath,
    required this.fileExtension,
  });

  final String filePath;
  final String fileExtension;
}

@injectable
class ExtractTextFromFile extends UseCase<String, ExtractTextFromFileParams> {
  ExtractTextFromFile();

  @override
  Future<Either<Failure, String>> call(
    ExtractTextFromFileParams params,
  ) async {
    try {
      final extension = params.fileExtension.toLowerCase();

      final String text;

      if (extension == 'pdf') {
        text = await _extractFromPdf(params.filePath);
      } else if (extension == 'txt') {
        text = await _extractFromTxt(params.filePath);
      } else {
        return Left(
          ServerFailure(
            'Desteklenmeyen dosya formatı: ${params.fileExtension}',
          ),
        );
      }

      if (text.isEmpty) {
        return const Left(ServerFailure('Dosyadan metin çıkarılamadı'));
      }

      return Right(text);
    } catch (e) {
      return Left(ServerFailure('Dosya okuma hatası: $e'));
    }
  }

  Future<String> _extractFromPdf(String filePath) async {
    final bytes = await File(filePath).readAsBytes();
    final document = PdfDocument(inputBytes: bytes);
    try {
      final extractor = PdfTextExtractor(document);
      final text = extractor.extractText();
      return text.trim();
    } finally {
      document.dispose();
    }
  }

  Future<String> _extractFromTxt(String filePath) async {
    final content = await File(filePath).readAsString();
    return content.trim();
  }
}
