/// The current time, behind a seam so tests can fix it.
class Clock {
  const Clock();

  DateTime now() => DateTime.now();
}
