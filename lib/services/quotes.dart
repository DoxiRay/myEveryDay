import 'dart:math';

class QuotesLibrary {
  static final List<String> _quotes = [
    "Le succès est la somme de petits efforts répétés jour après jour.",
    "Croyez en vos rêves et ils se réaliseront peut-être.",
    "La persévérance est la clé de la réussite.",
    "Agis comme s’il était impossible d’échouer.",
    "Celui qui déplace une montagne commence par déplacer de petites pierres.",
    "Chaque jour est une nouvelle chance de changer ta vie.",
    "La discipline est le pont entre les objectifs et les accomplissements.",
    "Ne regarde pas l’horloge, fais comme elle : avance.",
    "Les grands accomplissements commencent par une simple décision.",
    "La motivation te lance, mais la discipline te fait continuer.",
  ];

  static String getRandomQuote() {
    final random = Random();
    return _quotes[random.nextInt(_quotes.length)];
  }
}
