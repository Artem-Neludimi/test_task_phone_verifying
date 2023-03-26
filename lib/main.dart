import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:test_task_phone_verifying/ui/provider/country_code_provider.dart';
import 'constants.dart';
import 'ui/home/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CountryCodeProvider>(
      create: (context) => CountryCodeProvider(),
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate
        ],
        supportedLocales: const [
          Locale('en'),
        ],
        theme: ThemeData(
          canvasColor: const Color(colorBackground),
          iconTheme: const IconThemeData(color: Color(secondaryTextColor)),
          inputDecorationTheme: const InputDecorationTheme(
            contentPadding: EdgeInsets.only(left: 8),
            hintStyle: TextStyle(
              color: Color(secondaryTextColor),
            ),
            prefixIconColor: Color(secondaryTextColor),
            filled: true,
            fillColor: Color(colorMain),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
          ),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(secondaryTextColor),
          ),
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              color: Color(mainTextColor),
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
            bodyMedium: TextStyle(
              color: Color(secondaryTextColor),
            ),
            titleSmall: TextStyle(
              color: Color(secondaryTextColor),
            ),
            titleMedium: TextStyle(
              color: Color(secondaryTextColor),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) => MaterialWithModalsPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      ),
    );
  }
}
