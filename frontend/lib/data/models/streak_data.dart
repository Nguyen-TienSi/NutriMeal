import 'dart:convert';

class StreakData {
  StreakData({
    this.currentStreak,
    this.longestStreak,
  });

  int? currentStreak;
  int? longestStreak;

  factory StreakData.fromJson(Map<String, dynamic> json) {
    return StreakData(
      currentStreak: json['currentStreak'] as int,
      longestStreak: json['longestStreak'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
