import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_app/pages/home/home_state.dart';
import 'package:flutter_login_app/models/pokemon.dart';

class HomeController extends Cubit<HomeState> {
  List<Pokemon> items = [];
  // Frist page
  int currentOffset = 0;
  int maxCount = 0;

  HomeController() : super(InitHome());

  Future fetchData() async {
    if (state is DataHomeState && (state as DataHomeState).isLoading) {
      return;
    }

    if (currentOffset < maxCount || maxCount == 0) {
      emit(
        DataHomeState(
          pokemonList: items,
          hasReachedMax: items.length >= maxCount,
          maxCount: maxCount,
          isLoading: true,
        ),
      );

      try {
        final response = await Dio().get(
          'https://pokeapi.co/api/v2/pokemon/?limit=20&offset=${currentOffset}',
        );

        List<Pokemon> pokemons = [];

        // Decode data from response
        final data = response.data;
        final results = data['results'] as List<dynamic>? ?? [];

        for (var value in results) {
          final pkm = Pokemon.fromJson(value);
          pokemons.add(pkm);
        }

        // Setup values
        maxCount = data['count'] ?? 0;
        currentOffset += results.length;
        items.addAll(pokemons);

        // Displays values
        emit(
          DataHomeState(
            pokemonList: items,
            hasReachedMax: false,
            maxCount: data['count'],
            isLoading: false,
          ),
        );
      } catch (error) {
        // Displays Error
        emit(ErrorHomeState(error: error.toString()));
      }
    }
  }

  Future loadDetail(String url, int index) async {
    final isLoaded = items[index].isLoaded;

    // Only load 1 time
    if (isLoaded == true) {
      print('pokemon : loaded');
    } else {
      try {
        final response = await Dio().get(url);
        final data = response.data;

        final detail = PokemonDetail.fromJson(data);
        items[index].detail = detail;
        items[index].isLoaded = true;
        print('pokemon : $detail');
      } catch (error) {
        emit(ErrorHomeState(error: error.toString()));
      }
    }
  }
}
