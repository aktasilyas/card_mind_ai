import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_keys.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/flashcard_generation_model.dart';

abstract class AiCardRemoteDatasource {
  Future<List<FlashcardGenerationModel>> generateCards(
    String text,
    int count,
  );
}

@LazySingleton(as: AiCardRemoteDatasource)
class AiCardRemoteDatasourceImpl implements AiCardRemoteDatasource {
  AiCardRemoteDatasourceImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<List<FlashcardGenerationModel>> generateCards(
    String text,
    int count,
  ) async {
    try {
      final prompt = await rootBundle.loadString(
        'assets/prompts/card_generation_prompt.txt',
      );

      final response = await _dioClient.dio.post<Map<String, dynamic>>(
        '/chat/completions',
        options: Options(
          headers: {'Authorization': 'Bearer ${ApiKeys.openAiKey}'},
        ),
        data: {
          'model': AppConstants.openAiModel,
          'messages': [
            {'role': 'system', 'content': prompt},
            {
              'role': 'user',
              'content':
                  'Şu metinden $count adet flashcard üret:\n\n$text',
            },
          ],
          'temperature': 0.7,
        },
      );

      final content =
          response.data!['choices'][0]['message']['content'] as String;

      final jsonContent = content.trim();
      final List<dynamic> cardsJson =
          json.decode(jsonContent) as List<dynamic>;

      return cardsJson
          .map(
            (e) => FlashcardGenerationModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw const NetworkException(message: 'İnternet bağlantısı bulunamadı');
      }
      throw ServerException(
        message: e.response?.statusMessage ?? 'Sunucu hatası',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
