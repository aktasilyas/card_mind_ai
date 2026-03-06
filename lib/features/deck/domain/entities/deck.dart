class Deck {
  const Deck({
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

  Deck copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    int? cardCount,
  }) {
    return Deck(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      cardCount: cardCount ?? this.cardCount,
    );
  }
}
