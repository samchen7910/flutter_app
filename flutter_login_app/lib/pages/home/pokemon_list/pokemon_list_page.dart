import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_app/pages/home/home_controller.dart';
import 'package:flutter_login_app/models/pokemon.dart';

import '../home_state.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key, required this.username});
  final String? username;

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

  Future<void> _onRefresh() async {
    await context.read<HomeController>().refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: BlocBuilder<HomeController, HomeState>(
        builder: (context, state) {
          if (state is DataHomeState) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Logged-in Usernames: ${widget.username}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: state.pokemonList.length,
                            itemBuilder: (context, index) {
                              if (index == state.pokemonList.length &&
                                  !state.hasReachedMax) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (index >= state.pokemonList.length) {
                                return const SizedBox.shrink();
                              }

                              final pokemon = state.pokemonList[index];
                              return PokemonCell(
                                pokemon: pokemon,
                                itemIndex: index,
                                controller: context.read<HomeController>.call(),
                              );
                            },
                          ),
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
                ),
              ],
            );
          } else if (state is ErrorHomeState) {
            return Center(
              child: Text(
                state.error,
                style: TextStyle(color: Colors.red[700], fontSize: 16),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class PokemonCell extends StatelessWidget {
  const PokemonCell({
    super.key,
    required this.pokemon,
    required this.itemIndex,
    required this.controller,
  });
  final Pokemon pokemon;
  final int itemIndex;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.loadDetail(pokemon.detailUrl, itemIndex),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
            leading: CircularProgressIndicator(),
            title: Text(pokemon.name),
          );
        }
        if (snapshot.hasError) {
          return Text("Error loading image");
        }

        final imageUrl = controller.items[itemIndex].detail?.sprite ?? '';
        return ListTile(
          leading: Image.network(imageUrl),
          title: Text(pokemon.name),
          onTap: () {
            Navigator.pushNamed(context, '/detail', arguments: pokemon);
          },
        );
      },
    );
  }
}
