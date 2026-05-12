import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/game_service.dart';
import 'game_event.dart';
import 'game_state.dart';

/// [GameBloc] manages the business logic for creating and listing games.
class GameBloc extends Bloc<GameEvent, GameState> {
  final GameService _gameService; // Service for Firestore interactions
  StreamSubscription? _gamesSubscription; // Subscription to the Firestore stream

  GameBloc({required GameService gameService})
      : _gameService = gameService,
        super(const GameInitial()) {
    on<SaveGameEvent>(_onSaveGame);
    on<LoadGamesEvent>(_onLoadGames);
    on<UpdateGamesEvent>(_onUpdateGames);
    on<LoadMetadataEvent>(_onLoadMetadata);
  }

  // Handles the logic for the SaveGameEvent
  Future<void> _onSaveGame(SaveGameEvent event, Emitter<GameState> emit) async {
    final sports = state.sports;
    final grades = state.grades;
    
    emit(GameLoading(sports: sports, grades: grades));
    try {
      await _gameService.saveGame(event.game);
      emit(GameSuccess(sports: sports, grades: grades));
    } catch (e) {
      emit(GameFailure(e.toString(), sports: sports, grades: grades));
    }
  }

  // Initializes the stream subscription for real-time game list
  Future<void> _onLoadGames(LoadGamesEvent event, Emitter<GameState> emit) async {
    emit(GameLoading(sports: state.sports, grades: state.grades));
    await _gamesSubscription?.cancel();
    _gamesSubscription = _gameService.getGamesStream().listen(
      (games) => add(UpdateGamesEvent(games)),
      onError: (error) => emit(GameFailure(error.toString(), sports: state.sports, grades: state.grades)),
    );
  }

  // Emits the GamesLoaded state with the new list of games
  void _onUpdateGames(UpdateGamesEvent event, Emitter<GameState> emit) {
    emit(GamesLoaded(event.games, sports: state.sports, grades: state.grades));
  }

  // Fetches sports and grades metadata for dropdowns
  Future<void> _onLoadMetadata(LoadMetadataEvent event, Emitter<GameState> emit) async {
    try {
      final results = await Future.wait([
        _gameService.getSports(),
        _gameService.getGrades(),
      ]);
      emit(MetadataLoaded(sports: results[0], grades: results[1]));
    } catch (e) {
      emit(GameFailure('Failed to load dropdown data', sports: state.sports, grades: state.grades));
    }
  }

  @override
  Future<void> close() {
    _gamesSubscription?.cancel();
    return super.close();
  }
}
