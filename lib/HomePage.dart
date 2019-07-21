import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'UsefulFunctions.dart';
import 'GeneratePass.dart';
import 'CurrentPassPage.dart';
import 'SettingsPage.dart';
import 'MakePass.dart';
import 'StudentsOut.dart';
import 'CheckPass.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String _passButtonText = "Loading...";
  bool _hasPass = false;
  int _profession = 0;
  CollectionReference _studentCollection = Firestore.instance.collection("studentPasses");

  Widget listOfStudents() {
    if(_profession == 1 || _profession == 2) {
      return MaterialButton(
        color: Theme.of(context).accentColor,
        padding: EdgeInsets.all(10.0),

        child: Text(
          "Students out of Class",
          style: TextStyle(fontSize: 30.0),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StudentsOut(_profession == 1)), //Send StudentsOut() a boolean of if the user is a teacher or not
          );
        },
      );
    } else {
      return null;
    }
  }

  Future<void> _updateValues() async { //Updates _profession and _passButtonText
    await getStoredInt("profession").then((_storedProfession) {
      _profession = _storedProfession ?? 0; //No need to setState here because the state is set at the end of this function
    });
    switch (_profession) {
      case 0 : {
        String _storedUsername = await getStoredStr("username");
        _hasPass = false;
        await _studentCollection.getDocuments().then((
            querySnapshot) { //See if there is currently a pass in the database for this username
          querySnapshot.documents.forEach((documentSnapshot) {
            if (documentSnapshot.documentID == _storedUsername) {
              _hasPass = true;
            }
          });
        });
        if (_hasPass) {
          _passButtonText = "View Currrent Pass";
        } else {
          _passButtonText = "Leave the Classroom";
        }
      }
      break;
      case 1 : {
        _passButtonText = "Let Student out of Class";
      }
      break;
      case 2 : {
        _passButtonText = "Scan Student's Pass";
      }
      break;
      default: {
        _passButtonText = "ERROR: _profession not recognized.";
      }
      break;
    }
    setState(() {});
  }

  Future<void> _passButtonPressed() async {
    switch (_profession) {
      case 0 : {
        if (_hasPass) {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CurrentPassPage()),
          );

        } else {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GeneratePass()),
          );
        }
        _updateValues(); //After either CurrentPassPage() or GeneratePass(), the status of the pass in Firestore could have changed
      }
      break;
      case 1 : {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MakePass()),
        );
      }
      break;
      case 2 : {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CheckPass()),
        );
      }
      break;
    }
  }

  @override
  void initState() {
    super.initState();
    _updateValues();
    getStoredStr("username").then((_storedUsername) async { //Check to see if there is a username set. If not, open up the SettingsPage and don't let them leave until they do so. :)
      if (_storedUsername == null || _storedUsername == "") {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              titlePadding: EdgeInsets.symmetric(vertical: 15,horizontal: 20),
              contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              title: Text(
                "Please Enter Username",
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
              children: <Widget>[
                Text(
                  "Please give a username inside of the Settings.",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                MaterialButton(
                  color: Theme.of(context).accentColor,
                  child: Text(
                      "OK"
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          }
        );
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SettingsPage()),
        );
      }
      _updateValues();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,style: TextStyle(fontSize: 25)),
        actions: <Widget>[
          IconButton(
            iconSize: 25,
            icon: Icon(Icons.settings),
            tooltip: "Settings",
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              ).then((i) {
                _updateValues();
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            MaterialButton(
              padding: EdgeInsets.all(10.0),
              child: Text(
                _passButtonText,
                style: TextStyle(fontSize: 30.0),
              ),
              color: Theme.of(context).accentColor,
              onPressed: () => _passButtonPressed()
            ),
            listOfStudents(),
          ].where((widget) => widget != null).toList(),
        ),
      ),
    );
  }
}