import 'package:flutter/material.dart';
import 'package:tournament_app/models/player_bio.dart';

import '../theme/theme.dart' as AppTheme;

class PlayerSelector extends StatefulWidget {
  final List<PlayerBio> players;
  final List selectedPlayers;
  final Function(List<Map<String, String>>) onSelectionChanged; // +add
  

  PlayerSelector({this.players, this.selectedPlayers, this.onSelectionChanged});
  @override
  _PlayerSelectorState createState() => _PlayerSelectorState();
}

class _PlayerSelectorState extends State<PlayerSelector> {
  List<Map<String, String>> selectedChoices = List();


  _buildChoiceList() {

    List<Widget> choices = List();
    widget.players.forEach((PlayerBio item ) {

      final String playerName = item.name;
      final String firstName = playerName.split(' ')[0].split('')[0].toUpperCase().substring(0);
      final String lastName = playerName.split(' ')[1].split('')[0].toUpperCase().substring(0);


      Iterable<Map<String, String>> searchList = selectedChoices.where((selectPlayer) {
        return selectPlayer['name'].contains(item.name);
      });

      String searchPlayer = searchList.map((arr) {
        return arr.containsValue(item.name);
      }).toString();

  
      // FUNCTION TO EXTEND PLAYER PICKER FUNCTIONALITY ,
      // DETERMINE WHICH PLAYERS WERE ADDED ...

      // bool heyYo(List oldPLayers , List selectedChoice) {
      //   if (oldPLayers != null) {
      //     var yo = oldPLayers.map((oldChoice) {
      //       // print(oldChoice['name']);
      //       // print('oldChoice');
      //       return oldChoice['name'];
      //       //  => arr.containsValue(oldChoice)
      //     }).toString();

      //     if (yo != null && yo.contains(item.name)) {
      //       print('(${item.name})');
      //       print(yo);
      //       print('yo');
      //       return true;
      //     }
      //   };

      // var searchPlayerNameList = selectedChoice.where((yo) {
      //   return yo['name'].contains(item.name);
      // });

      // String searchPlater = searchPlayerNameList.map((arr) {
      //   return arr.containsValue(item.name);
      // }).toString();

      // return searchPlater == '(true)' ? true : false;
      // };

      // dynamic moYo(List oldPlayers1 , List selectedChoice1){
      //           if (oldPlayers1 != null) {
      //     var yo = oldPlayers1.map((oldChoice1) {
      //       // print(oldChoice['name']);
      //       // print('oldChoice');
      //       return oldChoice1['name'];
      //       //  => arr.containsValue(oldChoice)
      //     }).toString();

      //     print(yo);
      //     print('joyo');
      // }
      // }

      // print(heyYo(widget.selectedPlayers));

      choices.add(Container(

        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ChoiceChip(
          backgroundColor: Colors.white,
          elevation: 1,
          selectedColor: AppTheme.AppColors.sand.withAlpha(100),
          selectedShadowColor: Colors.orange,
          label: Container(
            // color:Colors.red,
            // height: 200,
            alignment: Alignment.center,
            width: 37,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${item.emoji}',
                  style: TextStyle(fontSize: 36),
                ),
                Text(
                  '${firstName}.${lastName}',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: AppTheme.FontFamilies.curvy,
                      color: Colors.black),
                ),
              ],
            ),
          ),

          // Add heyYo func to determine which players were selected
          // heyYo(widget.selectedPlayers , selectedChoices) 
          
          selected: searchPlayer == '(true)' ? true : false,
          onSelected: (selected) {
            // var boJo = moYo(widget.selectedPlayers , selectedChoices);
            setState(() {
              searchPlayer == '(true)'
                  ? selectedChoices.remove(item.name)
                  : selectedChoices
                      .add({'emoji': item.emoji, 'name': item.name});
            });
            widget.onSelectionChanged(selectedChoices);
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
