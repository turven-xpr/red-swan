import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'german_learning.db'));

    if (Platform.isAndroid) {
      // Workaround for sqlite-on-Android so the bundled native lib works
      // on older API levels (24+).
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Allow `LIKE` and other regex ops to work correctly with foreign
    // characters in German vocabulary (ä, ö, ü, ß, é, …).
    final cacheBase = (await getTemporaryDirectory()).path;
    sqlite3.sqlite3.tempDirectory = cacheBase;

    return NativeDatabase.createInBackground(file);
  });
}

