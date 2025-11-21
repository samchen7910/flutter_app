import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_app/home/home_state.dart';
import 'package:flutter_login_app/models/pokemon.dart';

class HomeController extends Cubit<HomeState> {
  HomeController() : super(LoadingHomeState());

  List<Pokemon> items = [];
  // Frist page
  int currentOffset = 0;
  int maxCount = 0;

  Future fetchData() async {
    if (currentOffset < maxCount || maxCount == 0) {
      emit(LoadingHomeState());

      try {
        final response = await Dio().get(
          'https://pokeapi.co/api/v2/pokemon/?limit=20&offset=${currentOffset}',
        );

        List<Pokemon> pokemons = [];

        // Decode data from response
        final data = response.data;
        final results = data['results'];

        results.forEach((value) {
          final pkm = Pokemon.fromJson(value);
          pokemons.add(pkm);
        });

        // Setup values
        maxCount = data['count'] ?? 0;
        currentOffset += 20;
        items.addAll(pokemons);

        // Displays values
        emit(
          DataHomeState(
            pokemonList: items,
            hasReachedMax: false,
            maxCount: data['count'],
          ),
        );
      } catch (error) {
        // Displays Error
        emit(ErrorHomeState(error: error.toString()));
      }
    }
  }

  Future loadDetail(String url) async {
    print('running here');

    try {
      final response = await Dio().get(url);

      print(response.data['sprites']['front_default']);
      
    } catch (error) {
      // Displays Error
      emit(ErrorHomeState(error: error.toString()));
    }
  }
}
