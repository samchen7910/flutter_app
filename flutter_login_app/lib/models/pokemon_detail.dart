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
      sprite: json['sprites']['front_default'],
      height: json['height'],
      weight: json['weight'],
    );
  }
}
