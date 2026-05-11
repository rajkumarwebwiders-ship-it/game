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
