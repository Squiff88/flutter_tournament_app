import 'package:scoped_model/scoped_model.dart';
import 'package:tournament_app/models/player_bio.dart';

class PlayerBioModel extends Model {
  List<PlayerBio> _playerBio = [
    PlayerBio(
        date: DateTime.now(),
        name: 'Sean Moghadam',
        points: 0,
        id: '0',
        emoji: '🏓',
        achievements: {
          'cup': ['Season 5'],
          'season': ['Season 2'],
        },
      ),
    PlayerBio(
        date: DateTime.now(),
        name: 'Simon Auer',
        points: 0,
        id: '1',
        emoji: '🏓',
        achievements: {
          'cup': [],
          'season': [],
        },

        ),
    PlayerBio(
        date: DateTime.now(),
        name: 'Thomas Venturini',
        points: 0,
        id: '2',
        emoji: '🏓',
        achievements: {
          'cup': [],
          'season': ['Season 1'],
        },
        ),
    PlayerBio(
        date: DateTime.now(),
        name: 'Stefan Metodiev',
        points: 0,
        id: '3',
        emoji: '🏓',
        achievements: {
          'cup': ['Season 4'],
          'season': ['Season 4'],
        }),
    PlayerBio(
        date: DateTime.now(),
        name: 'Oleksandr Burlakov',
        points: 0,
        id: '4',
        emoji: '🏓',
        achievements: {
          'cup': [],
          'season': [],
        },
        ),
    PlayerBio(
        date: DateTime.now(),
        name: 'Niq Bernardowitsch',
        points: 0,
        id: '5',
        emoji: '🏓',
        achievements: {
          'cup': [],
          'season': [],
        },
        ),
    PlayerBio(
        date: DateTime.now(),
        name: 'Carina Weinstabl',
        points: 0,
        id: '6',
        emoji: '🏓',
                achievements: {
          'cup': [],
          'season': ['Season 3'],
        },
        ),
      PlayerBio(
        date: DateTime.now(),
        name: 'Johanna JoJo',
        points: 0,
        id: '7',
        emoji: '🏓',
                achievements: {
          'cup': [],
          'season': ['Season 3'],
        },
        ),
  ];

  int _selected;

  List<PlayerBio> get playerBio => _playerBio;

  int get length => _playerBio.length;

  void addPlayer(playerInfo){

    print(playerInfo);
    print('initial data ....');

    var first = playerInfo['firstName'];
    var last = playerInfo['lastName'];


    var players = _playerBio.length;
    var nextPlayerId = players;

    print(first);
    print(last);
    print(nextPlayerId);
    print('info .......');

    _playerBio.add(
      PlayerBio(
        date: DateTime.now(),
        name: '${first} ${last}',
        points: 0,
        id: '${nextPlayerId}',
        emoji: '🏓',
        achievements: {
          'cup': [],
          'season': [],
        },
        ),
      );
  }

  void resetSeason(){
    _playerBio.forEach((player){
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

  void deletePlayer(String id){
    this.selectPlayer(id);

    _playerBio.removeWhere((player) => player.id == id );
    _playerBio.join(', ');
  }

  void changePlayerPoints(int points) {
    selectedPlayer.points = points;
    notifyListeners();
  }

  void changePlayerEmoji(String emoji) {

    selectedPlayer.emoji = emoji;
    notifyListeners();
  }

  PlayerBio get selectedPlayer => _playerBio[_selected];
}
