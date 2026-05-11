import 'package:cloud_firestore/cloud_firestore.dart';

/// [GameModel] represents the data structure of a game.
class GameModel {
  final String? id; // Document ID from Firestore
  final String date; // Game date (yyyy-MM-dd)
  final String time; // Game time (HH:mm)
  final String location; // Venue of the game
  final String sport; // Type of sport (e.g., Camogie)
  final String grade; // Player grade (e.g., U14)
  final String teamA; // First team name
  final String teamB; // Second team name
  final String status; // Game status (default: "open")
  final DateTime createdAt; // Timestamp of when the game was created

  GameModel({
    this.id,
    required this.date,
    required this.time,
    required this.location,
    required this.sport,
    required this.grade,
    required this.teamA,
    required this.teamB,
    this.status = "open",
    required this.createdAt,
  });

  // Converts the model to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'time': time,
      'location': location,
      'sport': sport,
      'grade': grade,
      'teamA': teamA,
      'teamB': teamB,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Creates a model from a Firestore document map
  factory GameModel.fromMap(Map<String, dynamic> map, String documentId) {
    return GameModel(
      id: documentId,
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      location: map['location'] ?? '',
      sport: map['sport'] ?? '',
      grade: map['grade'] ?? '',
      teamA: map['teamA'] ?? '',
      teamB: map['teamB'] ?? '',
      status: map['status'] ?? 'open',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
