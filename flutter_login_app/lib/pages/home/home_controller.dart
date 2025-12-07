import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_app/models/pokemon_detail.dart';
import 'package:flutter_login_app/pages/home/home_state.dart';
import 'package:flutter_login_app/models/pokemon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends Cubit<HomeState> {
  List<Pokemon> items = [];
  // Frist page
  int currentOffset = 0;
  int maxCount = 0;
  bool isLocalDataLoaded = false;

  HomeController() : super(InitHome());

  Future refreshData() async {
    currentOffset = 0;
    maxCount = 0;
    items = [];
    fetchData();
  }

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
        final localList = await getListLocally();

        // Load locally
        if (localList.isNotEmpty && !isLocalDataLoaded) {
          maxCount = 100000000;
          currentOffset += localList.length;
          items.addAll(localList);
          print("running here ${{items.length}}");

          isLocalDataLoaded = true;
          // Displays values
          emit(
            DataHomeState(
              pokemonList: items,
              hasReachedMax: false,
              maxCount: 0,
              isLoading: false,
            ),
          );
        } else {
          final response = await Dio().get(
            'https://pokeapi.co/api/v2/pokemon/?limit=20&offset=$currentOffset',
          );

          List<Pokemon> pokemons = [];

          // Decode data from response
          final data = response.data;
          final results = data['results'] as List<dynamic>? ?? [];

          for (var value in results) {
            final pkm = Pokemon(name: value['name'], url: value['url']);
            pkm.isLoaded = false;
            pkm.detail = null;
            pokemons.add(pkm);
          }

          // Setup values
          maxCount = data['count'] ?? 0;
          currentOffset += results.length;
          items.addAll(pokemons);

          storeListLocally(items);
          // Displays values
          emit(
            DataHomeState(
              pokemonList: items,
              hasReachedMax: false,
              maxCount: data['count'],
              isLoading: false,
            ),
          );
        }
      } catch (error) {
        // Displays Error
        emit(ErrorHomeState(error: error.toString()));
      }
    }
  }

  Future loadDetail(String url, int index) async {
    final detail = await getDetailLocally(items[index].name);

    if (detail != null) {
      items[index].detail = detail;
      items[index].isLoaded = true;
    } else {
      final isLoaded = items[index].isLoaded;

      // Only load 1 time
      if (isLoaded == false) {
        try {
          final response = await Dio().get(url);
          final data = response.data;

          final detail = PokemonDetail.fromJson(data);

          items[index].detail = detail;
          items[index].isLoaded = true;
          storeDetailLocally(detail, items[index].name);
        } catch (error) {
          emit(ErrorHomeState(error: error.toString()));
        }
      }
    }
  }

  // Local Database Logic 
  Future<void> storeListLocally(List<Pokemon> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = items.map((pkm) => pkm.toJson()).toList();
    prefs.setString('pokemons', jsonEncode(jsonList));
  }

  Future<List<Pokemon>> getListLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('pokemons');
    // print("jsonString $jsonString");

    if (jsonString == null) return [];
    final List decoded = jsonDecode(jsonString);

    // final result2 = decoded.map((e) => print("decoded $e")).toList();

    final result = decoded
        .map((e) => Pokemon(name: e['name'], url: e['url']))
        .toList();
    // print("result $result");
    return result;
  }

  Future<void> storeDetailLocally(PokemonDetail item, String name) async {
    final prefs = await SharedPreferences.getInstance();
    final json = item.toJsonDetail();
    prefs.setString(name, jsonEncode(json));
  }

  Future<PokemonDetail?> getDetailLocally(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(name);
    // print("jsonString $jsonString");

    if (jsonString == null) return null;
    final decoded = jsonDecode(jsonString) as dynamic;

    // final result2 = decoded.map((e) => print("decoded $e")).toList();

    final result = PokemonDetail(
      height: decoded['height'],
      sprite: decoded['sprite'],
      weight: decoded['weight'],
    );
    return result;
  }
}
