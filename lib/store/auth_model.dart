
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tournament_app/models/auth_user.dart';


class AuthModel extends Model {
  String token;
  DateTime exprirityDate;
  String userId;


  bool get isAuthenticated {
    return token != null;
  }

  String get userToken {
    if(token != null && exprirityDate != null && exprirityDate.isAfter(DateTime.now())){
      return token;
    }
    return null;
  }


  Future<void> authentication(String email , String password , String fragment){
    final url = 'https://identitytoolkit.googleapis.com/v1/${fragment}key=AIzaSyDGTf2HsGPmM6-zt8hLSMNNYMd2Xe3fLVA';

    return http.post(url, body: json.encode({
      'email': email,
      "password": password,
      "returnSecureToken": true,
    })).then((res){

      Map<String,dynamic> response = json.decode(res.body);
      if(response['error'] != null){
        print(response['error']);
        return throw Exception(response['error']['message']);
      }

      token = response['idToken'];
      userId = response['localId'];
      
      print(userId);
      print('auth userId');
      exprirityDate =  DateTime.now().add(Duration(seconds: int.parse(response['expiresIn'])));
      notifyListeners();
    });
  }

   Future<void>userSignup(String email , String password){
    return authentication(email, password, 'accounts:signUp?');
  }

  Future<void>userSignIn(String email, String password){
    return authentication(email, password, 'accounts:signInWithPassword?');
  }
}