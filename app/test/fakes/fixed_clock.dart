import 'package:argueless/src/app/clock.dart';

/// A clock the test moves by hand.
class FixedClock extends Clock {
  FixedClock(this.time);

  DateTime time;

  @override
  DateTime now() => time;
}
