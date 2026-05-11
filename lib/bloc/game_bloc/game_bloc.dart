import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/game_service.dart';
import 'game_event.dart';
import 'game_state.dart';

/// The [GameBloc] manages the business logic for creating a game.
///
/// Why use BLoC?
/// 1. **Separation of Concerns**: UI code doesn't need to know about Firestore or data processing.
/// 2. **Testability**: Business logic can be tested independently of the UI.
/// 3. **Predictability**: State transitions are explicit and handled in one place.
/// 4. **Reusability**: The logic can be reused across different screens or components.
class GameBloc extends Bloc<GameEvent, GameState> {
  final GameService _gameService;

  GameBloc({required GameService gameService})
    : _gameService = gameService,
      super(GameInitial()) {
    // Register the event handler for SaveGameEvent
    on<SaveGameEvent>(_onSaveGame);
  }

  /// Handles the [SaveGameEvent] by interacting with [GameService].
  Future<void> _onSaveGame(SaveGameEvent event, Emitter<GameState> emit) async {
    emit(GameLoading());
    try {
      await _gameService.saveGame(event.game);
      emit(GameSuccess());
    } catch (e) {
      // Emit failure state with the error message
      emit(GameFailure(e.toString()));
    }
  }
}
