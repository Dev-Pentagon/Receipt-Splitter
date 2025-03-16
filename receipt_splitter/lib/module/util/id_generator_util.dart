import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_config.dart';

class IdGeneratorUtil {
  // Map to store counters for each IdentifierType.
  static final Map<IdentifierType, int> _counters = {
    IdentifierType.receipt: 0,
    IdentifierType.menuItem: 0,
    IdentifierType.participant: 0,
  };

  // Prefix for storing counter values in SharedPreferences.
  static const String _counterKeyPrefix = 'id_counter_';

  /// Call this method during app initialization to load saved counters.
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    for (var type in IdentifierType.values) {
      // Load saved counter value, or default to 0 if not present.
      _counters[type] = prefs.getInt('$_counterKeyPrefix${type.name}') ?? 0;
    }
  }

  /// Generates a unique ID for the given [type] and persists the updated counter.
  static Future<String> generateId(IdentifierType type) async {
    final prefs = await SharedPreferences.getInstance();
    // Increment the counter for the provided type.
    _counters[type] = (_counters[type] ?? 0) + 1;
    // Format the counter with leading zeros for a consistent length.
    String counterString = _counters[type]!.toString().padLeft(6, '0');
    String id = '${type.code}$counterString';
    // Save the updated counter back to SharedPreferences.
    await prefs.setInt('$_counterKeyPrefix${type.name}', _counters[type]!);
    return id;
  }
}
