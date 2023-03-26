import 'package:flutter/material.dart';

class CountryCodeProvider extends ChangeNotifier {
  String _countryCode = 'UA';

  String get countryCode => _countryCode;

  void changeCountry(String countryCode) {
    _countryCode = countryCode;
  }
}
