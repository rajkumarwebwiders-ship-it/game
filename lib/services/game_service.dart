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
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Returns a stream of games ordered by creation date
  Stream<List<GameModel>> getGamesStream() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return GameModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Fetches the list of sports from the 'sports' collection
  Future<List<String>> getSports() async {
    try {
      final snapshot = await _firestore.collection('sports').get();
      return snapshot.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      // Fallback to a default list if collection is empty or fails
      return ['Camogie', 'Hurling', 'Football', 'Handball'];
    }
  }

  // Fetches the list of grades from the 'grades' collection
  Future<List<String>> getGrades() async {
    try {
      final snapshot = await _firestore.collection('grades').get();
      return snapshot.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      // Fallback to a default list if collection is empty or fails
      return ['U14', 'U16', 'Minor', 'Junior', 'Senior'];
    }
  }

  // Maps technical Firebase error codes to user-friendly messages
  String _handleFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'Database access denied. Ensure the Firestore API is enabled.';
      case 'unavailable':
        return 'Service is currently unavailable. Please check your connection.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'Database error (${e.code}): ${e.message}';
    }
  }
}
