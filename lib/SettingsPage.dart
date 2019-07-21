import 'package:flutter/material.dart';
import 'UsefulFunctions.dart';

class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  String _username = "";
  String _userProfession = "";
  final _usernameController = TextEditingController();

  Future<String> _changeUsername(context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          titlePadding: EdgeInsets.symmetric(vertical: 15,horizontal: 20),
          contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
          title: Text(
            "New Username:",
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
          children: <Widget>[
            TextField(
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
              textInputAction: TextInputAction.done,
              autofocus: true,
              scrollPadding: EdgeInsets.fromLTRB(24, 8, 24, 8),
              controller: _usernameController,
            ),
            MaterialButton(
              color: Theme.of(context).accentColor,
              child: Text(
                "Done",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context, _usernameController.text);
              }
            ),
          ],
        );
      }
    ) as String;
  }

  @override
  void initState() {
    super.initState();
    getStoredStr("username").then((_storedUsername) {
      setState(() {
        _username = _storedUsername ?? ""; //Only uses stored username if it isn't null
      });
    });
    getStoredInt("profession").then((_storedProfession) {
      setState(() {
        if(_storedProfession == 0 || _storedProfession == null) {
          _userProfession = "Student";
        } else if (_storedProfession == 1) {
          _userProfession = "Teacher";
        } else if (_storedProfession == 2) {
          _userProfession = "Yard Supervisor";
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(fontSize: 25),
        ),
        leading: IconButton(
          iconSize: 25,
          icon: Icon(Icons.arrow_back),
          tooltip: "Back",
          onPressed: () async {
            if(_username != "") {
              setStoredStr("username", _username);
              if(_userProfession == "Student") {
                setStoredInt("profession",0);
              } else if (_userProfession == "Teacher") {
                setStoredInt("profession",1);
              } else if (_userProfession == "Yard Supervisor") {
                setStoredInt("profession",2);
              }
              Navigator.pop(context);
            } else {
              showDialog( //Popup window that catches blank usernames
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    titlePadding: EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                    contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                    title: Text(
                      "Username Issue!",
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                    children: <Widget>[
                      Text(
                        "Your username has to be at least one character long.",
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
                      ),
                    ],
                  );
                }
              );
            }
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
                        "Click on the setting that you want to change. Then follow the prompts.",
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
                      ),
                    ],
                  );
                }
              );
            }
          )
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  title: Text(
                    "Username:",
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                    _username,
                    style: TextStyle(fontSize: 15),
                  ),
                  onTap: () {
                    _changeUsername(context).then((newUsername) => setState(() {
                      if(newUsername != null) {
                        _username = newUsername;
                      }
                    }));
                  }
                ),
                ListTile(
                  title: Text(
                    "User:",
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                    _userProfession,
                    style: TextStyle(fontSize: 15),
                  ),
                  onTap: () {
                    setState(() {
                      if(_userProfession == "Student") {
                        _userProfession = "Teacher";
                      } else if (_userProfession == "Teacher") {
                        _userProfession = "Yard Supervisor";
                      } else if (_userProfession == "Yard Supervisor") {
                        _userProfession = "Student";
                      }
                    });
                  }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
