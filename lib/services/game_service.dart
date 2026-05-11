import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/game_model.dart';

class GameService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'games';

  Future<void> saveGame(GameModel game) async {
    try {
      await _firestore.collection(_collection).add(game.toMap());
    } catch (e) {
      rethrow;
    }
  }
}
