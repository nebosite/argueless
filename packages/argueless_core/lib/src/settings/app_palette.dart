/// The theme colours the user can choose from, as ARGB values. The first is
/// the default. Each is dark enough for white text on it.
class AppPalette {
  const AppPalette._();

  static const themeColors = [
    0xFF5B4BDB, // violet
    0xFF1F5FBF, // ocean
    0xFF00796B, // teal
    0xFF2E7D32, // forest
    0xFFAD1457, // berry
    0xFF455A64, // slate
  ];

  /// What each colour is called, for screen readers and tooltips.
  static const names = {
    0xFF5B4BDB: 'Violet',
    0xFF1F5FBF: 'Ocean',
    0xFF00796B: 'Teal',
    0xFF2E7D32: 'Forest',
    0xFFAD1457: 'Berry',
    0xFF455A64: 'Slate',
  };
}
