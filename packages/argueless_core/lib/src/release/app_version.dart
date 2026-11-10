/// A `major.minor.patch` version. A new feature bumps minor and zeroes
/// patch; a bug fix bumps patch.
class AppVersion implements Comparable<AppVersion> {
  const AppVersion(this.major, this.minor, this.patch);

  /// Reads "0.1.0"; a build suffix such as "+3" is ignored.
  factory AppVersion.parse(String text) {
    final parts = text.split('+').first.trim().split('.');
    final numbers = parts.map(int.tryParse).toList();
    if (numbers.length != 3 || numbers.any((n) => n == null || n < 0)) {
      throw FormatException('Not a major.minor.patch version: $text');
    }
    return AppVersion(numbers[0]!, numbers[1]!, numbers[2]!);
  }

  final int major;
  final int minor;
  final int patch;

  @override
  int compareTo(AppVersion other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    return patch.compareTo(other.patch);
  }

  @override
  bool operator ==(Object other) =>
      other is AppVersion && compareTo(other) == 0;

  @override
  int get hashCode => Object.hash(major, minor, patch);

  @override
  String toString() => '$major.$minor.$patch';
}
