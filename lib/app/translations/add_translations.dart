import 'dictionary/en_dictionary.dart';
import 'dictionary/ru_dictionary.dart';

abstract class AppTranslation {
  static Map<String, Map<String, String>> translations = {
    'en': en,
    'ru': ru,
  };
}
