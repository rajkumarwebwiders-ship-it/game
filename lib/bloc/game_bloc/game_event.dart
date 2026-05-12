import 'package:equatable/equatable.dart';
import '../../models/game_model.dart';

/// [GameEvent] is the base class for all game-related events.
abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

/// [SaveGameEvent] is triggered when a user submits the game creation form.
class SaveGameEvent extends GameEvent {
  final GameModel game; // The game data to be saved

  const SaveGameEvent(this.game);

  @override
  List<Object?> get props => [game];
}

/// [LoadGamesEvent] starts the stream subscription for the game list.
class LoadGamesEvent extends GameEvent {}

/// [UpdateGamesEvent] is triggered when new data arrives from the Firestore stream.
class UpdateGamesEvent extends GameEvent {
  final List<GameModel> games; // The list of games received from the stream

  const UpdateGamesEvent(this.games);

  @override
  List<Object?> get props => [games];
}

/// [LoadMetadataEvent] fetches the list of sports and grades from Firestore.
class LoadMetadataEvent extends GameEvent {}
