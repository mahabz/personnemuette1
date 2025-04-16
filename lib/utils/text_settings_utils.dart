import 'package:flutter/widgets.dart';

class TextSettingsUtils {
  // Méthode statique pour vérifier si le texte est probablement en gras
  static bool isBoldTextEnabled(BuildContext context) {
    // Vérifie si l'échelle du texte est supérieure à 1, ce qui pourrait indiquer que le texte en gras est activé
    return MediaQuery.textScaleFactorOf(context) > 1.0;
  }

  // Méthode statique pour vérifier si le texte a une échelle agrandie (indiquant une option d'accessibilité active)
  static bool isTextScaleIncreased(BuildContext context) {
    // Si l'échelle du texte est supérieure à 1, cela signifie que l'utilisateur a probablement modifié la taille du texte
    return MediaQuery.textScaleFactorOf(context) > 1.0;
  }

  // Méthode statique pour vérifier la configuration d'accessibilité (ex. texte en gras ou échelle de texte augmentée)
  static void checkTextSettings(BuildContext context) {
    if (isBoldTextEnabled(context)) {
      // Si le texte en gras est activé
      print("Le texte est probablement en gras.");
    } else if (isTextScaleIncreased(context)) {
      // Si l'échelle du texte est augmentée
      print("L'échelle du texte est augmentée.");
    } else {
      // Si aucune de ces options n'est activée
      print("Le texte n'est ni en gras ni agrandi.");
    }
  }
}
