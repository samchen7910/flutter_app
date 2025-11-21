import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_app/home/home_controller.dart';
import 'package:flutter_login_app/models/pokemon.dart';

import '../home_state.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key, required this.username});
  final String username;

  @override
  State<PokemonListPage> createState() => _PokemonListPage();
}

class _PokemonListPage extends State<PokemonListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // Call controller to load more
      context.read<HomeController>().fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: BlocBuilder<HomeController, HomeState>(
        builder: (context, state) {
          if (state is LoadingHomeState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DataHomeState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Logged-in Usernames: ${widget.username}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: state.pokemonList.length,
                      itemBuilder: (context, index) {
                        if (index == state.pokemonList.length &&
                            !state.hasReachedMax) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (index >= state.pokemonList.length) {
                          return const SizedBox.shrink();
                        }

                        final pokemon = state.pokemonList[index];
                        return PokemonPage(
                          pokemon: pokemon,
                          pokedexNumber: index + 1,
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Logout"),
                  ),
                ],
              ),
            );
          } else if (state is ErrorHomeState) {
            return Text(state.error);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class PokemonPage extends StatefulWidget {
  const PokemonPage({
    super.key,
    required this.pokemon,
    required this.pokedexNumber,
  });
  final Pokemon pokemon;
  final int pokedexNumber;

  @override
  State<PokemonPage> createState() => _PokemonPage();
}

class _PokemonPage extends State<PokemonPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // ASK: Why does this func get call?
        final controller = HomeController();
        controller.loadDetail(widget.pokemon.detailUrl);
        return controller;
      },
      child: ListTile(
        leading: Image.network(
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${widget.pokedexNumber}.png',
        ),
        title: Text(widget.pokemon.name),
      ),
    );
  }
}
