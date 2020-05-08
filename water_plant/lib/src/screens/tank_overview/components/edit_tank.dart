import 'package:flutter/material.dart';
import 'package:water_plant/constants.dart' as Constants;
import 'package:water_plant/objects/watertankdevice/water_tank_device.dart';

/// Screen for adding/editing a [WaterTankDevice].
class EditTank extends StatefulWidget {
  final Function addTank;
  final Function removeTank;

  /// To refresh the state of previous pages.
  final Function refreshState;

  /// Shows a delete button if a tank is being edited (since it can then be deleted).
  final bool showDeleteButton;

  /// This is the tank device being edited or added.
  final WaterTankDevice tank;

  /// The name being changed in the device name form.
  String tankName;

  /// When adding a new tank, the default name should be 'Device i', where i is the number of tanks in the app + 1.
  int numberOfTanksConnectedToApp;

  EditTank(
      {this.tankName = '',
      this.tank,
      this.addTank,
      this.removeTank,
      this.refreshState,
      this.showDeleteButton = false,
      this.numberOfTanksConnectedToApp = 0});

  @override
  _EditTankState createState() => _EditTankState();
}

class _EditTankState extends State<EditTank> {
  final _formKey = new GlobalKey<FormState>();

  List<Map<String, dynamic>> wifiInfo = [
    {
      'name': 'Get-69FAF2',
      'showIcons': true,
      'isSelected': true,
    },
    {
      'name': 'Get-6A0442',
      'showIcons': true,
      'isSelected': false,
    },
    {
      'name': 'Get-6A0572',
      'showIcons': true,
      'isSelected': false,
    },
    {
      'name': 'Get-6A1B7A',
      'showIcons': true,
      'isSelected': false,
    },
    {
      'name': 'More...',
      'showIcons': false,
      'isSelected': false,
    },
  ];

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
        padding: EdgeInsets.all(5),
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text(
                'Device name',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Card(
              elevation: 5,
              child: Container(
                height: 48,
                padding: EdgeInsets.only(left: 12),
                color: Colors.white,
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    initialValue:
                        widget.tank != null ? widget.tank.nickname : '',
                    maxLength: Constants.MAX_CHARS_DEVICE_NAME,
                    onSaved: (value) => widget.tankName = value,
                    decoration: InputDecoration(
                      hintText: widget.tankName == ''
                          ? 'Default: Device ${widget.numberOfTanksConnectedToApp + 1}'
                          : '',
                      border: InputBorder.none,
                      counterText: '',
                      contentPadding: EdgeInsets.all(0),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Text(
                'Networks',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            WifiCards(wifiInfo),
            Container(
              padding: EdgeInsets.only(top: 40),
              alignment: Alignment.center,
              child: RaisedButton(
                elevation: 4,
                padding: EdgeInsets.all(10),
                color: Colors.white,
                child: Container(
                  margin: EdgeInsets.only(left: 30, right: 30),
                  child: Text(
                    widget.showDeleteButton ? 'Edit Device' : 'Add Device',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                onPressed: () {
                  if (widget.tank == null) {
                    _addNewTank();
                  } else {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }
                    _editTank(widget.tank);
                  }
                },
              ),
            ),
            widget.showDeleteButton ? deleteTankButton(context) : Container(),
          ],
        ),
      ),
    );
  }

  /// Shows the button for deleting this tank.
  Container deleteTankButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      child: RaisedButton(
        elevation: 4,
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.only(left: 30, right: 30),
          child: Text(
            'Delete',
            style: TextStyle(
              fontSize: 20,
              color: Colors.red,
            ),
          ),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: Text('Do you want to remove the tank?'),
              actionsPadding: EdgeInsets.symmetric(
                horizontal: 60,
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    removeThisTank();
                    Navigator.pop(context);
                  },
                ),
              ],
              elevation: 10,
            ),
          );
        },
      ),
    );
  }

  void removeThisTank() {
    assert(widget.tank != null);
    if (widget.removeTank != null) {
      widget.removeTank(widget.tank);
      widget.refreshState();
      // Pop twice to not show the old, now removed tank
      Navigator.pop(context, ['Remove', widget.tank]);
      Navigator.pop(context);
    }
  }

  _submitChanges(WaterTankDevice tank) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (widget.tankName.isEmpty) {
        tank.nickname = 'Device ${widget.numberOfTanksConnectedToApp + 1}';
      } else {
        tank.nickname = widget.tankName;
      }
      widget.refreshState();
      Navigator.pop(context, ['Edit', widget.tank]);
    }
  }

  void _editTank(WaterTankDevice tank) {
    assert(_formKey != null);
    assert(tank != null);
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Container(
          width: 200,
          child: Text('Are you sure you want to save these changes?'),
        ),
        actionsPadding: EdgeInsets.symmetric(
          horizontal: 60,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.pop(context);
              _submitChanges(tank);
            },
          ),
        ],
        elevation: 10,
      ),
    );
  }

  void _addNewTank() {
    assert(_formKey != null);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (widget.tankName.isEmpty) {
        widget.tankName = 'Device ${widget.numberOfTanksConnectedToApp + 1}';
      }
      WaterTankDevice tank = WaterTankDevice(widget.tankName);
      widget.addTank(tank);
      Navigator.pop(context, 'Added tank ${tank.nickname}');
    }
  }
}

class WifiCards extends StatefulWidget {
  WifiCards(
    final this.wifiInfo, {
    Key key,
  }) : super(key: key);

  final List<Map<String, dynamic>> wifiInfo;

  @override
  _WifiCardsState createState() => _WifiCardsState();
}

class _WifiCardsState extends State<WifiCards> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (var info in widget.wifiInfo)
          Container(
            child: wifiCard(info),
          ),
      ],
    );
  }

  InkWell wifiCard(Map<String, dynamic> info) {
    return InkWell(
      onTap: () {
        setState(() {
          for (var card in widget.wifiInfo) {
            card['isSelected'] = false;
          }
          info['isSelected'] = true;
        });
      },
      child: Card(
        elevation: 4,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              info['isSelected']
                  ? Icon(Icons.check)
                  : Container(
                      width: 24,
                    ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    info['name'],
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              info['showIcons']
                  ? Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 5),
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.wifi),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.info_outline,
                            color: Constants
                                .CustomColors.BOTTOM_NAVIGATION_BAR_COLOR,
                          ),
                        )
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
