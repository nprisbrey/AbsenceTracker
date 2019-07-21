import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'UsefulFunctions.dart';

class MakePass extends StatefulWidget {

  @override
  _MakePass createState() => _MakePass();
}

class _MakePass extends State<MakePass> {

  String _studentUsername = "";
  Duration _duration = new Duration(minutes: 5);
  CollectionReference _studentCollection = Firestore.instance.collection("studentPasses");

  Future<void> scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        _studentUsername = qrResult;
      });
    } catch (ex) {
      String _userErrorMessage;
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        _userErrorMessage = "You need to grant permission to the camera in order to scan students' passes.";
      } else {
        _userErrorMessage = "Unknown Error: $ex";
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
                  "OK",
                  style: TextStyle(fontSize: 25),
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
          "Approve Absence",
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
              "Username: $_studentUsername",
              style: TextStyle(fontSize: 25),
            ),
            DurationPicker(
              duration: _duration,
              onChange: (val) {
                this.setState(() => _duration = val);
              },
              snapToMins: 1.0,
            ),
            MaterialButton(
              color: Theme.of(context).accentColor,
              child: Text(
                "Approve Pass",
                style: TextStyle(fontSize: 25),
              ),
              onPressed: () async {
                _studentCollection.document(_studentUsername).setData({"TimeCreated":DateTime.now().toString(),"Duration":_duration.toString(),"Teacher":await getStoredStr("username"),"VerifyCode":"","ScannedBySupervisor":"false"});
                Navigator.pop(context);
              }
            ),
          ],
        ),
      ),
    );
  }
}