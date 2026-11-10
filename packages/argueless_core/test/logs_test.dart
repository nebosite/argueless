import 'dart:convert';
import 'dart:io';

import 'package:argueless_core/argueless_core.dart';
import 'package:test/test.dart';

import 'fixtures.dart';

void main() {
  late Directory folder;

  setUp(() async => folder = await Directory.systemTemp.createTemp('logs'));
  tearDown(() => folder.delete(recursive: true));

  File file(String name) => File('${folder.path}/$name');

  group('JsonFilePracticeLog', () {
    test('keeps records across instances, oldest first', () async {
      final log = JsonFilePracticeLog(file('practice.json'));
      await log.add(testRecord('b', 'one', DateTime.utc(2026, 11, 9)));
      await log.add(testRecord('a', 'one', DateTime.utc(2026, 11, 8)));
      final again = await JsonFilePracticeLog(file('practice.json')).all();
      expect(again.map((r) => r.scenarioId), ['a', 'b']);
      expect(again.first.reframes.ideas, ['idea', 'idea']);
    });

    test('concurrent adds are all kept', () async {
      final log = JsonFilePracticeLog(file('practice.json'));
      await Future.wait([
        for (var i = 0; i < 20; i++)
          log.add(testRecord('s$i', 'one', DateTime.utc(2026, 1, 1, 0, i))),
      ]);
      expect(await log.all(), hasLength(20));
    });

    test('keeps entries it cannot read when adding', () async {
      await file('practice.json').writeAsString(
        jsonEncode({
          'schemaVersion': 1,
          'records': [
            {'from': 'a newer app'},
          ],
        }),
      );
      final log = JsonFilePracticeLog(file('practice.json'));
      await log.add(testRecord('a', 'one', DateTime.utc(2026, 11, 8)));
      expect(await log.all(), hasLength(1));
      final raw = jsonDecode(await file('practice.json').readAsString());
      expect(raw['records'], hasLength(2));
    });

    test('sets a damaged file aside instead of losing it', () async {
      await file('practice.json').writeAsString('{not json');
      final log = JsonFilePracticeLog(file('practice.json'));
      expect(await log.all(), isEmpty);
      await log.add(testRecord('a', 'one', DateTime.utc(2026, 11, 8)));
      expect(
        await file('practice.json.unreadable').readAsString(),
        '{not json',
      );
      expect(await log.all(), hasLength(1));
    });
  });

  group('files it does not understand are set aside, never overwritten', () {
    Future<List<String>> asides() async => [
      for (final f in folder.listSync())
        if (f.path.contains('.unreadable')) await File(f.path).readAsString(),
    ];

    test('a second damaged file does not replace the first copy', () async {
      final log = JsonFilePracticeLog(file('practice.json'));
      await file('practice.json').writeAsString('{first');
      await log.add(testRecord('a', 'one', DateTime.utc(2026, 11, 8)));
      await file('practice.json').writeAsString('{second');
      await log.add(testRecord('b', 'one', DateTime.utc(2026, 11, 9)));
      expect(await asides(), unorderedEquals(['{first', '{second']));
    });

    test('valid JSON of another shape is kept', () async {
      await file('reflections.json').writeAsString('[1, 2, 3]');
      final log = JsonFileReflectionLog(file('reflections.json'));
      await log.save(const Reflection(day: LocalDay(2026, 11, 10)));
      expect(await asides(), ['[1, 2, 3]']);
      expect(await log.all(), hasLength(1));
    });

    test('a newer schema version is kept', () async {
      final newer = jsonEncode({'schemaVersion': 2, 'records': []});
      await file('practice.json').writeAsString(newer);
      final log = JsonFilePracticeLog(file('practice.json'));
      await log.add(testRecord('a', 'one', DateTime.utc(2026, 11, 8)));
      expect(await asides(), [newer]);
    });
  });

  group('JsonFileReflectionLog', () {
    const day = LocalDay(2026, 11, 10);

    test('one reflection per day; saving again replaces it', () async {
      final log = JsonFileReflectionLog(file('reflections.json'));
      await log.save(const Reflection(day: day, automatic: 1));
      await log.save(const Reflection(day: LocalDay(2026, 11, 9), conflict: 2));
      await log.save(const Reflection(day: day, automatic: 3, recovered: 1));
      final all = await JsonFileReflectionLog(file('reflections.json')).all();
      expect(all.map((r) => r.day), [const LocalDay(2026, 11, 9), day]);
      final today = await log.on(day);
      expect(today!.automatic, 3);
      expect(today.recovered, 1);
      expect(await log.on(const LocalDay(2026, 1, 1)), isNull);
    });
  });
}
