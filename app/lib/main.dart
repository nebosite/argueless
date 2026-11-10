import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

import 'src/app/app_files.dart';
import 'src/app/app_services.dart';
import 'src/app/argueless_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // App-private storage: nothing here is visible to other apps.
  final files = AppFiles(await getApplicationDocumentsDirectory());
  final library = await JsonContentSource(
    (name) => rootBundle.loadString('assets/content/$name'),
  ).load();
  final changelog = Changelog.parse(
    await rootBundle.loadString('assets/changelog.json'),
  );
  final practiceLog = files.practiceLog();
  runApp(
    ArguelessApp(
      services: AppServices(
        library: library,
        scenarios: LibraryScenarioProvider(library, practiceLog),
        practiceLog: practiceLog,
        reflectionLog: files.reflectionLog(),
        changelog: changelog,
      ),
    ),
  );
}
