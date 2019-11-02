import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../store/player_bio_model.dart';

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
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

  var first = '';
  var last = '';

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Enter your first name',
                labelText: 'First Name'
              ),
              validator: (firstNameValue) {
                if (firstNameValue.isEmpty) {
                  return 'Please enter some text';
                }
                return null;

              },
              onSaved:  (firstNameValue) => setState(() => first = firstNameValue),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Enter your last name',
                labelText: 'Last Name'
              ),
              validator: (lastNameValue) {
                if (lastNameValue.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
              onSaved:  (lastNameValue) => setState(() => last = lastNameValue),
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
                  // If the form is valid, display a Snackbar.
                  // Scaffold.of(context)
                  //     .showSnackBar(SnackBar(content: Text('Processing Data')));
                  form.save();
                  var playerInfo = {
                    'firstName': first,
                    'lastName': last
                  };               
                   
                  print('_formKey.......');
                  print(first);

                  print('_formKey..last..');
                  print(last);

                  // ScopedModelDescendant<PlayerBioModel>(builder: (context, child, model) {

                  //       model.addPlayer(playerInfo);
                  // });
                  ScopedModel.of<PlayerBioModel>(context,rebuildOnChange: true).addPlayer(playerInfo);

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
