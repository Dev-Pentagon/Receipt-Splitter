extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String get getInitials {
    // Split the name into words
    List<String> words = trim().split(' ');

    // Extract the first letter of each word and join them
    String initials = words.map((word) => word[0].toUpperCase()).join();

    return initials;
  }
}