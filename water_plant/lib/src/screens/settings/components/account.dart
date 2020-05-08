import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:water_plant/constants.dart' as Constants;
import 'package:water_plant/src/screens/settings/components/widgets/form_card.dart';
import 'package:water_plant/src/screens/settings/components/widgets/form_title.dart';
import 'package:water_plant/src/screens/settings/components/widgets/page_title.dart';

/// Account settings in settings
class AccountSettings extends StatefulWidget {
  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final _formKeyUsername = new GlobalKey<FormState>();
  final _formKeyEmail = new GlobalKey<FormState>();
  final _formKeyMobileNumber = new GlobalKey<FormState>();

  String _userName = '';
  String _email = '';
  String _mobileNumber = '';

  bool _sendSMS = false;
  bool _sendEmail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Container(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: Image.asset('assets/logo_white_background.png'),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              PageTitle('Account'),
              formTitle('Username'),
              FormCard(
                child: Form(
                  key: _formKeyUsername,
                  child: TextFormField(
                    maxLength: Constants.MAX_CHARS_DEVICE_NAME,
                    onSaved: (value) => _userName = value,
                    validator: (value) =>
                        value.isEmpty ? 'Username cannot be empty' : null,
                    decoration: InputDecoration(
                      hintText: '',
                      border: InputBorder.none,
                      counterText: '',
                    ),
                  ),
                ),
              ),
              formTitle('E-mail address'),
              FormCard(
                child: Form(
                  key: _formKeyEmail,
                  child: TextFormField(
                    maxLength: Constants.MAX_CHARS_DEVICE_NAME,
                    onSaved: (value) => _email = value,
                    validator: (value) =>
                        value.isEmpty ? 'Username cannot be empty' : null,
                    decoration: InputDecoration(
                      hintText: 'example@example.com',
                      border: InputBorder.none,
                      counterText: '',
                    ),
                  ),
                ),
              ),
              formTitle('Mobile number'),
              Row(
                children: <Widget>[
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.all(0),
                    child: Container(
                      width: 80,
                      height: 48,
                      child: CountryCodePicker(
                        onChanged: print,
                        initialSelection: 'NO',
                        favorite: ['+47', 'NO'],
                        showFlag: false,
                        countryFilter: [
                          'AF',
                          'AL',
                          'DZ',
                          'AD',
                          'AO',
                          'AG',
                          'AR',
                          'AM',
                          'AU',
                          'AT',
                          'AZ',
                          'BS',
                          'BH',
                          'BD',
                          'BB',
                          'BY',
                          'BE',
                          'BZ',
                          'BJ',
                          'BT',
                          'BO',
                          'BA',
                          'BW',
                          'BR',
                          'BN',
                          'BG',
                          'BF',
                          'BI',
                          'CV',
                          'KH',
                          'CM',
                          'CA',
                          'CF',
                          'TD',
                          'CL',
                          'CN',
                          'CO',
                          'KM',
                          'CG',
                          'CD',
                          'CR',
                          'CI',
                          'HR',
                          'CU',
                          'CY',
                          'CZ',
                          'DK',
                          'DJ',
                          'DM',
                          'DO',
                          'EC',
                          'EG',
                          'SV',
                          'GQ',
                          'ER',
                          'EE',
                          'SZ',
                          'ET',
                          'FJ',
                          'FI',
                          'FR',
                          'GA',
                          'GM',
                          'GE',
                          'DE',
                          'GH',
                          'GR',
                          'GD',
                          'GT',
                          'GN',
                          'GY',
                          'HT',
                          'VA',
                          'HN',
                          'HU',
                          'IS',
                          'IN',
                          'ID',
                          'IR',
                          'IQ',
                          'IE',
                          'IL',
                          'IT',
                          'JM',
                          'JP',
                          'JO',
                          'KZ',
                          'KE',
                          'KI',
                          'KP',
                          'KR',
                          'KW',
                          'KG',
                          'LA',
                          'LV',
                          'LB',
                          'LS',
                          'LR',
                          'LY',
                          'LI',
                          'LT',
                          'LU',
                          'MG',
                          'MW',
                          'MY',
                          'MV',
                          'ML',
                          'MT',
                          'MH',
                          'MR',
                          'MU',
                          'MX',
                          'FM',
                          'MD',
                          'MC',
                          'MN',
                          'ME',
                          'MA',
                          'MZ',
                          'MM',
                          'NA',
                          'NR',
                          'NP',
                          'NL',
                          'NZ',
                          'NI',
                          'NE',
                          'NG',
                          'MK',
                          'NO',
                          'OM',
                          'PK',
                          'PW',
                          'PA',
                          'PG',
                          'PY',
                          'PE',
                          'PH',
                          'PL',
                          'PT',
                          'QA',
                          'RO',
                          'RU',
                          'RW',
                          'KN',
                          'LC',
                          'VC',
                          'WS',
                          'SM',
                          'ST',
                          'SA',
                          'SN',
                          'RS',
                          'SC',
                          'SL',
                          'SG',
                          'SK',
                          'SI',
                          'SB',
                          'SO',
                          'ZA',
                          'SS',
                          'ES',
                          'LK',
                          'SD',
                          'SR',
                          'SE',
                          'CH',
                          'SY',
                          'TJ',
                          'TZ',
                          'TH',
                          'TL',
                          'TG',
                          'TO',
                          'TT',
                          'TN',
                          'TR',
                          'TM',
                          'TV',
                          'UG',
                          'UA',
                          'AE',
                          'GB',
                          'US',
                          'UY',
                          'UZ',
                          'VU',
                          'VE',
                          'VN',
                          'YE',
                          'ZM',
                          'ZW',
                        ],
                        showFlagDialog: true,
                        comparator: (a, b) => b.name.compareTo(a.name),
                        // Get the country information relevant to the initial selection
                        onInit: (code) =>
                            print("on init ${code.name} ${code.dialCode}"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FormCard(
                      topPadding: 20,
                      child: Row(
                        children: <Widget>[
                          Form(
                            key: _formKeyMobileNumber,
                            child: Expanded(
                              child: TextFormField(
                                maxLength: Constants.MAX_CHARS_DEVICE_NAME,
                                onSaved: (value) => _mobileNumber = value,
                                validator: (value) => value.isEmpty
                                    ? 'Username cannot be empty'
                                    : null,
                                decoration: InputDecoration(
                                  hintText: '111 11 111',
                                  border: InputBorder.none,
                                  counterText: '',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              formTitle('Notification'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('SMS:'),
                  Checkbox(
                    value: _sendSMS,
                    onChanged: (bool value) {
                      setState(() {
                        _sendSMS = !_sendSMS;
                      });
                    },
                  ),
                  Text('  E-mail:'),
                  Checkbox(
                    value: _sendEmail,
                    onChanged: (bool value) {
                      setState(
                        () {
                          _sendEmail = !_sendEmail;
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
