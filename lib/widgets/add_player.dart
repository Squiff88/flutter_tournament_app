import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../store/player_bio_model.dart';
import '../store/auth_model.dart';

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  final userId;

  MyCustomForm(this.userId);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  var _first = '';
  var _last = '';
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Enter your first name',
                        labelText: 'First Name'),
                    validator: (firstNameValue) {
                      if(firstNameValue.length > 10){
                        return 'Exceeded maximum length';
                      }
                      if (firstNameValue.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (firstNameValue){
                      var firstName = firstNameValue.split(' ').join('');
                      var firstNameCamel = firstName[0].toUpperCase() + firstName.substring(1);
                        setState(() => _first = firstNameCamel);
                    }
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Enter your last name',
                        labelText: 'Last Name'),
                    validator: (lastNameValue) {
                      if (lastNameValue.isEmpty) {
                        return 'Please enter your last name';
                      }
                      if(lastNameValue.length > 15){
                        return 'Exceeded maximum length';
                      }
                      return null;
                    },
                    onSaved: (lastNameValue) {
                      var lastName = lastNameValue.split(' ').join('');
                      var lastNameCamel = lastName[0].toUpperCase() + lastName.substring(1);
                        setState(() {
                           _last = lastNameCamel;
                          }
                        );}
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      final form = _formKey.currentState;
                      if (_formKey.currentState.validate()) {

                        form.save();
                        setState(() {
                          _isLoading = true;
                        });
                        var playerInfo = {
                          'firstName': _first,
                          'lastName': _last
                        };
                        bool isAnonymousUser =ScopedModel.of<AuthModel>(context).isUserAnonymous;
   
                        ScopedModel.of<PlayerBioModel>(context,
                                rebuildOnChange: true)
                            .addPlayer(playerInfo, widget.userId, isAnonymousUser)
                            .then((_) {
                          setState(() {
                            _isLoading = false;
                          });
                        }).catchError((error) {
                          setState(() {
                            _isLoading = false;
                          });
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    title: Text('An error has occured'),
                                    content:
                                        Text('Something went wrong slammer...'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('OK'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      )
                                    ],
                                  ));
                        });
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          );
  }
}
