import 'package:flutter/material.dart';

import 'package:emoji_picker/emoji_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tournament_app/models/player_bio.dart';
import 'package:tournament_app/store/player_bio_model.dart';
import '../store/auth_model.dart';

import '../theme/theme.dart' as AppTheme;

// typedef GetEmoji = void Function(String emoji);

class AwesomeEmojiPicker extends StatefulWidget {
  final String playerId;
  // final GetEmoji getEmoji;
  final String playerEmoji;
  final String playerName;

  AwesomeEmojiPicker(
      {Key key,
      @required this.playerEmoji,
      @required this.playerId,
      this.playerName})
      : super(key: key);

  @override
  _AwesomeEmojiPickerState createState() => _AwesomeEmojiPickerState();
}

class _AwesomeEmojiPickerState extends State<AwesomeEmojiPicker> {
  Future _askUser() async {
    switch (await showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: SimpleDialog(
            title: Text(
              "Choose your avatar",
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              ScopedModelDescendant<PlayerBioModel>(
                  builder: (context, child, model) {
                return SimpleDialogOption(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: EmojiPicker(
                      rows: 6,
                      columns: 8,
                      numRecommended: 8,
                      buttonMode: ButtonMode.MATERIAL,
                      selectedCategory: Category.ANIMALS,
                      onEmojiSelected: (emoji, category) {
                        final userId =  ScopedModel.of<AuthModel>(context).userId;
                        print(userId);
                        print('.......userId');
                        model.selectPlayer(widget.playerId);
                        model.changePlayerEmoji(emoji.emoji, userId);

                        Navigator.pop(context);
                      },
                    ),
                  ),
                  onPressed: () {},
                );
              }),
            ],
          ),
        );
      },
    )) {
      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
  
      children: <Widget>[
        if (widget.playerName == null)
        Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.only(right: 10),
          width: MediaQuery.of(context).size.width * 0.03,
          height:30,
          child: FlatButton(
            
            color: Colors.transparent,
            onPressed: () {
              _askUser();
            },
            
            child: Text(
              '✜',
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 15,
                  height: 1.00,
                  backgroundColor: Colors.transparent),
            ),
          ),
        ),
        if (widget.playerName != null)
                Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.only(right: 15),
          width: MediaQuery.of(context).size.width * 0.06,
          height:30,
          child: FlatButton(
            
            color: Colors.transparent,
            onPressed: () {
              _askUser();
            },
            
            child: Text(
              '✜',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 15,
                  height: 1.00,
                  backgroundColor: Colors.transparent),
            ),
          ),
        ),

        if (widget.playerName != null)
          Container(
            // margin: EdgeInsets.only(left: 10),
            padding: EdgeInsets.all(0),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Text(
              widget.playerName,
              style: TextStyle(
                  fontFamily: AppTheme.FontFamilies.regular,
                  fontSize: 23,
                  fontWeight: FontWeight.w500),
            ),
          ),
        if (widget.playerName != null)
        Container(
          // margin: EdgeInsets.only(left: 10),
          padding: EdgeInsets.all(0),
          width: MediaQuery.of(context).size.width * 0.07,
          alignment: Alignment.centerRight,
          child: Text(
            widget.playerEmoji,
            style: TextStyle(fontSize: 27),
          ),
        ),
        if (widget.playerName == null)
        Container(
          margin: EdgeInsets.only(left: 10),
          padding: EdgeInsets.all(0),
          width: MediaQuery.of(context).size.width * 0.08,
          alignment: Alignment.centerLeft,
          child: Text(
            widget.playerEmoji,
            style: TextStyle(fontSize: 27),
          ),
        ),

      ],
    );
  }
}
