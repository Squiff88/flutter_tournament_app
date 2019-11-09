import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../store/player_bio_model.dart';

  
  
  Future<void> refreshPlayers(BuildContext ctx) async {
  
    await ScopedModel.of<PlayerBioModel>(ctx).fetchPlayers();
  }