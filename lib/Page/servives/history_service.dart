import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class HistoryEntry {
  final String date;
  final String exercise;
  final int reps;
  final int durationMinutes;

  HistoryEntry({
    required this.date,
    required this.exercise,
    required this.reps,
    this.durationMinutes = 0,
  });

  Map<String, dynamic> toJson() => {
    'date': date,
    'exercise': exercise,
    'reps': reps,
    'durationMinutes': durationMinutes,
  };

  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
    date: json['date'] as String,
    exercise: json['exercise'] as String,
    reps: json['reps'] as int,
    durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
  );
}

class HistoryService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  DatabaseReference get _historyRef {
    if (_userId == null) throw Exception("User not logged in");
    return _database.ref('users/$_userId/history');
  }

  Future<void> saveSession(String exercise, int reps, {int duration = 0}) async {
    if (reps == 0 || _userId == null) return;
    
    final entry = HistoryEntry(
      date: DateTime.now().toIso8601String(),
      exercise: exercise,
      reps: reps,
      durationMinutes: duration,
    );
    
    await _historyRef.push().set(entry.toJson());
  }

  Future<List<HistoryEntry>> getHistory() async {
    if (_userId == null) return [];
    
    final snapshot = await _historyRef.get();
    if (!snapshot.exists) return [];

    final Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
    final List<HistoryEntry> history = [];
    
    data.forEach((key, value) {
      history.add(HistoryEntry.fromJson(Map<String, dynamic>.from(value as Map)));
    });

    // Trier par date décroissante
    history.sort((a, b) => b.date.compareTo(a.date));
    
    return history;
  }

  Future<void> clearHistory() async {
    if (_userId == null) return;
    await _historyRef.remove();
  }
}
