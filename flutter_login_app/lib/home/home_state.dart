import 'package:equatable/equatable.dart';
import '../models/pokemon.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class LoadingHomeState extends HomeState {}

class ErrorHomeState extends HomeState {
  final String error;

  const ErrorHomeState({required this.error});

  @override
  List<Object> get props => [error];
}

class DataHomeState extends HomeState {
  final List<Pokemon> pokemonList;
  final bool hasReachedMax;
  final int maxCount;
  const DataHomeState({
    required this.pokemonList,
    required this.hasReachedMax,
    required this.maxCount,
  });

  @override
  List<Object> get props => [pokemonList, hasReachedMax, maxCount];
}
