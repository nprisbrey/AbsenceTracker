import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'UsefulFunctions.dart';

class StudentsOut extends StatefulWidget {
  final bool _amTeacher;

  StudentsOut(this._amTeacher);

  @override
  _StudentsOut createState() => _StudentsOut(_amTeacher);
}

class _StudentsOut extends State<StudentsOut> {

  final bool _amTeacher;
  String _username = "";
  CollectionReference _studentCollection = Firestore.instance.collection("studentPasses");

  _StudentsOut(this._amTeacher);

  Stream streamToBuildFrom() {
    if(_amTeacher) {
      return _studentCollection.where("Teacher", isEqualTo: _username).snapshots();
    } else {
      return _studentCollection.snapshots();
    }
  }

  Widget buildCard(BuildContext context, DocumentSnapshot document) {
    Widget _scannedIcon;
    DateTime _creationTime = DateTime.parse(document.data["TimeCreated"]);
    Duration _duration = parseDuration(document.data["Duration"]);
    int _minuteComparison = DateTime.now().difference(_creationTime.add(_duration)).inMinutes;
    String _timeLeft;
    Color _backgroundColor;
    if(_minuteComparison <= 0) {
      _timeLeft = (-_minuteComparison).toString() + " minutes left";
      _backgroundColor = Colors.green;
    } else {
      _timeLeft = _minuteComparison.toString() + " minutes over";
      _backgroundColor = Colors.red;
    }
    if(document.data["ScannedBySupervisor"] == "true") {
      _scannedIcon = IconButton(
        icon: Icon(Icons.error_outline),
        tooltip: "Information",
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                titlePadding: EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                title: Text(
                  "Been Scanned",
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                children: <Widget>[
                  Text(
                    document.documentID + "'s pass has been scanned by a yard supervisor.",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  MaterialButton(
                    color: Theme.of(context).accentColor,
                    child: Text(
                      "OK",
                      style: TextStyle(fontSize: 25),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            }
          );
        },
      );
    }
    return Card(
      child: ListTile(
        title: Text(
          document.documentID,
          style: TextStyle(fontSize: 20),
        ),
        leading: _scannedIcon,
        trailing: Text(
          _timeLeft,
          style: TextStyle(fontSize: 20),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                titlePadding: EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                title: Text(
                  "Revoke Pass?",
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                children: <Widget>[
                  Text(
                    "Would you like to revoke " + document.documentID + "'s pass? This action cannot be undone!",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  MaterialButton(
                    color: Theme.of(context).accentColor,
                    child: Text(
                      "Yes",
                      style: TextStyle(fontSize: 25),
                    ),
                    onPressed: () {
                      _studentCollection.document(document.documentID).delete();
                      Navigator.pop(context);
                    },
                  ),
                  MaterialButton(
                    color: Theme.of(context).accentColor,
                    child: Text(
                      "No",
                      style: TextStyle(fontSize: 25),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            }
          );
        },
      ),
      color: _backgroundColor,
    );
  }

  @override
  void initState() {
    super.initState();
    if(_amTeacher) { //The username is only used if a teacher wants to look at their students
      getStoredStr("username").then((_storedUsername) {
        setState(() {
          _username = _storedUsername ?? "";
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Students Out of Class",
          style: TextStyle(fontSize: 25),
        ),
        leading: IconButton(
          iconSize: 25,
          icon: Icon(Icons.arrow_back),
          tooltip: "Back",
          onPressed: () {
            Navigator.pop(context,false);
          },
        ),
        actions: <Widget>[
          IconButton(
            iconSize: 25,
            icon: Icon(Icons.help_outline),
            tooltip: "Help",
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      titlePadding: EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                      contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                      title: Text(
                        "Help",
                        style: TextStyle(fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
                      children: <Widget>[
                        Text(
                          "Click on a student to revoke their pass. The color of the students' entries visually represents if a pass is expired. Teachers can only see those out in their own class.",
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        MaterialButton(
                          color: Theme.of(context).accentColor,
                          child: Text(
                              "OK",
                              style: TextStyle(fontSize: 25),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  }
              );
            }
          )
        ],
      ),
      body: StreamBuilder(
        stream: streamToBuildFrom(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return const Center(child: Text("Loading..."));
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return buildCard(context, snapshot.data.documents[index]);
            },
          );
        },
      ),
    );
  }
}