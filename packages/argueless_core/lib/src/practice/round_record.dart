/// What was kept from one brainstorm: the user's ideas, the suggestions they
/// liked (as text, so a content update cannot change history), and their
/// self-ratings by criterion id.
class RoundRecord {
  const RoundRecord({
    this.ideas = const [],
    this.liked = const [],
    this.ratings = const {},
  });

  factory RoundRecord.fromJson(Map<String, dynamic> json) => RoundRecord(
    ideas: [for (final i in json['ideas'] as List? ?? const []) i as String],
    liked: [for (final i in json['liked'] as List? ?? const []) i as String],
    ratings: {
      for (final e in (json['ratings'] as Map? ?? const {}).entries)
        e.key as String: e.value as int,
    },
  );

  final List<String> ideas;
  final List<String> liked;
  final Map<String, int> ratings;

  /// The average self-rating, or null if nothing was rated.
  double? get averageRating => ratings.isEmpty
      ? null
      : ratings.values.reduce((a, b) => a + b) / ratings.length;

  Map<String, dynamic> toJson() => {
    'ideas': ideas,
    'liked': liked,
    'ratings': ratings,
  };
}
