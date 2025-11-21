class Pokemon {
  final String name;
  final String detailUrl;
  const Pokemon({required this.name, required this.detailUrl});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(name: json['name'], detailUrl: json['url']);
  }
}

class PokemonDetail {
  final String sprite;
  const PokemonDetail({required this.sprite});
}
