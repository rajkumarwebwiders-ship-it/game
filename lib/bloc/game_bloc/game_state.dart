import 'package:equatable/equatable.dart';

/// Abstract class representing states in the Game BLoC.
/// BLoC states provide a predictable way to update the UI based on 
/// current application logic (e.g., Loading, Success, Error).
abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the screen is first loaded.
class GameInitial extends GameState {}

/// State emitted while the game is being saved to Firestore.
/// This allows the UI to show a loading indicator.
class GameLoading extends GameState {}

/// State emitted when the game has been successfully saved.
/// This can trigger a success message or navigation.
class GameSuccess extends GameState {}

/// State emitted when an error occurs during the save process.
/// Contains an error message to be displayed to the user.
class GameFailure extends GameState {
  final String message;

  const GameFailure(this.message);

  @override
  List<Object?> get props => [message];
}
