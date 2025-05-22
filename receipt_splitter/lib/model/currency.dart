class Currency {
  ///The currency code
  final String code;

  ///The currency name in English
  final String name;

  ///The currency symbol
  final String symbol;

  ///The currency flag code
  ///
  /// To get flag unicode(Emoji) use [CurrencyUtils.currencyToEmoji]
  final String? flag;

  ///The currency number
  final int number;

  ///The currency decimal digits
  final int decimalDigits;

  ///The currency plural name in English
  final String namePlural;

  ///The decimal separator
  final String decimalSeparator;

  ///The thousands separator
  final String thousandsSeparator;

  ///True if symbol is on the Left of the amount
  final bool symbolOnLeft;

  ///True if symbol has space with amount
  final bool spaceBetweenAmountAndSymbol;

  bool get isFlagImage => flag?.endsWith('.png') ?? false;

  Currency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.flag,
    required this.number,
    required this.decimalDigits,
    required this.namePlural,
    required this.symbolOnLeft,
    required this.decimalSeparator,
    required this.thousandsSeparator,
    required this.spaceBetweenAmountAndSymbol,
  });

  Currency.from({required Map<String, dynamic> json})
    : code = json['code'],
      name = json['name'],
      symbol = json['symbol'],
      number = json['number'],
      flag = json['flag'],
      decimalDigits = json['decimal_digits'],
      namePlural = json['name_plural'],
      symbolOnLeft = json['symbol_on_left'],
      decimalSeparator = json['decimal_separator'],
      thousandsSeparator = json['thousands_separator'],
      spaceBetweenAmountAndSymbol = json['space_between_amount_and_symbol'];

  Map<String, dynamic> toJson() => {
    'code': code,
    'name': name,
    'symbol': symbol,
    'number': number,
    'flag': flag,
    'decimal_digits': decimalDigits,
    'name_plural': namePlural,
    'symbol_on_left': symbolOnLeft,
    'decimal_separator': decimalSeparator,
    'thousands_separator': thousandsSeparator,
    'space_between_amount_and_symbol': spaceBetweenAmountAndSymbol,
  };

  /// Formats an amount based on this currency’s properties.
  ///
  /// It formats the number to have the correct number of decimal digits,
  /// inserts custom thousands and decimal separators, and places the symbol
  /// on the left or right as specified.
  String formatAmount(double amount) {
    final formattedNumber = _formatNumber(amount);
    final space = spaceBetweenAmountAndSymbol ? " " : "";
    return symbolOnLeft ? "$symbol$space$formattedNumber" : "$formattedNumber$space$symbol";
  }

  String formatAmountWithCode(double amount) {
    final formattedNumber = _formatNumber(amount);
    return "$code $formattedNumber";
  }

  /// Helper method to format the number using the custom decimal and thousands separators.
  String _formatNumber(double amount) {
    // Round the number to the correct number of decimals.
    String fixed = amount.toStringAsFixed(decimalDigits);
    List<String> parts = fixed.split('.');
    String integerPart = parts[0];
    String fractionPart = parts.length > 1 ? parts[1] : '';

    // Insert the thousands separator manually.
    StringBuffer buffer = StringBuffer();
    int count = 0;
    // Process the integer part from right to left.
    for (int i = integerPart.length - 1; i >= 0; i--) {
      buffer.write(integerPart[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write(thousandsSeparator);
      }
    }
    // Reverse the string back to the correct order.
    String formattedInteger = buffer.toString().split('').reversed.join('');

    // Join integer and fractional parts with the custom decimal separator.
    return fractionPart.isNotEmpty ? "$formattedInteger$decimalSeparator$fractionPart" : formattedInteger;
  }
}
