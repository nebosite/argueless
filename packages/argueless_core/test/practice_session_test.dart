import 'package:argueless_core/argueless_core.dart';
import 'package:test/test.dart';

import 'fixtures.dart';

void main() {
  final start = DateTime(2026, 11, 10, 8);

  PracticeSession session({String subject = 'one'}) => PracticeSession(
    scenario: testLibrary().scenario('$subject-1')!,
    library: testLibrary(),
    startedAt: start,
  );

  void rateAll(BrainstormRound round) {
    for (final c in round.rubric.criteria) {
      round.rate(c.id, 3);
    }
  }

  test('walks every step and records what the user did', () {
    final s = session();
    expect(s.step, PracticeStep.reframes);
    expect(s.canAdvance, isFalse);

    s.reframes.ideas = ['  Maybe they know something ', '', 'Ask first'];
    s.advance();
    expect(s.step, PracticeStep.reframeReview);
    s.reframes.toggleLiked(1);
    expect(s.canAdvance, isFalse, reason: 'not rated yet');
    rateAll(s.reframes);
    s.advance();

    s.phrases.ideas = ['Tell me more?'];
    s.advance();
    s.phrases.toggleLiked(0);
    rateAll(s.phrases);
    s.advance();
    expect(s.step, PracticeStep.roleplay);

    expect(s.favouriteChoices, ['Tell me more?', 'p1']);
    s.chooseFavourite('p1');
    expect(s.reply, 'p1', reason: 'the reply starts as the favourite');
    s.reply = 'p1, and I mean it.';
    s.advance();
    expect(s.step, PracticeStep.done);

    final record = s.record(finishedAt: start.add(const Duration(minutes: 7)));
    expect(record.reframes.ideas, ['Maybe they know something', 'Ask first']);
    expect(record.reframes.liked, ['r2']);
    expect(record.reframes.ratings, {'a': 3, 'b': 3});
    expect(record.favourite, 'p1');
    expect(record.reply, 'p1, and I mean it.');
    expect(record.ideaCount, 3);
    expect(record.duration, const Duration(minutes: 7));
  });

  test('uses the subject rubric when it has one', () {
    expect(session(subject: 'two').reframes.rubric.title, 'Special');
    expect(session(subject: 'two').phrases.rubric.title, 'Rate');
  });

  test('refuses to skip an unfinished step', () {
    expect(() => session().advance(), throwsStateError);
  });

  test('offers every suggestion when the user has no phrases to pick', () {
    final s = session();
    expect(s.favouriteChoices, ['p1', 'p2', 'p3']);
  });

  test('cannot record before the end', () {
    expect(() => session().record(finishedAt: start), throwsStateError);
  });

  test('toggling a like twice removes it', () {
    final round = session().reframes;
    round.toggleLiked(2);
    round.toggleLiked(2);
    expect(round.liked, isEmpty);
  });

  test('rejects a rating for a criterion not in the rubric', () {
    expect(() => session().reframes.rate('nope', 2), throwsArgumentError);
  });
}
