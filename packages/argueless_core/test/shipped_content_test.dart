import 'dart:io';

import 'package:argueless_core/argueless_core.dart';
import 'package:test/test.dart';

/// Checks the content that ships in the app, so a regenerated file that
/// breaks the format fails here rather than on a phone.
void main() {
  final folder = Directory('../../app/assets/content');

  late ContentLibrary library;

  setUpAll(() async {
    library = await JsonContentSource(
      (name) => File('${folder.path}/$name').readAsString(),
    ).load();
  });

  test('has the ten subjects, each with at least eight scenarios', () {
    expect(library.subjects.map((s) => s.id), [
      'letting-go',
      'confusion',
      'emotion',
      'rebuttal',
      'hear-it',
      'let-them-finish',
      'different-views',
      'both-parts',
      'kinder-mirror',
      'turning-toward',
    ]);
    for (final subject in library.subjects) {
      expect(
        library.scenariosFor(subject.id).length,
        greaterThanOrEqualTo(8),
        reason: subject.id,
      );
    }
  });

  test('an inner subject role-plays with a part of the user', () {
    for (final id in ['both-parts', 'kinder-mirror', 'turning-toward']) {
      for (final s in library.scenariosFor(id)) {
        expect(s.roleplay.partner, endsWith(', a part of you'), reason: s.id);
      }
    }
  });

  test('every scenario has enough suggestions and a full role-play', () {
    for (final s in library.scenarios) {
      expect(s.reframes.length, greaterThanOrEqualTo(4), reason: s.id);
      expect(s.phrases.length, greaterThanOrEqualTo(4), reason: s.id);
      expect(s.roleplay.partnerName, isNotEmpty, reason: s.id);
      expect(s.difficulty, inInclusiveRange(1, 3), reason: s.id);
    }
  });

  test('no suggestion is repeated within a scenario', () {
    for (final s in library.scenarios) {
      expect(s.reframes.toSet().length, s.reframes.length, reason: s.id);
      expect(s.phrases.toSet().length, s.phrases.length, reason: s.id);
    }
  });

  test('every subject resolves both rubrics, scored on the scale', () {
    expect(library.scale, isNotEmpty);
    for (final subject in library.subjects) {
      for (final kind in RubricKind.values) {
        expect(library.rubricFor(subject.id, kind).criteria, isNotEmpty);
      }
    }
  });
}
