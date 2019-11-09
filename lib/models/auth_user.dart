import 'package:flutter/foundation.dart';


class AuthUser {

  String token;
  String userId;
  DateTime exprirityDate;

  AuthUser({@required this.token , @required this.userId , @required this.exprirityDate});
}