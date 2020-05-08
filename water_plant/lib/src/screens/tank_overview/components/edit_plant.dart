import 'dart:io';

import 'package:flutter/material.dart';
import 'package:water_plant/objects/plant/plant.dart';
import 'package:water_plant/objects/watertankdevice/water_tank_device.dart';
import 'package:image_picker/image_picker.dart';
import 'package:water_plant/src/screens/tank_overview/components/widgets/form_title.dart';

import 'package:water_plant/constants.dart' as Constants;

class EditPlant extends StatefulWidget {
  final WaterTankDevice tank;
  final Plant plant;

  /// Refresh previous pages.
  final Function callback;

  String _plantNickname = '';
  String _selectedPlantType = '';
  String _selectedWaterTankPipe = '';
  EditPlant(this.tank, this.plant, this.callback) {
    _plantNickname = plant.nickname;
    _selectedPlantType = plant.plantTypeName;
    _selectedWaterTankPipe = '${tank.pipeConnectedTo(plant)}';
  }

  @override
  _EditPlantState createState() => _EditPlantState();
}

class _EditPlantState extends State<EditPlant> {
  final _formKeyPlantName = GlobalKey<FormState>();
  final _formKeyTankPipe = GlobalKey<FormState>();
  final _formKeyPlantType = GlobalKey<FormState>();

  File pictureFile;

  /// Opens the gallery on the phone and lets users choose a picture.
  imageSelectorGallery() async {
    pictureFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    print("You selected gallery image : " + pictureFile.path);
    setState(() {});
  }

  /*imageSelectorCamera() async {
    pictureFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    print("You selected camera image : " + pictureFile.path);
    setState(() {});
  }*/

