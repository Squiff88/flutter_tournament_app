import 'package:scoped_model/scoped_model.dart';
import 'package:tournament_app/models/tournament_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class TournamentInfoModel extends Model {

  int _counter1 = 0;
  
  int get count => _counter1;

  String userId;

  String userToken;

  void saveUserId(String userAuthId) {
    userId = userAuthId;
    print(userId);
    print('userId tournament');

  }

  void saveUserToken(String userAuthToken) {
    userToken = userAuthToken;
    print(userToken);
    print('userToken tournament');
  }

  var _tournamentInfo = TournamentInfo(
      seasonNumber: 1,
      cupNumber: 1,
   );

  Future<void> seasonCounter() {
    final url = 'https://slammers-7bbd0.firebaseio.com/users/$userId/tournaments/season.json?auth=$userToken';
    return http.get(url).then((response) {
      final result = json.decode(response.body) as Map<String, dynamic>;
      print(result['season']);
      print('_______________________');
      _tournamentInfo.seasonNumber = result['season'];
      notifyListeners();
      print(_tournamentInfo.seasonNumber);
      print("_tournamentInfo.seasonNumber");
    }).then((_){
      return;
    }).catchError((err){
      print(err);
    });    
  }





  Future<void> setSeasonNumber(){
    final url = 'https://slammers-7bbd0.firebaseio.com/users/$userId/tournaments/season.json?auth=$userToken';
    notifyListeners();

    int newSeason = _tournamentInfo.seasonNumber + 1;
    return http.patch(url , body: json.encode({
      "season" : newSeason
    })).then((response) {
      final result = json.decode(response.body) as Map<String, dynamic>;
      _tournamentInfo.seasonNumber = result['season'];
      notifyListeners();
    });  
  }

    void setCupNumber(){
    _tournamentInfo.cupNumber++;
    notifyListeners();
  }


  int get getSeasonNumber {
    print(_tournamentInfo.seasonNumber);
    print('_tournamentInfo.seasonNumber');
    
    return _tournamentInfo.seasonNumber;
  } 
  int get cupNumber => _tournamentInfo.cupNumber;

}
