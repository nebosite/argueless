/// Light or dark pages, or whatever the phone uses.
enum Appearance {
  system('system'),
  light('light'),
  dark('dark');

  const Appearance(this.wireId);

  /// The value saved in the settings file.
  final String wireId;

  static Appearance? fromWireId(Object? id) {
    for (final a in values) {
      if (a.wireId == id) return a;
    }
    return null;
  }
}
