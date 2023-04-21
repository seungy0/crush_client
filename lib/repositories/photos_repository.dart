import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class UploadPhotoException implements Exception {
  /// {@macro upload_photo_exception}
  const UploadPhotoException(this.message);

  /// Description of the failure
  final String message;

  @override
  String toString() => message;
}

class CompositePhotoException implements Exception {
  /// {@macro composite_photo_exception}
  const CompositePhotoException(this.message);

  /// Description of the failure
  final String message;

  @override
  String toString() => message;
}

class ShareUrls {
  /// {@macro share_urls}
  const ShareUrls({
    required this.explicitShareUrl,
    required this.facebookShareUrl,
    required this.twitterShareUrl,
  });

  /// The share url for explicit sharing.
  final String explicitShareUrl;

  /// The share url for sharing on Facebook.
  final String facebookShareUrl;

  /// The share url for sharing on Twitter.
  final String twitterShareUrl;
}

const _shareUrl = 'https://io-photobooth-dev.web.app/share';

class PhotosRepository {
  PhotosRepository({
    required FirebaseStorage firebaseStorage,
  }) : _firebaseStorage = firebaseStorage;

  final FirebaseStorage _firebaseStorage;

  /// Uploads photo to the [FirebaseStorage] if it doesn't already exist
  /// and returns [ShareUrls].
  Future<ShareUrls> sharePhoto({
    required String fileName,
    required Uint8List data,
    required String shareText,
  }) async {
    Reference reference;
    try {
      reference = _firebaseStorage.ref('uploads/$fileName');
    } catch (e, st) {
      throw UploadPhotoException(
        'Uploading photo $fileName failed. '
        "Couldn't get storage reference 'uploads/$fileName'.\n"
        'Error: $e. StackTrace: $st',
      );
    }

    if (await _photoExists(reference)) {
      return ShareUrls(
        explicitShareUrl: _getSharePhotoUrl(fileName),
        facebookShareUrl: _facebookShareUrl(fileName, shareText),
        twitterShareUrl: _twitterShareUrl(fileName, shareText),
      );
    }

    try {
      await reference.putData(data);
    } catch (error, stackTrace) {
      throw UploadPhotoException(
        'Uploading photo $fileName failed. '
        "Couldn't upload data to ${reference.fullPath}.\n"
        'Error: $error. StackTrace: $stackTrace',
      );
    }

    return ShareUrls(
      explicitShareUrl: _getSharePhotoUrl(fileName),
      facebookShareUrl: _facebookShareUrl(fileName, shareText),
      twitterShareUrl: _twitterShareUrl(fileName, shareText),
    );
  }

  Future<bool> _photoExists(Reference reference) async {
    try {
      await reference.getDownloadURL();
      return true;
    } catch (_) {
      return false;
    }
  }

  String _twitterShareUrl(String photoName, String shareText) {
    final encodedShareText = Uri.encodeComponent(shareText);
    return 'https://twitter.com/intent/tweet?url=${_getSharePhotoUrl(photoName)}&text=$encodedShareText';
  }

  String _facebookShareUrl(String photoName, String shareText) {
    final encodedShareText = Uri.encodeComponent(shareText);
    return 'https://www.facebook.com/sharer.php?u=${_getSharePhotoUrl(photoName)}&quote=$encodedShareText';
  }

  String _getSharePhotoUrl(String photoName) => '$_shareUrl/$photoName';
}
