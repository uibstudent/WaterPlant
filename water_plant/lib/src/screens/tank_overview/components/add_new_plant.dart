import 'dart:io';

import 'package:flutter/material.dart';
import 'package:water_plant/objects/plant/plant.dart';
import 'package:water_plant/objects/watertankdevice/water_tank_device.dart';
import 'package:image_picker/image_picker.dart';
import 'package:water_plant/src/screens/tank_overview/components/widgets/form_title.dart';

import 'package:water_plant/constants.dart' as Constants;

class AddNewPlant extends StatefulWidget {
  final WaterTankDevice tank;
  final Function addNewPlant;

  AddNewPlant(this.tank, this.addNewPlant);
  @override
  _AddNewPlantState createState() => _AddNewPlantState();
}

class _AddNewPlantState extends State<AddNewPlant> {
  final _formKeyPlantName = GlobalKey<FormState>();
  final _formKeyTankPipe = GlobalKey<FormState>();
  final _formKeyPlantType = GlobalKey<FormState>();

  String _plantNickname = '';
  File pictureFile;

  // Needs to be null because the value in DropdownButton needs to be null at first.
  String _selectedPlantType;

  // Needs to be null because the value in DropdownButton needs to be null at first.
  String _selectedWaterTankPipe;

  imageSelectorGallery() async {
    pictureFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    //print("You selected gallery image : " + pictureFile.path);
    setState(() {});
  }

  /*imageSelectorCamera() async {
    pictureFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    print("You selected camera image : " + pictureFile.path);
    setState(() {});
  }*/

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
                  child: Text('No image selected'),
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

  final double _formHeight = 48;
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
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(
                    top: 30,
                  ),
                  child: displaySelectedFile(pictureFile)),
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
                      initialValue: _plantNickname,
                      maxLength: Constants.MAX_CHARS_DEVICE_NAME,
                      onSaved: (value) => _plantNickname = value,
                      decoration: InputDecoration(
                        //helperText: ' ',
                        hintText:
                            'Default: Plant ${widget.tank.plants.length + 1}',
                        border: InputBorder.none,
                        counterText: '',
                        contentPadding: EdgeInsets.all(0),
                      ),
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
                    //autovalidate: true,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        contentPadding: EdgeInsets.all(0),
                      ),
                      hint: Text('Select a pipe'),
                      value: _selectedWaterTankPipe,
                      validator: (value) =>
                          value == null ? 'Please select a pipe' : null,
                      items: widget.tank
                          .availablePipes()
                          .map((e) => e.toString())
                          .map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (String value) {
                        setState(() {
                          _selectedWaterTankPipe = value;
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
                  height: _formHeight,
                  padding: EdgeInsets.only(left: 12),
                  alignment: Alignment.centerLeft,
                  color: Colors.white,
                  child: Form(
                    key: _formKeyPlantType,
                    //autovalidate: true,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        //helperText: ' ',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      hint: Text('Select a plant type'),
                      value: _selectedPlantType,
                      validator: (value) =>
                          value == null ? 'Please select type of plant' : null,
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
                          _selectedPlantType = value;
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
                      'Add Plant',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  onPressed: () {
                    _submit();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
      var plantTypeInfo = Constants.ALL_PLANTS_INFORMATION
          .firstWhere((element) => element['name'] == _selectedPlantType);

      assert(plantTypeInfo != null);

      if (_plantNickname.isEmpty) {
        _plantNickname = 'Plant ${widget.tank.plants.length + 1}';
      }

      Plant plant = Plant(
        0,
        nickname: _plantNickname,
        plantTypeInfo: plantTypeInfo,
        chosenImageFile: pictureFile,
      );

      widget.addNewPlant(int.parse(_selectedWaterTankPipe), plant);
      Navigator.pop(context, 'Added plant $_plantNickname');
    }
  }
}
