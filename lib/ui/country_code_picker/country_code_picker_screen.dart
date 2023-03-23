import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:test_task_phone_verifying/constants.dart';
import 'package:test_task_phone_verifying/ui/custom_container/custom_container.dart';

import '../provider/contry_code_provider.dart';

class CountryPickerScreen extends StatefulWidget {
  const CountryPickerScreen({super.key});

  @override
  State<CountryPickerScreen> createState() => _CountryPickerScreenState();
}

class _CountryPickerScreenState extends State<CountryPickerScreen> {
  List<Country>? _filteredList;
  Position? _currentPosition;
  String? _currentAddress;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 80,
            child: Stack(
              children: [
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    AppLocalizations.of(context)!.countryCodeAppBar,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                Positioned(
                  right: 15,
                  top: 15,
                  child: CustomContainer(
                    padding: 4,
                    radius: 5,
                    child: const Icon(
                      Icons.close_sharp,
                      size: 13,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
          ),
          FutureBuilder(
            future: getCountries(context),
            builder:
                (BuildContext context, AsyncSnapshot<List<Country>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              _filteredList ??= snapshot.data;

              return Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 48,
                      margin: const EdgeInsets.all(16),
                      child: TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText:
                              AppLocalizations.of(context)!.textFieldSearch,
                        ),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              _filteredList!.clear();
                              _filteredList!.addAll(snapshot.data!);
                            });
                          } else {
                            setState(
                              () {
                                _filteredList = snapshot.data!
                                    .where((element) =>
                                        element.name.toLowerCase().contains(
                                            value.toString().toLowerCase()) ||
                                        element.callingCode
                                            .toLowerCase()
                                            .contains(value
                                                .toString()
                                                .toLowerCase()) ||
                                        element.countryCode
                                            .toLowerCase()
                                            .startsWith(
                                                value.toString().toLowerCase()))
                                    .map((e) => e)
                                    .toList();
                              },
                            );
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                _filteredList![index].flag,
                                package: countryCodePackageName,
                                width: 32,
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(_filteredList![index].callingCode),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    _filteredList![index].name,
                                    style: const TextStyle(
                                      color: Color(mainTextColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Provider.of<CountryCodeProvider>(
                                context,
                                listen: false,
                              ).changeCountry(
                                  _filteredList![index].countryCode);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: const Color(colorMain),
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.location_on),
          onPressed: () {
            _getCurrentPlace().then((value) {
              if (value.length == 2) {
                Provider.of<CountryCodeProvider>(
                  context,
                  listen: false,
                ).changeCountry(value);
                Navigator.of(context).pop();
              }
            });
          },
        ),
      ),
    );
  }

  Future<String> _getCurrentPlace() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('error');
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('error');
    }
    var position = await Geolocator.getCurrentPosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];

    return place.isoCountryCode!;
  }
}
