import 'package:flutter/material.dart';
import 'package:tournament_app/models/player_bio.dart';
import 'dart:math';


import '../theme/theme.dart' as AppTheme;



class PlayerSelector extends StatefulWidget {

  final List<PlayerBio> players;
  final Function(List<Map<String , String>>) onSelectionChanged; // +add

  PlayerSelector({this.players, this.onSelectionChanged});
  @override
  _PlayerSelectorState createState() => _PlayerSelectorState();
}

class _PlayerSelectorState extends State<PlayerSelector> {
  
  // String selectedChoice = "";
  List<Map<String, String>> selectedChoices = List();
  // this function will build and return the choice list
  _buildChoiceList() {
    List<Widget> choices = List();
    widget.players.forEach((item) {
      final rng = new Random();
      final randomMargin = rng.nextInt(38 - 1);

      final String playerName = item.name;
      final String firstName = playerName.split(' ')[0].split('')[0];
      final String lastName = playerName.split(' ')[1].split('')[0];

      choices.add(Container(

        // margin: EdgeInsets.fromLTRB(double.parse(randomMargin.toString()) ,double.parse(randomMargin.toString()) , 0 ,0),
        // alignment: Alignment.center,
        height: 75,
        // color:Colors.black,
        margin: EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
        child: ChoiceChip(
          backgroundColor: Colors.white,
          label: Container(
            // color:Colors.red,
            alignment: Alignment.center,
            width: 66,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('${item.emoji}' , style: TextStyle(fontSize: 36),),
                Text('${firstName}.${lastName}' , style: TextStyle(fontSize: 16 , fontFamily: AppTheme.FontFamilies.curvy),),
            ],),
          ),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item.id)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add({'emoji': item.emoji , 'name': item.name});
              widget.onSelectionChanged(selectedChoices);
            });
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
