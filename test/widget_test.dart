import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personnemuette/main.dart'; // Assure-toi que ce chemin est correct

void main() {
  testWidgets('Vérifie que MyApp s\'affiche', (WidgetTester tester) async {
    // Charge l'application dans le test avec MaterialApp
    await tester.pumpWidget(
      const MaterialApp(
        home: MyApp(),
      ),
    );

    // Vérifie que le widget MyApp est trouvé une fois dans l'arbre des widgets
    expect(find.byType(MyApp), findsOneWidget);
  });
}
