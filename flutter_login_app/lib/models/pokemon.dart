import 'package:flutter_login_app/models/pokemon_detail.dart';

class Pokemon {
  Pokemon({
    required this.name,
    required this.detailUrl,
    this.isLoaded,
    this.detail,
  });

  final String name;
  final String detailUrl;
  PokemonDetail? detail;
  bool? isLoaded;

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(name: json['name'], detailUrl: json['url']);
  }
}
