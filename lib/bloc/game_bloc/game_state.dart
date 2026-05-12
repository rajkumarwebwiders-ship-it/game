import 'package:equatable/equatable.dart';
import '../../models/game_model.dart';

/// [GameState] is the base class for all UI states in the game flow.
abstract class GameState extends Equatable {
  final List<String> sports; // list of available sports
  final List<String> grades; // list of available grades

  const GameState({
    this.sports = const [],
    this.grades = const [],
  });

  @override
  List<Object?> get props => [sports, grades];
}

/// [GameInitial] is the state when the app is first loaded.
class GameInitial extends GameState {
  const GameInitial() : super();
}

/// [GameLoading] is the state while saving or fetching data.
class GameLoading extends GameState {
  const GameLoading({super.sports, super.grades});
}

/// [GameSuccess] is the state after a successful save operation.
class GameSuccess extends GameState {
  const GameSuccess({super.sports, super.grades});
}

/// [GameFailure] is the state when an error occurs.
class GameFailure extends GameState {
  final String message; // error message to display

  const GameFailure(this.message, {super.sports, super.grades});

  @override
  List<Object?> get props => [message, ...super.props];
}

/// [GamesLoaded] is emitted when the list of games is successfully fetched.
class GamesLoaded extends GameState {
  final List<GameModel> games; // list of retrieved games

  const GamesLoaded(this.games, {super.sports, super.grades});

  @override
  List<Object?> get props => [games, ...super.props];
}

/// [MetadataLoaded] is emitted when sports and grades are loaded for the dropdowns.
class MetadataLoaded extends GameState {
  const MetadataLoaded({required super.sports, required super.grades});
}
