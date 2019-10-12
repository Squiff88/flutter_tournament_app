import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tournament_app/models/player_bio.dart';
import 'package:tournament_app/widgets/season_number.dart';
import '../store/player_bio_model.dart';

import '../store/tournament_info_model.dart';
import '../theme/theme.dart' as AppTheme;

class PlayerDetails extends StatefulWidget {
  final int seasonCounter;

  PlayerDetails(this.seasonCounter);

  @override
  _PlayerDetailsState createState() => _PlayerDetailsState();
}

class _PlayerDetailsState extends State<PlayerDetails> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('details dependencies did updated');
    ScopedModel.of<PlayerBioModel>(context).sortPlayers();
  }

  @override
  Widget build(BuildContext context) {
    Future<String> deleteDialog() async {
      switch (await showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: const Text('Do you really want to delete this player ?'),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, 'Yes');
                  },
                  child: const Text('Yes'),
                ),
                SimpleDialogOption(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.pop(context, 'No');
                  },
                ),
              ],
            );
          })) {
        case 'No':
          print('dont delete me pls');
          // Let's go.
          // ...
          return 'No';
          break;
        case 'Yes':
          print('delete me pls');
          return 'Yes';

          // ...
          break;
      }
    }

    return ScopedModelDescendant<PlayerBioModel>(
      builder: (context, child, model) {
        PlayerBio player = model.selectedPlayer;

        if (player == null) {
          return null;
        }

        return Scaffold(
          appBar: GradientAppBar(
            title: Text('Slammer\'s Stats',
                style: TextStyle(
                    fontFamily: AppTheme.FontFamilies.regular,
                    fontWeight: FontWeight.w700,
                    fontSize: 27)),
            gradient: AppTheme.AppBarColor.linear,
          ),
          body: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),

            // color: Colors.red,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              'Player: ',
                              style: TextStyle(fontSize: 16),
                            )),
                      ),
                      Flexible(
                        flex: 1,
                        child: Text(
                          player.name,
                          style: TextStyle(
                              fontSize: 21,
                              fontFamily: AppTheme.FontFamilies.regular,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                            margin: EdgeInsets.only(left: 10),
                            padding: EdgeInsets.only(top: 10),
                            child: Text('Avatar: ',
                                style: TextStyle(fontSize: 16))),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Text(
                              player.emoji,
                              style: TextStyle(fontSize: 45),
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          padding: EdgeInsets.only(top: 10),
                          child:
                              Text('Score: ', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.only(top: 3),
                          child: Text(
                            player.points.toString(),
                            style: TextStyle(
                                fontFamily: 'KaushanScript-Regular',
                                fontSize: 25),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text('Change Score',
                            style: TextStyle(fontSize: 16)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 30,
                            child: FlatButton(
                              color: Colors.transparent,
                              onPressed: () {
                                model.changePlayerPoints(player.points - 1);
                              },
                              padding: EdgeInsets.all(0),
                              child: Text(
                                '-',
                                style: TextStyle(
                                    fontFamily: 'KaushanScript-Regular',
                                    fontSize: 30),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            width: 30,
                            child: FlatButton(
                              color: Colors.transparent,
                              onPressed: () {
                                model.changePlayerPoints(player.points + 1);
                              },
                              padding: EdgeInsets.all(0),
                              child: Text(
                                '+',
                                style: TextStyle(
                                    fontFamily: 'KaushanScript-Regular',
                                    fontSize: 30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child:
                          Text('Delete Player', style: TextStyle(fontSize: 16)),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 2,
                      child: IconButton(
                        color: AppTheme.AppColors.fire,
                        padding: EdgeInsets.only(left: 10),
                        alignment: Alignment.centerRight,
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          final result = deleteDialog();

                          final selectedPlayer = ScopedModel.of<PlayerBioModel>(
                                  context,
                                  rebuildOnChange: true)
                              .selectedPlayer;
                          final String playerId = selectedPlayer.id;

                          result.then((onValue) {
                            if (onValue == 'Yes') {
                              ScopedModel.of<PlayerBioModel>(context,
                                      rebuildOnChange: true)
                                  .deletePlayer(playerId);
                            }
                          });
                        },
                      ),
                    )
                  ],
                ),
                Image.asset(
                  'assets/images/details_image.jpg',
                  fit: BoxFit.scaleDown,
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height * 0.3,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
