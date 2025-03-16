import '../config/app_config.dart';

class DateTimeService {


  static String dayMonthYear(DateTime date) {
    return dateFormatter.format(date);
  }
}