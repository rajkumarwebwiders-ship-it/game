import 'package:flutter/material.dart';

import '../models/game_model.dart';
import '../utils/extensions/size_extension.dart'; // Import the new extension

/// [GameListItem] is a stylized card widget that displays details of a single game.
class GameListItem extends StatelessWidget {
  final GameModel game; // the game data to display

  const GameListItem({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Sport Badge and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    game.sport,
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  game.date,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            12.height, // Using extension for spacing
            // Teams: Team A vs Team B
            Text(
              '${game.teamA} vs ${game.teamB}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            8.height,

            // Info: Location and Time
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                4.width, // Using extension for spacing
                Text(game.location, style: theme.textTheme.bodyMedium),
                const Spacer(),
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                4.width,
                Text(game.time, style: theme.textTheme.bodyMedium),
              ],
            ),
            8.height,

            // Footer: Grade
            Text(
              'Grade: ${game.grade}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
