class PokemonDetail {
  const PokemonDetail({
    required this.height,
    required this.weight,
    required this.sprite,
  });

  final String sprite;
  final int height;
  final int weight;

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    return PokemonDetail(
      sprite:
          json['sprites']['front_default'] ??
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
      height: json['height'] as int,
      weight: json['weight'] as int,
    );
  }

    Map<String, dynamic> toJsonDetail() => {'sprite': sprite, 'weight': weight, 'height': height};
}
