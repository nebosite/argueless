/// Content that does not match the format the app understands.
class ContentFormatException implements Exception {
  ContentFormatException(this.message);

  final String message;

  @override
  String toString() => 'ContentFormatException: $message';
}
