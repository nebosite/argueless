/// The two moments in a practice where the user rates themselves.
enum RubricKind {
  /// After comparing their reframes (new thoughts) with the suggestions.
  reframe('reframe'),

  /// After comparing their phrases (words to say) with the suggestions.
  phrases('phrases');

  const RubricKind(this.wireId);

  /// The key in content and saved records.
  final String wireId;

  static RubricKind? fromWireId(String? id) {
    for (final kind in values) {
      if (kind.wireId == id) return kind;
    }
    return null;
  }
}
