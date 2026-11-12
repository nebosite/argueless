import 'app_palette.dart';
import 'appearance.dart';

/// The user's choices for how the app looks. Reminders keep their own
/// settings (`ReminderSettings`).
class AppSettings {
  const AppSettings({
    this.appearance = Appearance.system,
    this.themeColor = defaultThemeColor,
    this.textPercent = defaultTextPercent,
  });

  /// Reads what [toJson] wrote. Never throws: a missing, mistyped or
  /// unknown value takes its default, and the text size is clamped.
  factory AppSettings.fromJson(Object? json) {
    if (json is! Map) return const AppSettings();
    final colour = json['themeColor'];
    final percent = json['textPercent'];
    return AppSettings(
      appearance:
          Appearance.fromWireId(json['appearance']) ?? Appearance.system,
      themeColor: colour is int && AppPalette.themeColors.contains(colour)
          ? colour
          : defaultThemeColor,
      textPercent: percent is num && percent.isFinite
          ? percent.round().clamp(textPercentRange.min, textPercentRange.max)
          : defaultTextPercent,
    );
  }

  static const defaultThemeColor = 0xFF5B4BDB; // AppPalette.themeColors.first
  static const defaultTextPercent = 70;
  static const textPercentRange = (min: 50, max: 150);

  final Appearance appearance;

  /// Buttons and highlights, from [AppPalette.themeColors].
  final int themeColor;

  /// Text size as a percentage of normal, on top of the phone's own size.
  final int textPercent;

  AppSettings copyWith({
    Appearance? appearance,
    int? themeColor,
    int? textPercent,
  }) => AppSettings(
    appearance: appearance ?? this.appearance,
    themeColor: themeColor ?? this.themeColor,
    textPercent: textPercent ?? this.textPercent,
  );

  Map<String, dynamic> toJson() => {
    'appearance': appearance.wireId,
    'themeColor': themeColor,
    'textPercent': textPercent,
  };

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.appearance == appearance &&
      other.themeColor == themeColor &&
      other.textPercent == textPercent;

  @override
  int get hashCode => Object.hash(appearance, themeColor, textPercent);
}
