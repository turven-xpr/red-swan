import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// Conditional import: only used on native platforms for file persistence.
import 'profile_photo_io.dart'
    if (dart.library.js_interop) 'profile_photo_web.dart' as platform;

/// Persists the user's profile photo as raw bytes (`Uint8List`).
///
/// On mobile, the bytes are also written to the app-documents directory
/// so they survive restarts.  On web, only the in-memory `Uint8List`
/// is kept (no persistence across full page reloads).
///
/// Uses `XFile.readAsBytes()` from `image_picker` which works
/// identically on both mobile and web — no platform branching needed
/// in the widget tree.
class ProfilePhotoNotifier extends Notifier<Uint8List?> {
  @override
  Uint8List? build() {
    _load();
    return null;
  }

  Future<void> _load() async {
    if (kIsWeb) return; // No persisted photo on web preview
    try {
      final bytes = await platform.loadPersistedPhoto();
      if (bytes != null) state = bytes;
    } catch (_) {/* tolerate (tests lack path_provider) */}
  }

  Future<Uint8List?> pickFromGallery() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );
    if (picked == null) return null;
    final bytes = await picked.readAsBytes();
    state = bytes;
    if (!kIsWeb) await platform.persistPhoto(bytes);
    return bytes;
  }

  Future<Uint8List?> pickFromCamera() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );
    if (picked == null) return null;
    final bytes = await picked.readAsBytes();
    state = bytes;
    if (!kIsWeb) await platform.persistPhoto(bytes);
    return bytes;
  }

  Future<void> clear() async {
    state = null;
    if (!kIsWeb) await platform.clearPersistedPhoto();
  }
}

final profilePhotoProvider =
    NotifierProvider<ProfilePhotoNotifier, Uint8List?>(
        ProfilePhotoNotifier.new);
