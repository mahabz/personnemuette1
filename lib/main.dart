import 'package:flutter/material.dart';
import '/interfaces/intro_screen.dart';
import '../utils/user_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();

  String languageCode = await UserPreferences.getLanguage() ?? 'en';

  runApp(MyApp(languageCode: languageCode));
}

class MyApp extends StatelessWidget {
  final String languageCode;

  // ✅ On rend `languageCode` optionnel avec une valeur par défaut
  const MyApp({super.key, this.languageCode = 'en'});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personne Muette',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      locale: Locale(languageCode),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('fr', ''),
        Locale('es', ''),
        Locale('de', ''),
        Locale('ar', ''),
      ],
      home: const IntroScreen(), // Ajout du `const` si possible
    );
  }
}
