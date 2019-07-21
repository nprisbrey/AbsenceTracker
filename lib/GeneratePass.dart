import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'UsefulFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GeneratePass extends StatefulWidget {
  @override
  _GeneratePass createState() => _GeneratePass();
}

class _GeneratePass extends State<GeneratePass> {

  CollectionReference _studentCollection = Firestore.instance.collection("studentPasses");
  String _username = "";
  bool _passGenerated = false; //Used to control reading in usernames from Firestore Database everytime something changes.

  @override
  void initState() {
    super.initState();
    getStoredStr("username").then((_storedUsername) {
      setState(() {
        _username = _storedUsername ?? "";
      });
    });
    _studentCollection.snapshots().forEach((querySnapshot) {
      querySnapshot.documents.takeWhile((i) => !_passGenerated).forEach((documentSnapshot) async { //Go through documents in Firestore Database until new pass generated
        if(documentSnapshot.documentID == _username && DateTime.now().difference(DateTime.parse(documentSnapshot.data["TimeCreated"])).inSeconds < 60) { //If document is for _username and was generated within the last 60 seconds
          _passGenerated = true;
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                titlePadding: EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                title: Text(
                  "Approved!",
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                children: <Widget>[
                  Text(
                    "A pass has been made.",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  MaterialButton(
                    color: Theme.of(context).accentColor,
                    child: Text(
                      "OK",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            }
          );
          Navigator.pop(context,true);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Approve Absence",
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Have your teacher scan the QR code below:",
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
            new QrImage(
              data: _username
            ),
          ],
        ),
      ),
    );
  }
}