import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// One JSON document on disk, written safely.
///
/// Writes go to a temporary file that is then renamed into place, so a crash
/// mid-write never leaves half a file. Every read-modify-write goes through
/// [update], which runs one at a time, so two saves never race.
///
/// A file that is not JSON, or JSON that [understands] rejects (a newer
/// schema, a different shape), is moved aside to `<name>.unreadable` (or
/// `<name>.unreadable.<time>` if that is taken; none is ever deleted) and
/// treated as missing, so the user can keep practising and the data is still
/// there to recover.
class AtomicJsonFile {
  AtomicJsonFile(this.file, {bool Function(Object? document)? understands})
    : _understands = understands ?? ((_) => true);

  final File file;
  final bool Function(Object? document) _understands;
  Future<void> _chain = Future.value();

  /// The decoded document, or null if there is none.
  Future<Object?> read() async {
    await _chain;
    return _read();
  }

  /// Reads the document, passes it to [change], and writes what that
  /// returns. Calls run one after another.
  Future<void> update(Object? Function(Object? current) change) {
    final next = _chain.then((_) async {
      final updated = change(await _read());
      await _write(updated);
    });
    // Keep the chain alive after a failure; the caller still sees it.
    _chain = next.catchError((Object _) {});
    return next;
  }

  Future<Object?> _read() async {
    if (!await file.exists()) return null;
    final Object? document;
    try {
      document = jsonDecode(await file.readAsString());
    } on FormatException {
      await _setAside();
      return null;
    }
    if (_understands(document)) return document;
    await _setAside();
    return null;
  }

  Future<void> _setAside() async {
    var aside = File('${file.path}.unreadable');
    if (await aside.exists()) {
      final stamp = DateTime.now().toUtc().microsecondsSinceEpoch;
      aside = File('${file.path}.unreadable.$stamp');
    }
    await file.rename(aside.path);
  }

  Future<void> _write(Object? document) async {
    await file.parent.create(recursive: true);
    final temp = File('${file.path}.tmp');
    await temp.writeAsString(jsonEncode(document), flush: true);
    await temp.rename(file.path);
  }
}
