import 'package:bhashaverse/localization/hi.dart';
import 'package:get/get.dart';

import 'en.dart';

class AppLocalization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en_US': en, 'hi_IN': hi};
}
