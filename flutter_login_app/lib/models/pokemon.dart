import 'package:flutter_login_app/models/pokemon_detail.dart';

class Pokemon {
  Pokemon({required this.name, required this.url, this.isLoaded, this.detail});

  final String name;
  final String url;
  PokemonDetail? detail;
  bool? isLoaded;

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(name: json['name'], url: json['url']);
  }

  Map<String, dynamic> toJson() => {'name': name, 'url': url};

}
