import 'package:scoped_model/scoped_model.dart';
import 'package:tournament_app/models/player_bio.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';

class PlayerBioModel extends Model {
  List<PlayerBio> _playerBio = [];

  var logger = Logger(
      printer: PrettyPrinter(
    colors: true,
  ));

  int _selected;

  bool reminderAccepted;

  String userToken;

  String userID;

  void reminderAccepter(bool status) {
    reminderAccepted = status;

    notifyListeners();
  }

  void saveUserId(String userId) {
    userID = userId;

    notifyListeners();
  }

  String get getUserId {
    return userID;
  }

  void saveUserToken(String token) {
    userToken = token;

    notifyListeners();
  }

  String get getUserToken {
    return userToken;
  }

  List<PlayerBio> get getPlayers {
    return _playerBio;
  }

  Future<void> fetchPlayers(authUserId) {

    final reqUserId = authUserId != null ? authUserId : '';

    final url = 'https://slammers-7bbd0.firebaseio.com/users/$reqUserId/players.json?auth=$userToken';
    final List<PlayerBio> playersList = [];
    return http.get(url).then((response) {
      final result = json.decode(response.body) as Map<String, dynamic>;
      if (result != null && result.length > 0) {
        result.forEach((key, val) {

          playersList.add(PlayerBio(
            id: key,
            emoji: val['emoji'],
            name: val['name'],
            points: val['points'],
            date: DateTime.parse(val['date']),
            achievements: {
              'cup' : val['achievements']['cup'] != null ? [...val['achievements']['cup']] : [],
              'season' : val['achievements']['season'] != null ? [...val['achievements']['season']] : [],
            }
          ));
        });
      }

      _playerBio = playersList;

      sortPlayersByName();

      notifyListeners();
    });
  }

  int get length => _playerBio.length;

  Future<void> addPlayer(playerInfo, userId, [isUserAnonymous]) {
    final first = playerInfo['firstName'];
    final last = playerInfo['lastName'];

    final url =
        'https://slammers-7bbd0.firebaseio.com/users/$userId/players.json?auth=$userToken';

    final timeCreated = DateTime.now();
    print(isUserAnonymous);
    print('isUserAnonymous');

    return http
        .post(
      url,
      body: json.encode({
        "date": timeCreated.toString(),
        "name": first + ' ' + last,
        "points": 0,
        "emoji": '🏓',
        "achievements": {
          'cup': ['0'],
          'season': ['0'],
        }
      }),
    )
        .then((response) {
          print(json.decode(response.body));
          print('from user response');
      _playerBio.add(
        PlayerBio(
          date: DateTime.now(),
          name: first + ' ' + last,
          points: 0,
          id: isUserAnonymous ? (first + last) : json.decode(response.body)['name'],
          emoji: '🏓',
          achievements: {
            'cup': ['0'],
            'season': ['0'],
          },
        ),
      );
    }).catchError((err) => print('error creating player'));
  }

  void resetSeason() {
    _playerBio.forEach((player) {
      player.points = 0;
    });
    notifyListeners();
  }

  void sortPlayers() {
    _playerBio.sort((a, b) => a.name.compareTo(b.name));
    _playerBio.sort((a, b) => b.points.compareTo(a.points));
    // Then notify all the listeners.
    notifyListeners();
  }

    void sortPlayersByName() {
    _playerBio.sort((a, b) => a.name.compareTo(b.name));

    // Then notify all the listeners.
    notifyListeners();
  }

  int get selected => _selected;

  void selectPlayer(String id) {
    for (int i = 0; i < _playerBio.length; i++) {
      print(id);
      print(_playerBio[i].id);
      print('_playerBio[i].id');
      if (_playerBio[i].id == id) {
        _selected = i;
        notifyListeners();
        return;
      }
    }

    _selected = 0;
    notifyListeners();
  }

  Future<void> deletePlayer(String id, String deleteUserId) {
    final playerID = selectedPlayer.id;
    final existingPlayerIndex =
        _playerBio.indexWhere((selectedPlayer) => selectedPlayer.id == id);
    final existingPlayer = _playerBio[existingPlayerIndex];

    final url =
        'https://slammers-7bbd0.firebaseio.com/users/$deleteUserId/players/$playerID.json?auth=$userToken';

    _playerBio.removeWhere((selectedPlayer) => selectedPlayer.id == id);
    _playerBio.join(', ');
    notifyListeners();

    return http.delete(url).then((res) {
      if (res.statusCode >= 400) {
        _playerBio.insert(existingPlayerIndex, existingPlayer);
        notifyListeners();
      }
    });
  }

  Future<void> changePlayerPoints(int points, String pointsUserId) {
    final playerID = selectedPlayer.id;

    final url =
        'https://slammers-7bbd0.firebaseio.com/users/$pointsUserId/players/$playerID.json?auth=$userToken';

    return http.patch(url, body: json.encode(({"points": points}))).then((_) {
      selectedPlayer.points = points;
      notifyListeners();
    });
  }

  Future<void> changePlayerEmoji(String emoji, String emojiUserId) {
    final playerID = selectedPlayer.id;

    final url =
        'https://slammers-7bbd0.firebaseio.com/users/$emojiUserId/players/$playerID.json?auth=$userToken';

    return http.patch(url, body: json.encode(({"emoji": emoji}))).then((_) {
      selectedPlayer.emoji = emoji;
      notifyListeners();
    });
  }

  Future<void> setAchievement(String venue , String userID, int cupNum, String playerID) {

    
    List<Map<String, dynamic>> playerAchievements = _playerBio.map((player){
      if(player.id == playerID){

        return player.achievements;
      }
      return null;
    }).toList();

    Map<String, List> playerAchievementsList = playerAchievements.where((achievement) => achievement != null).toList()[0];

    print(playerAchievementsList);
    Map<String, List> achievements = {
      "cup" : playerAchievementsList['cup'] != null ? playerAchievementsList['cup'] : ['0'],
      "season" : playerAchievementsList['season'] != null ? playerAchievementsList['season'] : ['0'],
    };

    achievements[venue].add(cupNum.toString());

    final url = 'https://slammers-7bbd0.firebaseio.com/users/$userID/players/$playerID.json?auth=$userToken';
    return http.patch(url , body: json.encode({
         "achievements" :  achievements
    })).then((res){
            print('res from setting achievements');
            print(playerID);
            _playerBio.firstWhere((player){
            print(player.id);
              if(player.id == playerID){
                player.achievements[venue].add(cupNum.toString());
                notifyListeners();
              }
            });
    }).catchError((err){
      print(err);
      print('setting achievements err');
    });
  }

  PlayerBio get selectedPlayer => _playerBio[_selected];

  String findPlayerByName(String name){
    var normalizeName = name.split('\n').join(' ');

    return _playerBio.map((player){
      if(player.name == normalizeName){

        return player.id;
      }
      return '';
    }).toList().toString();
  }
}
