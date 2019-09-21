import 'package:flutter/material.dart';

import 'package:emoji_picker/emoji_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tournament_app/models/player_bio.dart';
import 'package:tournament_app/store/player_bio_model.dart';

// typedef GetEmoji = void Function(String emoji);

class AwesomeEmojiPicker extends StatefulWidget {
  final String playerId;
  // final GetEmoji getEmoji;
  final String playerEmoji;

  AwesomeEmojiPicker(
      {Key key, @required this.playerEmoji , @required this.playerId})
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
                      rows: 5,
                      columns: 7,
                      numRecommended: 7,
                      buttonMode: ButtonMode.MATERIAL,
                      selectedCategory: Category.ANIMALS,
                      onEmojiSelected: (emoji, category) {
                        model.selectPlayer(widget.playerId);
                        model.changePlayerEmoji(emoji.emoji);

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
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.all(0),
          alignment: Alignment.center,
          width: 30,
          height: 30,
          child: FlatButton(
            color: Colors.transparent,
            onPressed: () {
              _askUser();
            },
            padding: EdgeInsets.all(0),
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
        Container(
          margin: EdgeInsets.only(left: 10),
          padding: EdgeInsets.all(0),
          child: Text(
            widget.playerEmoji,
            style: TextStyle(fontSize: 27),
          ),
        )
      ],
    );
  }
}
