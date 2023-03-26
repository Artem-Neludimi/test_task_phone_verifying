import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:test_task_phone_verifying/constants.dart';
import 'package:test_task_phone_verifying/ui/custom_container/custom_container.dart';
import 'package:test_task_phone_verifying/ui/provider/country_code_provider.dart';
import '../country_code_picker/country_code_picker_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = MaskedTextController(mask: '(000) 000-0000');
  var _boolPhone = false;

  @override
  Widget build(BuildContext context) {
    final countryCode = Provider.of<CountryCodeProvider>(context).countryCode;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
              height: 130,
              padding: const EdgeInsets.only(left: 20),
              alignment: Alignment.bottomLeft,
              child: Text(
                AppLocalizations.of(context)!.homeAppBar,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FutureBuilder(
                          future: getCountryByCountryCode(context, countryCode),
                          builder: (BuildContext context,
                              AsyncSnapshot<Country?> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return CustomContainer(
                              padding: 12,
                              radius: 18,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.asset(
                                      snapshot.data!.flag,
                                      package: countryCodePackageName,
                                      width: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    snapshot.data!.callingCode,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              onTap: () {
                                showCupertinoModalBottomSheet(
                                  context: context,
                                  expand: true,
                                  builder: (context) =>
                                      const CountryPickerScreen(),
                                );
                              },
                            );
                          }),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                              hintText:
                                  AppLocalizations.of(context)!.phoneNumber),
                          onChanged: (value) {
                            setState(() {
                              if (_controller.text.length >= 14) {
                                _boolPhone = true;
                              } else {
                                _boolPhone = false;
                              }
                              if (_controller.text.length == 1) {
                                _controller.text = '';
                              }
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Color(_boolPhone ? mainTextColor : colorMain),
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
          boxShadow: _boolPhone
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]
              : [],
        ),
        child: IconButton(
          icon: const Icon(
            CupertinoIcons.arrow_right,
            size: 32,
          ),
          onPressed: _boolPhone
              ? () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content:
                            Text(AppLocalizations.of(context)!.phoneIsVerified),
                        actions: [
                          TextButton(
                            child: Text(AppLocalizations.of(context)!.ok),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    },
                  );
                }
              : null,
        ),
      ),
    );
  }
}
