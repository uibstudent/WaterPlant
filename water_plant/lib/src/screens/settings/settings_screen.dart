import 'package:flutter/material.dart';
import 'package:water_plant/src/screens/settings/components/about.dart';
import 'package:water_plant/src/screens/settings/components/account.dart';
import 'package:water_plant/src/screens/settings/components/notifications.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: Image.asset('assets/logo_white_background.png'),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Text(
                  'Settings',
                  style: TextStyle(fontSize: 35),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccountSettings(),
                          ),
                        );
                      },
                      child: ChoiceButton(
                        text: 'ACCOUNT',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationSettings(),
                          ),
                        );
                      },
                      child: ChoiceButton(
                        text: 'NOTIFICATIONS',
                      ),
                    ),
                    /*ChoiceButton(
                        text: 'APPEARANCE',
                      ),*/
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => About(),
                          ),
                        );
                      },
                      child: ChoiceButton(
                        text: 'ABOUT',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChoiceButton extends StatelessWidget {
  const ChoiceButton({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      color: Colors.white,
      elevation: 5,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            this.text,
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ),
      ),
    );
  }
}
