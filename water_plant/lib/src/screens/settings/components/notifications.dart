import 'package:flutter/material.dart';
import 'package:water_plant/src/screens/settings/components/widgets/form_card.dart';
import 'package:water_plant/src/screens/settings/components/widgets/form_title.dart';
import 'package:water_plant/src/screens/settings/components/widgets/page_title.dart';

/// Notification settings in Settings
class NotificationSettings extends StatefulWidget {
  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool _pushNotificationsOn = true;
  bool _notifyCriticalMoistureLevel = true;
  bool _notifyLowMoistureLevel = false;

  bool _automaticWatering = false;
  bool _deviceWifiDisconnect = true;
  bool _lowWater = true;
  bool _lowBattery = true;

  String _selectedTime = '30 min';
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            PageTitle('Notifications'),
            Row(
              children: <Widget>[
                formTitle('Push notifications'),
                Container(
                  child: Icon(
                    Icons.notifications,
                    color: Colors.grey[700],
                    size: 18,
                  ),
                ),
              ],
            ),
            FormCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Turn on push notifications'),
                  Switch(
                      value: _pushNotificationsOn,
                      onChanged: (bool newValue) {
                        setState(() {
                          _pushNotificationsOn = newValue;
                        });
                      }),
                ],
              ),
            ),
            formTitle('Reminder'),
            FormCard(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Every'),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Expanded(
                    flex: 2,
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.all(0),
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 12,
                          right: 5,
                          top: 5,
                          bottom: 5,
                        ),
                        alignment: Alignment.centerLeft,
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.only(left: 85, right: 10),
                          child: DropdownButton<String>(
                            value: _selectedTime,
                            items: [
                              '15 min',
                              '30 min',
                              '1 hour',
                              '2 hours',
                              '3 hours',
                              '6 hours',
                              '9 hours',
                              '12 hours',
                              '24 hours',
                            ].map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                  child: new Text(value),
                                ),
                              );
                            }).toList(),
                            onChanged: (String value) {
                              setState(() {
                                _selectedTime = value;
                              });
                            },
                            isExpanded: true,
                            underline: Container(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            formTitle('Plants'),
            FormCard(
              height: 96,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Critical moisture level'),
                      Switch(
                          value: _notifyCriticalMoistureLevel,
                          onChanged: (bool newValue) {
                            setState(() {
                              _notifyCriticalMoistureLevel = newValue;
                            });
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Low moisture level'),
                      Switch(
                          value: _notifyLowMoistureLevel,
                          onChanged: (bool newValue) {
                            setState(() {
                              _notifyLowMoistureLevel = newValue;
                            });
                          }),
                    ],
                  ),
                ],
              ),
            ),
            formTitle('Device'),
            FormCard(
              height: 96,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Automatic watering'),
                      Switch(
                          value: _automaticWatering,
                          onChanged: (bool newValue) {
                            setState(() {
                              _automaticWatering = newValue;
                            });
                          }),
                    ],
                  ),*/
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Device WIFI disconnect'),
                      Switch(
                          value: _deviceWifiDisconnect,
                          onChanged: (bool newValue) {
                            setState(() {
                              _deviceWifiDisconnect = newValue;
                            });
                          }),
                    ],
                  ),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Low water'),
                      Switch(
                          value: _lowWater,
                          onChanged: (bool newValue) {
                            setState(() {
                              _lowWater = newValue;
                            });
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Low battery'),
                      Switch(
                          value: _lowBattery,
                          onChanged: (bool newValue) {
                            setState(() {
                              _lowBattery = newValue;
                            });
                          }),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
