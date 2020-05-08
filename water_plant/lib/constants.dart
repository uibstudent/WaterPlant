library constants;

import 'package:flutter/material.dart';

const int ALLOWED_NUMBER_OF_PLANTS_IN_TANK = 4;

const int MAX_CHARS_DEVICE_NAME = 18;

class CustomColors {
//Colors
  static const Color SNACKBAR_ACTION_LABEL_COLOR = Colors.black;

  static const Color BOTTOM_NAVIGATION_BAR_COLOR =
      const Color(0xff5b7329); // dark green

  static const Color LIGHT_GREEN_COLOR = const Color(0xFFAEBF2A);

  static const Color BORDER_COLOR = const Color(0xFF424242); // grey[800]

  static const Color SCAFFOLD_BACKGROUND_COLOR =
      const Color(0xFFF2F2F0); // greywhite

  static const Color CARD_BACKGROUND_COLOR = SCAFFOLD_BACKGROUND_COLOR;

  static const Color WATER_LEVEL_FILL = Color(0xFF4A678C); //dark blue

  static const Color WATER_LEVEL_EMPTY = Colors.white;
}

class PlantPics {
// Plant pictures
  static const String PLANT_CHINESE_EVERGREEN =
      'assets/plants/plant_chinese_evergreen.jpg';

  static const String PLANT_EMERALD_PALM =
      'assets/plants/plant_emerald_palm.jpg';

  static const String PLANT_ORCHID = 'assets/plants/plant_orchid.jpg';

  static const String PLANT_BONSAI_FICUS =
      'assets/plants/plant_bonsai_ficus.jpg';

  static const String PLANT_COCOS_PALM = 'assets/plants/plant_cocos_palm.png';

  static const String PLANT_MONEY_TREE = 'assets/plants/plant_money_tree.jpg';

  static const String PLANT_QUEEN_PALM = 'assets/plants/plant_queen_palm.jpg';

  static const String PLANT_BENJAMIN_FIG =
      'assets/plants/plant_benjamin_fig.jpg';

  static const String PLANT_YUCCA_PALM = 'assets/plants/plant_yucca_palm.jpg';

  static const String PLANT_JANET_LIND = 'assets/plants/plant_janet_lind.jpg';
}

/// A map of information about each plant
const List<Map<String, dynamic>> ALL_PLANTS_INFORMATION = [
  {
    'name': 'Chinese Evergreen',
    'latinName': 'Aglaonema',
    'imageName': PlantPics.PLANT_CHINESE_EVERGREEN
  },
  {
    'name': 'Emerald palm',
    'latinName': 'Zamioculcas zamiifolia',
    'imageName': PlantPics.PLANT_EMERALD_PALM
  },
  {
    'name': 'Orchid',
    'latinName': 'Orchidaceae',
    'imageName': PlantPics.PLANT_ORCHID
  },
  {
    'name': 'Yucca Palm',
    'latinName': 'Yucca elephantipes',
    'imageName': PlantPics.PLANT_YUCCA_PALM
  },
  {
    'name': 'Cocos Palm',
    'latinName': 'Cocos nucifera',
    'imageName': PlantPics.PLANT_COCOS_PALM
  },
  {
    'name': 'Money Tree',
    'latinName': 'Crassula undilatifolia',
    'imageName': PlantPics.PLANT_MONEY_TREE
  },
  {
    'name': 'Queen Palm',
    'latinName': 'Livistonia Rotundifolia',
    'imageName': PlantPics.PLANT_QUEEN_PALM
  },
  {
    'name': 'Benjamin Fig',
    'latinName': 'Ficus Nitida',
    'imageName': PlantPics.PLANT_BENJAMIN_FIG
  },
  {
    'name': 'Bonsai Ficus',
    'latinName': 'Ficus microcarpa',
    'imageName': PlantPics.PLANT_BONSAI_FICUS
  },
  {
    'name': 'Janet Lind',
    'latinName': 'Dracaena Janet Lind',
    'imageName': PlantPics.PLANT_JANET_LIND
  },
];
