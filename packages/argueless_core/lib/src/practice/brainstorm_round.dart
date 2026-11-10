import '../content/rubric.dart';
import '../content/rubric_kind.dart';
import 'round_record.dart';

/// One brainstorm in a practice: the user's own ideas, the suggestions they
/// liked once they saw them, and how they rated themselves.
class BrainstormRound {
  BrainstormRound({
    required this.kind,
    required this.rubric,
    required this.suggestions,
  });

  final RubricKind kind;
  final Rubric rubric;

  /// The content's suggested answers, shown after the brainstorm.
  final List<String> suggestions;

  List<String> _ideas = const [];
  final Set<int> _liked = {};
  final Map<String, int> _ratings = {};

  /// The user's own ideas, trimmed, without blanks.
  List<String> get ideas => _ideas;

  set ideas(List<String> value) => _ideas = [
    for (final idea in value)
      if (idea.trim().isNotEmpty) idea.trim(),
  ];

  bool get hasIdeas => _ideas.isNotEmpty;

  bool isLiked(int suggestion) => _liked.contains(suggestion);

  void toggleLiked(int suggestion) {
    RangeError.checkValidIndex(suggestion, suggestions);
    if (!_liked.remove(suggestion)) _liked.add(suggestion);
  }

  /// The suggestions the user liked, in their original order.
  List<String> get liked => [
    for (var i = 0; i < suggestions.length; i++)
      if (_liked.contains(i)) suggestions[i],
  ];

  int? rating(String criterionId) => _ratings[criterionId];

  void rate(String criterionId, int value) {
    if (!rubric.criteria.any((c) => c.id == criterionId)) {
      throw ArgumentError.value(criterionId, 'criterionId', 'not in rubric');
    }
    _ratings[criterionId] = value;
  }

  /// Every criterion has a rating.
  bool get isRated => rubric.criteria.every((c) => _ratings.containsKey(c.id));

  RoundRecord toRecord() =>
      RoundRecord(ideas: ideas, liked: liked, ratings: Map.of(_ratings));
}
