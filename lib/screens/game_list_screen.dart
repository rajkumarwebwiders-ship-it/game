import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/game_bloc/game_bloc.dart';
import '../bloc/game_bloc/game_event.dart';
import '../bloc/game_bloc/game_state.dart';
import '../services/game_service.dart';
import '../widgets/game_list_item.dart'; // import the new widget

/// [GameListScreen] displays a real-time list of all created games.
class GameListScreen extends StatelessWidget {
  const GameListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) =>
          GameBloc(gameService: GameService())..add(LoadGamesEvent()),
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(title: const Text('All Games')),
        body: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            if (state is GameLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GameFailure) {
              return Center(
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is GamesLoaded) {
              if (state.games.isEmpty) {
                return const Center(child: Text('No games created yet.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.games.length,
                itemBuilder: (context, index) {
                  // Using the new GameListItem widget
                  return GameListItem(game: state.games[index]);
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