  /// Shows a picture selected from phone gallery.
  Widget displaySelectedFile(File file) {
    return Container(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () async => await imageSelectorGallery(),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
            ),
          ),
          height: 130.0,
          width: 130.0,
          child: file == null
              ? Align(
                  alignment: Alignment.center,
                  child: widget.plant.chosenImageFile == null
                      ? Image.asset(
                          widget.plant.plantTypeImage,
                        )
                      : Image.file(
                          widget.plant.chosenImageFile,
                          cacheHeight: 130,
                          cacheWidth: 130,
                        ),
                )
              : Image.file(
                  file,
                  cacheHeight: 130,
                  cacheWidth: 130,
                ),
        ),
      ),
    );
  }

  /// Returns all pipes available and the pipe belonging to [plant].
  ///
  /// As an example - if all four pipes in the [tank] are connected to a plant
  ///  and [plant] is connected to pipe 1 in the tank, we get ['1'] in return.
  /// ```
  /// print(availablePipes(tank, plant)); // ['1']
  /// ```
  List<String> availablePipes(WaterTankDevice tank, Plant plant) {
    List<String> pipes = [];
    tank.availablePipes().forEach((pipe) {
      pipes.add('$pipe');
    });
    pipes.add('${tank.pipeConnectedTo(plant)}');
    pipes.sort();
    return pipes;
  }

  final double _formHeight = 48;
  @override
  Widget build(BuildContext context) {
    bool pressedYes = false;
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
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: 30,
                ),
                child: displaySelectedFile(pictureFile),
              ),
              Container(
                alignment: Alignment.center,
                child: FlatButton(
                  child: Text(
                    'Change photo',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  onPressed: () async => await imageSelectorGallery(),
                ),
              ),
              /*RaisedButton(
                  child: Text('Select image from camera'),
                  onPressed: () async => await imageSelectorCamera(),
                ),*/

              FormTitle('Plant name'),
              Card(
                elevation: 5,
                margin: EdgeInsets.all(0),
                child: Container(
                  height: _formHeight,
                  padding: EdgeInsets.only(left: 12),
                  color: Colors.white,
                  child: Form(
                    key: _formKeyPlantName,
                    child: TextFormField(
                      maxLength: Constants.MAX_CHARS_DEVICE_NAME,
                      onSaved: (value) => widget._plantNickname = value,
                      validator: (value) =>
                          value.isEmpty ? 'Please select a name' : null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        contentPadding: EdgeInsets.all(0),
                      ),
                      initialValue: widget._plantNickname,
                    ),
                  ),
                ),
              ),
              FormTitle('Tank pipe'),
              Card(
                elevation: 5,
                margin: EdgeInsets.all(0),
                child: Container(
                  height: _formHeight,
                  padding: EdgeInsets.only(left: 12),
                  alignment: Alignment.centerLeft,
                  color: Colors.white,
                  child: Form(
                    key: _formKeyTankPipe,
                    autovalidate: true,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        contentPadding: EdgeInsets.all(0),
                      ),
                      hint: Text('Select a pipe'),
                      value: widget._selectedWaterTankPipe,
                      validator: (value) =>
                          value == null ? 'Please select a pipe' : null,
                      items: availablePipes(widget.tank, widget.plant)
                          .map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (String value) {
                        setState(() {
                          widget._selectedWaterTankPipe = value;
                        });
                      },
                      isExpanded: true,
                    ),
                  ),
                ),
              ),
              FormTitle('Type of plant'),
              Card(
                elevation: 5,
                margin: EdgeInsets.all(0),
                child: Container(
                  padding: EdgeInsets.only(left: 12),
                  alignment: Alignment.centerLeft,
                  color: Colors.white,
                  child: Form(
                    key: _formKeyPlantType,
                    autovalidate: true,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        contentPadding: EdgeInsets.all(0),
                      ),
                      validator: (value) =>
                          value == null ? 'Please select type of plant' : null,
                      value: widget._selectedPlantType,
                      items: [
                        'Chinese Evergreen',
                        'Emerald palm',
                        'Orchid',
                        'Yucca Palm',
                        'Cocos Palm',
                        'Money Tree',
                        'Queen Palm',
                        'Benjamin Fig',
                        'Bonsai Ficus',
                        'Janet Lind',
                      ].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (String value) {
                        setState(() {
                          widget._selectedPlantType = value;
                        });
                      },
                      isExpanded: true,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 35),
                alignment: Alignment.center,
                child: RaisedButton(
                  elevation: 4,
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  child: Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: Text(
                      'Edit Plant',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (!(_formKeyPlantName.currentState.validate() &&
                        _formKeyPlantType.currentState.validate() &&
                        _formKeyTankPipe.currentState.validate())) {
                      return;
                    }

                    // All forms are filled out correctly
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: Container(
                          width: 200,
                          child: Text(
                              'Are you sure you want to save these changes?'),
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
                              _submit();
                            },
                          ),
                        ],
                        elevation: 10,
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 10,
                ),
                alignment: Alignment.center,
                child: RaisedButton(
                  elevation: 4,
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 30,
                      right: 30,
                    ),
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: Container(
                          width: 200,
                          child: Text('Delete the plant?'),
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
                              pressedYes = true;
                              if (widget.tank.removePlant(widget.plant)) {
                                widget.callback();
                              }
                              Navigator.pop(context);
                            },
                          ),
                        ],
                        elevation: 10,
                      ),
                    );
                    if (pressedYes) {
                      Navigator.pop(context, [
                        'Remove',
                        int.parse(widget._selectedWaterTankPipe),
                        widget.plant
                      ]);
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Confirm the edit.
  void _submit() {
    bool chosenTankPipe = false;
    bool chosenPlantName = false;
    bool chosenPlantType = false;

    if (_formKeyTankPipe.currentState.validate()) {
      _formKeyTankPipe.currentState.save();
      chosenTankPipe = true;
    }
    if (_formKeyPlantName.currentState.validate()) {
      _formKeyPlantName.currentState.save();
      chosenPlantName = true;
    }
    if (_formKeyPlantType.currentState.validate()) {
      _formKeyPlantType.currentState.validate();
      chosenPlantType = true;
    }

    if (chosenTankPipe && chosenPlantName && chosenPlantType) {
      var plantTypeInfo = Constants.ALL_PLANTS_INFORMATION.firstWhere(
          (element) => element['name'] == widget._selectedPlantType);

      assert(plantTypeInfo != null);
      setState(() {
        widget.plant.plantTypeInfo = plantTypeInfo;
        widget.plant.nickname = widget._plantNickname;
        widget.tank.pipeConnections[widget.plant] =
            int.parse(widget._selectedWaterTankPipe);
        if (pictureFile != null) {
          widget.plant.chosenImageFile = pictureFile;
        }
      });
      widget.callback();
      Navigator.pop(context, ['Edit', widget.plant]);
    }
  }
}
