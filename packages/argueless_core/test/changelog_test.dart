import 'dart:io';

import 'package:argueless_core/argueless_core.dart';
import 'package:test/test.dart';

String _log(List<String> versions) {
  final entries = [
    for (final v in versions)
      '{"version": "$v", "date": "2026-11-10", "changes": ["x"]}',
  ];
  return '{"schemaVersion": 1, "versions": [${entries.join(',')}]}';
}

void main() {
  test('the current version is the newest entry', () {
    final log = Changelog.parse(_log(['0.2.1', '0.2.0', '0.1.0']));
    expect(log.current, const AppVersion(0, 2, 1));
    expect(log.notes.last.changes, ['x']);
  });

  test('refuses versions out of order or repeated', () {
    expect(
      () => Changelog.parse(_log(['0.1.0', '0.2.0'])),
      throwsA(isA<ContentFormatException>()),
    );
    expect(
      () => Changelog.parse(_log(['0.1.0', '0.1.0'])),
      throwsA(isA<ContentFormatException>()),
    );
  });

  test('versions parse and compare by number, ignoring a build suffix', () {
    expect(AppVersion.parse('0.10.0+7'), const AppVersion(0, 10, 0));
    expect(
      AppVersion.parse('0.10.0').compareTo(AppVersion.parse('0.9.3')),
      greaterThan(0),
    );
    expect(() => AppVersion.parse('1.2'), throwsFormatException);
  });

  test('the shipped changelog matches the version in pubspec.yaml', () {
    final log = Changelog.parse(
      File('../../app/assets/changelog.json').readAsStringSync(),
    );
    final pubspec = File('../../app/pubspec.yaml').readAsStringSync();
    final line = RegExp(
      r'^version:\s*(\S+)',
      multiLine: true,
    ).firstMatch(pubspec)!.group(1)!;
    expect(
      log.current,
      AppVersion.parse(line),
      reason: 'Bump app/pubspec.yaml and app/assets/changelog.json together',
    );
  });
}
