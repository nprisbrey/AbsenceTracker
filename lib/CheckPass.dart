import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'UsefulFunctions.dart';

class CheckPass extends StatefulWidget {
  @override
  _CheckPass createState() => _CheckPass();
}

class _CheckPass extends State<CheckPass> {
  String _studentUsername = "";
  DocumentSnapshot _passInfo;
  CollectionReference _studentCollection = Firestore.instance.collection("studentPasses");

  List<Widget> _makeIntoCards(DocumentSnapshot document) {
    List<Widget> _cardList = new List<Widget>();
    try {
      DateTime _creationTime = DateTime.parse(document.data["TimeCreated"]);
      Duration _duration = parseDuration(document.data["Duration"]);
      int _minuteComparison = DateTime.now().difference(_creationTime.add(_duration)).inMinutes;
      DateTime _whenPassMade = DateTime.parse(document.data["TimeCreated"]);
      Color _color = (_minuteComparison <= 0) ? Colors.green : Colors.red;
      Map<String, String> _fields = {
        "Status:": (_minuteComparison <= 0) ? "Active" : "Expired",
        "Username:": _studentUsername,
        "Teacher:": document.data["Teacher"],
        "When Pass Made:": (_whenPassMade.hour%12).toString() + ":" + _whenPassMade.minute.toString() + " " + (_whenPassMade.hour ~/ 12 == 0 ? "a.m." : "p.m."),
        "Pass Made For:": parseDuration(document.data["Duration"]).inMinutes.toString() + " min.",
      };
      _fields.forEach((key, value) {
        _cardList.add(
          Card(
            color: _color,
            child: ListTile(
              title: Text(
                  key,
                style: TextStyle(fontSize: 20),
              ),
              trailing: Text(
                  value,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        );
      });
    } catch (ex) {
      _cardList.add(
        Card(
          child: ListTile(
            title: Text(
              "There was an error with the database when reading the QR code. This may be due to scanning a QR code from a previous pass that has been finished with."
            ),
          ),
        )
      );
    }
    return _cardList;
  }

  Future<void> scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      try {
        DocumentSnapshot _passInformation = await _studentCollection.document(qrResult).get();
        setState(() {
          _studentUsername = qrResult;
          _passInfo = _passInformation;
        });
        _studentCollection.document(qrResult).updateData({"ScannedBySupervisor": "true"});
      } catch (ex) {
        print("Got this error in CheckPass.dart -> scanQR(): $ex");
      }
    } catch (ex) {
      String _userErrorMessage;
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        _userErrorMessage = "You need to grant permission to the camera in order to scan students' passes.";
      } else {
        _userErrorMessage = "Error: Please make sure that the scanned QR code isn't an old code (have the student close and re-open the app) and that you are online.";
      }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              titlePadding: EdgeInsets.symmetric(vertical: 15,horizontal: 20),
              contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              title: Text(
                "Error",
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
              children: <Widget>[
                Text(
                  _userErrorMessage,
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
                      Navigator.pop(context);
                    }
                ),
              ],
            );
          }
      );
    }
  }

  @override
  void initState() {
    super.initState();
    scanQR(); //Scan QR code and get student's username
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pass Information",
          style: TextStyle(fontSize: 25),
        ),
        leading: IconButton(
          iconSize: 25,
          icon: Icon(Icons.arrow_back),
          tooltip: "Back",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Pass Information:",
              style: TextStyle(fontSize: 25.0),
            ),
            ListView(
              shrinkWrap: true,
              children: _makeIntoCards(_passInfo),
            ),
            MaterialButton(
              color: Theme.of(context).accentColor,
              padding: EdgeInsets.all(10),
              child: Text(
                "OK",
                style: TextStyle(fontSize: 25.0),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              color: Theme.of(context).accentColor,
              padding: EdgeInsets.all(10),
              child: Text(
                "Invalidate Pass",
                style: TextStyle(fontSize: 25.0),
              ),
              onPressed: () {
                _studentCollection.document(_studentUsername).delete();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}