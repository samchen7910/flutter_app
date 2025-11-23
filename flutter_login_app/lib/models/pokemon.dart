class Pokemon {
  final String name;
  final String detailUrl;
  PokemonDetail? detail;
  bool? isLoaded;

  Pokemon({
    required this.name,
    required this.detailUrl,
    this.isLoaded,
    this.detail,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(name: json['name'], detailUrl: json['url']);
  }
}

class PokemonDetail {
  final String sprite;
  final int height;
  final int weight;
  const PokemonDetail({
    required this.height,
    required this.weight,
    required this.sprite,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    return PokemonDetail(
      sprite: json['sprites']['front_default'],
      height: json['height'],
      weight: json['weight'],
    );
  }
}
