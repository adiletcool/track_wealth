import 'dictionary/en_us_dictionary.dart';
import 'dictionary/ru_ru_dictionary.dart';

abstract class AppTranslation {
  static Map<String, Map<String, String>> translations = {
    'en_US': enUS,
    'ru_RU': ruRU,
  };
}
