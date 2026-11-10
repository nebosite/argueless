import 'content_library.dart';

/// Where the practice content comes from. Today it is the JSON shipped with
/// the app (`JsonContentSource`); a generated or downloaded library can
/// implement this too.
abstract interface class ContentSource {
  /// The whole library. Throws a `ContentFormatException` if the content is
  /// malformed.
  Future<ContentLibrary> load();
}
