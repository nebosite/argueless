import 'content_format_exception.dart';

/// Typed reads from a decoded JSON object, failing with a
/// [ContentFormatException] that names the missing or wrong field.
class JsonFields {
  JsonFields(Object? json, this.where)
    : _map = json is Map<String, dynamic>
          ? json
          : throw ContentFormatException('$where is not an object');

  final Map<String, dynamic> _map;
  final String where;

  bool has(String key) => _map[key] != null;

  String string(String key) {
    final value = _map[key];
    if (value is String && value.trim().isNotEmpty) return value;
    throw ContentFormatException('$where.$key must be a non-empty string');
  }

  int integer(String key) {
    final value = _map[key];
    if (value is int) return value;
    throw ContentFormatException('$where.$key must be a whole number');
  }

  List<String> strings(String key) {
    final items = list(key);
    return [
      for (var i = 0; i < items.length; i++) _item(items, i, '$where.$key'),
    ];
  }

  List<Object?> list(String key) {
    final value = _map[key];
    if (value is List) return value;
    throw ContentFormatException('$where.$key must be a list');
  }

  JsonFields object(String key) => JsonFields(_map[key], '$where.$key');

  Map<String, dynamic> get raw => _map;

  static String _item(List<Object?> list, int i, String where) {
    final value = list[i];
    if (value is String && value.trim().isNotEmpty) return value;
    throw ContentFormatException('$where[$i] must be a non-empty string');
  }
}
