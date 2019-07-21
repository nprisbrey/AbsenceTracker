import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'UsefulFunctions.dart';

class CurrentPassPage extends StatefulWidget {
  @override
  _CurrentPassPage createState() => _CurrentPassPage();
}

class _CurrentPassPage extends State<CurrentPassPage> {

  String _username = "";
  CollectionReference _studentCollection = Firestore.instance.collection("studentPasses");

  @override
  void initState() {
    super.initState();
    getStoredStr("username").then((_storedUsername) {
      setState(() {
        _username = _storedUsername ?? "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Scan the QR Code below for Pass information:",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            new QrImage(
                data: _username
            ),
            MaterialButton(
              color: Theme.of(context).accentColor,
              child: Text(
                "I'm back now!",
                style: TextStyle(fontSize: 25),
              ),
              onPressed: () {
                _studentCollection.document(_username).delete();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}