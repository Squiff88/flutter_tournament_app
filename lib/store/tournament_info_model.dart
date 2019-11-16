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
  }

  void saveUserToken(String userAuthToken) {
    userToken = userAuthToken;
  }

  var _tournamentInfo = TournamentInfo(
      seasonNumber: 1,
      cupNumber: 1,
   );

  Future<void> seasonCounter(String venueType) {
    String venue = venueType == 'season' ? 'season' : 'cup';

    final url = 'https://slammers-7bbd0.firebaseio.com/users/$userId/tournaments/$venue.json?auth=$userToken';
    return http.get(url).then((response) {
      final result = json.decode(response.body) as Map<String, dynamic>;
      venue == 'season' ? _tournamentInfo.seasonNumber = result['season'] : _tournamentInfo.cupNumber = result['cup'];      
      notifyListeners();
    }).then((_){
      return;
    }).catchError((err){
      print(err);
    });    
  }



  Future<void> setSeasonNumber(String venueType){

    String venue = venueType == 'season' ? 'season' : 'cup';
    final url = 'https://slammers-7bbd0.firebaseio.com/users/$userId/tournaments/$venue.json?auth=$userToken';
    notifyListeners();

    int newSeason = venue == 'season' ? _tournamentInfo.seasonNumber + 1 : _tournamentInfo.cupNumber + 1;
    
    return http.patch(url , body: json.encode({
      venue : newSeason
    })).then((response) {
      final result = json.decode(response.body) as Map<String, dynamic>;
      
      venue == 'season' ? _tournamentInfo.seasonNumber = result['season'] : _tournamentInfo.cupNumber = result['cup'];
      notifyListeners();
    });  
  }

    void setCupNumber(){
    _tournamentInfo.cupNumber++;
    notifyListeners();
  }


  int get getSeasonNumber {
    return _tournamentInfo.seasonNumber;
  }   
  int get getCupNumber {    
    return _tournamentInfo.cupNumber;
  } 

}
