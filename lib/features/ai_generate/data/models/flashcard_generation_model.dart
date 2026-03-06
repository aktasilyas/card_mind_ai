class FlashcardGenerationModel {
  const FlashcardGenerationModel({required this.front, required this.back});

  final String front;
  final String back;

  factory FlashcardGenerationModel.fromJson(Map<String, dynamic> json) {
    return FlashcardGenerationModel(
      front: json['front'] as String,
      back: json['back'] as String,
    );
  }
}
