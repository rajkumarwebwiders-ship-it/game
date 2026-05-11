import 'package:equatable/equatable.dart';
import '../../models/game_model.dart';

/// Abstract class representing events in the Game BLoC.
/// Using [Equatable] allows us to compare events efficiently.
abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered when the user wants to save a game.
class SaveGameEvent extends GameEvent {
  final GameModel game;

  const SaveGameEvent(this.game);

  @override
  List<Object?> get props => [game];
}
