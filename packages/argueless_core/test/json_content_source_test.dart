import 'dart:convert';

import 'package:argueless_core/argueless_core.dart';
import 'package:test/test.dart';

Map<String, dynamic> _library({int version = 1, Object? subjectRubrics}) => {
  'schemaVersion': version,
  'scale': [
    {'value': 1, 'label': 'Not yet'},
  ],
  'rubrics': {
    for (final kind in ['reframe', 'phrases'])
      kind: {
        'title': 'Rate $kind',
        'criteria': [
          {'id': 'c', 'label': 'C', 'prompt': 'c?'},
        ],
      },
  },
  'subjects': [
    {
      'id': 'letting-go',
      'title': 'Letting go',
      'tagline': 't',
      'brief': 'b',
      'color': '0xFF2E7DD7',
      'icon': 'balance',
      'scenarioFile': 'lg.json',
      'rubrics': ?subjectRubrics,
    },
  ],
};

Map<String, dynamic> _scenarios({String subjectId = 'letting-go'}) => {
  'schemaVersion': 1,
  'subjectId': subjectId,
  'scenarios': [
    {
      'id': 'lg-01',
      'title': 'T',
      'setting': 'Home',
      'difficulty': 1,
      'situation': 'S',
      'firstThought': 'F',
      'reframes': ['r'],
      'phrases': ['p'],
      'roleplay': {
        'partner': 'Ray, your uncle',
        'opening': 'o',
        'partnerReply': 'r',
      },
      'takeaway': 'k',
    },
  ],
};

JsonContentSource _source(Map<String, Object> files) =>
    JsonContentSource((name) async => jsonEncode(files[name]));

void main() {
  test('reads subjects, scenarios and rubrics', () async {
    final library = await _source({
      'library.json': _library(),
      'lg.json': _scenarios(),
    }).load();
    expect(library.subject('letting-go')!.color, 0xFF2E7DD7);
    final scenario = library.scenario('lg-01')!;
    expect(scenario.subjectId, 'letting-go');
    expect(scenario.roleplay.partnerName, 'Ray');
    expect(
      library.rubricFor('letting-go', RubricKind.reframe).title,
      'Rate reframe',
    );
  });

  test(
    'a subject rubric replaces the library one for that kind only',
    () async {
      final library = await _source({
        'library.json': _library(
          subjectRubrics: {
            'reframe': {
              'title': 'Own',
              'criteria': [
                {'id': 'o', 'label': 'O', 'prompt': 'o?'},
              ],
            },
          },
        ),
        'lg.json': _scenarios(),
      }).load();
      expect(library.rubricFor('letting-go', RubricKind.reframe).title, 'Own');
      expect(
        library.rubricFor('letting-go', RubricKind.phrases).title,
        'Rate phrases',
      );
    },
  );

  test('refuses a schema version it does not know', () {
    expect(
      _source({
        'library.json': _library(version: 2),
        'lg.json': _scenarios(),
      }).load(),
      throwsA(isA<ContentFormatException>()),
    );
  });

  test('refuses a scenario file for another subject', () {
    expect(
      _source({
        'library.json': _library(),
        'lg.json': _scenarios(subjectId: 'confusion'),
      }).load(),
      throwsA(isA<ContentFormatException>()),
    );
  });

  test('names the missing field', () async {
    final broken = _scenarios();
    (broken['scenarios'] as List).first.remove('takeaway');
    await expectLater(
      _source({'library.json': _library(), 'lg.json': broken}).load(),
      throwsA(
        isA<ContentFormatException>().having(
          (e) => e.message,
          'message',
          contains('lg.json.scenarios[0].takeaway'),
        ),
      ),
    );
  });
}
