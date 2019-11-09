import 'package:scoped_model/scoped_model.dart';
import 'package:tournament_app/models/player_bio.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';

class PlayerBioModel extends Model {
  List<PlayerBio> _playerBio = [
  ];

  var logger = Logger(printer: PrettyPrinter(colors: true,));

  int _selected;

  bool reminderAccepted;

  String userToken;

  bool reminderAccepter(bool status){
    return reminderAccepted = status;
  }

  void saveUserToken(String token) {
    userToken = token;
  }

  String get getUserToken {
    return userToken;
  }


  List<PlayerBio> get getPlayers{
    return _playerBio;
  }

    Future<void> fetchPlayers(){

    final url = 'https://slammers-7bbd0.firebaseio.com/players.json?auth=$userToken';
    final List<PlayerBio> playersList = [];
    return http.get(url).then((response){
      final result = json.decode(response.body) as Map<String , dynamic>;
      if(result != null && result.length > 0){
      result.forEach((key , val){
        playersList.add(PlayerBio(
          id: key,
          emoji: val['emoji'],
          name: val['name'],
          points: val['points'],
          date: DateTime.parse(val['date']),
        ));
      });
      }

      _playerBio = playersList;

      sortPlayers();

      notifyListeners();
    
    });
  }


  

  int get length => _playerBio.length;

  Future<void> addPlayer(playerInfo) {
    final first = playerInfo['firstName'];
    final last = playerInfo['lastName'];

    print(userToken);
    print('add player userToken');

    final url = 'https://slammers-7bbd0.firebaseio.com/players.json?auth=$userToken';

    final timeCreated = DateTime.now();

    return http
        .post(
      url,
      body: json.encode({
        "date": timeCreated.toString(),
        "name": first + ' ' + last,
        "points": 0,
        "emoji": '🏓',
        "achievements": {
          'cup': [],
          'season': [],
        }
      }),
    )
    .then((response) {
      _playerBio.add(
        PlayerBio(
          date: DateTime.now(),
          name: first + ' ' + last,
          points: 0,
          id: json.decode(response.body)['name'],
          emoji: '🏓',
          achievements: {
            'cup': [],
            'season': [],
          },
        ),
      );
    });
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

  int get selected => _selected;

  void selectPlayer(String id) {
    for (int i = 0; i < _playerBio.length; i++) {
      if (_playerBio[i].id == id) {
        _selected = i;
        notifyListeners();
        return;
      }
    }

    _selected = 0;
    notifyListeners();
  }


  Future<void> deletePlayer(String id) {

    final playerID = selectedPlayer.id;
    final existingPlayerIndex = _playerBio.indexWhere((selectedPlayer) => selectedPlayer.id == id);
    final existingPlayer = _playerBio[existingPlayerIndex];

    final url = 'https://slammers-7bbd0.firebaseio.com/players/$playerID.json?auth=$userToken';

    _playerBio.removeWhere((selectedPlayer) => selectedPlayer.id == id);
    _playerBio.join(', ');
    notifyListeners();

    return http.delete(url).then((res){
      if(res.statusCode >= 400){
        _playerBio.insert(existingPlayerIndex, existingPlayer);
        notifyListeners();

      }
    });
  }


  Future<void> changePlayerPoints(int points) {
    final playerID = selectedPlayer.id;
    final url = 'https://slammers-7bbd0.firebaseio.com/players/$playerID.json?auth=$userToken';

    return http.patch(url, body: json.encode(({
      "points": points
    }))).then((_){
        selectedPlayer.points = points;
        notifyListeners();
    });
  }

  Future<void> changePlayerEmoji(String emoji) {
    final playerID = selectedPlayer.id;
    final url = 'https://slammers-7bbd0.firebaseio.com/players/$playerID.json?auth=$userToken';

    return http.patch(url, body: json.encode(({
      "emoji": emoji
    }))).then((_){
        selectedPlayer.emoji = emoji;
        notifyListeners();
    });

  }

  PlayerBio get selectedPlayer => _playerBio[_selected];
}
