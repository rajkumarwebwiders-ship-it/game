import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/game_model.dart';

/// [GameService] handles all Firestore database interactions for games.
class GameService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
  final String _collection = 'games'; // Name of the Firestore collection

  // Saves a new game document to the Firestore collection with enhanced exception handling
  Future<void> saveGame(GameModel game) async {
    try {
      await _firestore.collection(_collection).add(game.toMap());
    } on FirebaseException catch (e) {
      // Catch specific Firebase exceptions and throw a human-readable message
      throw _handleFirebaseException(e);
    } catch (e) {
      // Catch any other generic exceptions
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Maps technical Firebase error codes to user-friendly messages
  String _handleFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'Database access denied. Ensure the Firestore API is enabled in your Google Cloud Console and rules are configured.';
      case 'unavailable':
        return 'Service is currently unavailable. Please check your internet connection and try again.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'Database error (${e.code}): ${e.message}';
    }
  }
}
