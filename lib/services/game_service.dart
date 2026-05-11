import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/game_model.dart';

/// [GameService] handles all Firestore database interactions for games.
class GameService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
  final String _collection = 'games'; // Name of the Firestore collection

  // Saves a new game document to the Firestore collection
  Future<void> saveGame(GameModel game) async {
    try {
      await _firestore.collection(_collection).add(game.toMap());
    } catch (e) {
      rethrow;
    }
  }
}
