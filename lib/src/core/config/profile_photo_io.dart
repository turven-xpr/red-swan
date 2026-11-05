import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kPath = 'profile_photo_path_v1';

/// Load the previously-persisted profile photo from disk.
Future<Uint8List?> loadPersistedPhoto() async {
  final prefs = await SharedPreferences.getInstance();
  final path = prefs.getString(_kPath);
  if (path != null) {
    final file = File(path);
    if (file.existsSync()) return file.readAsBytes();
  }
  return null;
}

/// Write the photo bytes to the app-documents directory and persist
/// the file path in SharedPreferences.
Future<void> persistPhoto(Uint8List bytes) async {
  final dir = await getApplicationDocumentsDirectory();
  final target = File('${dir.path}/profile_photo.jpg');
  await target.writeAsBytes(bytes, flush: true);
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_kPath, target.path);
}

/// Remove the persisted photo reference.
Future<void> clearPersistedPhoto() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kPath);
  } catch (_) {/* tolerate */}
}

