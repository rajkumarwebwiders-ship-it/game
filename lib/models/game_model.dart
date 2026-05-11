import 'package:cloud_firestore/cloud_firestore.dart';

class GameModel {
  final String? id;
  final String date;
  final String time;
  final String location;
  final String sport;
  final String grade;
  final String teamA;
  final String teamB;
  final String status;
  final DateTime createdAt;

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
