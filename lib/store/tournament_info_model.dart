import 'package:scoped_model/scoped_model.dart';
import 'package:tournament_app/models/tournament_info.dart';



class TournamentInfoModel extends Model {

  int _counter1 = 0;
  
  int get count => _counter1;

  var _tournamentInfo = TournamentInfo(
      seasonNumber: 6,
      cupNumber: 3,
   );


  void setSeasonNumber(int newSeason){

  this._tournamentInfo.seasonNumber = this._tournamentInfo.seasonNumber + newSeason;

  notifyListeners();
 
    
  }

    void setCupNumber(){
    _tournamentInfo.cupNumber++;
    notifyListeners();
  }


  int get getSeasonNumber => _tournamentInfo.seasonNumber;
  int get cupNumber => _tournamentInfo.cupNumber;

}
