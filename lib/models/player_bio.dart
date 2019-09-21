import 'package:flutter/foundation.dart';

class PlayerBio {
  String id;
  String name;
  int points;
  DateTime date;
  dynamic emoji;
  Map<String , List<String>> achievements;

  PlayerBio({
    @required this.id,
    @required this.name,
    @required this.points,
    this.date,
    this.emoji,
    this.achievements
  });
}