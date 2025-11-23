import 'package:equatable/equatable.dart';
import '../../models/pokemon.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class InitHome extends HomeState {}

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
  final bool isLoading;
  const DataHomeState({
    required this.pokemonList,
    required this.hasReachedMax,
    required this.maxCount,
    required this.isLoading,
  });

  @override
  List<Object> get props => [pokemonList, hasReachedMax, maxCount, isLoading];
}
