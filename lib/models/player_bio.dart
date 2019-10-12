import 'package:flutter/foundation.dart';

class PlayerBio {
  String id;
  String name;
  int points;
  DateTime date;
  dynamic emoji;
  Map<String , List<String>> achievements;

  PlayerBio({
    @required this.name,
    @required this.emoji,
    this.id,
    this.points,
    this.date,
    this.achievements
  });
}