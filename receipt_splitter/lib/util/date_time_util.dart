import '../config/app_config.dart';

class DateTimeUtil {
  static String dayMonthYear(DateTime date) {
    return dateFormatter.format(date);
  }
}
