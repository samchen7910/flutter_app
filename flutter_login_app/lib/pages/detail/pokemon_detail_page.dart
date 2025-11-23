import 'package:flutter/material.dart';
import 'package:flutter_login_app/models/pokemon.dart';

class PokemonDetailPage extends StatelessWidget {
  const PokemonDetailPage({super.key, required this.pokemon});
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pokemon Details"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // Centered image
              Center(
                child: Image.network(
                  pokemon.detail?.sprite ?? '',
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 20),

              // 3 leading (left-aligned) text lines
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pokemon.name.toUpperCase(),
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Weight: ${pokemon.detail?.weight}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Height: ${pokemon.detail?.height}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
