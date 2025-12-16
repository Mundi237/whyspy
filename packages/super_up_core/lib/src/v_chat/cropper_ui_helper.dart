// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:s_translation/generated/l10n.dart';

/// Helper class to provide Material 3 compliant UI settings for image cropper
class CropperUIHelper {
  /// Returns Material 3 compliant Android UI settings
  static AndroidUiSettings getAndroidUiSettings(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AndroidUiSettings(
      toolbarTitle: S.of(context).cropImage,
      toolbarColor: colorScheme.surface,
      toolbarWidgetColor: colorScheme.onSurface,
      statusBarColor: colorScheme.surface,
      backgroundColor: colorScheme.surface,
      activeControlsWidgetColor: colorScheme.primary,
      dimmedLayerColor: Colors.black.withValues(alpha: 0.6),
      cropFrameColor: colorScheme.primary,
      cropGridColor: colorScheme.primary.withValues(alpha: 0.5),
      cropFrameStrokeWidth: 2,
      cropGridStrokeWidth: 1,
      showCropGrid: true,
      lockAspectRatio: false,
      hideBottomControls: false,
      initAspectRatio: CropAspectRatioPreset.original,
    );
  }

  /// Returns Material 3 compliant iOS UI settings
  static IOSUiSettings getIOSUiSettings(BuildContext context) {
    return IOSUiSettings(
      title: S.of(context).cropImage,
      doneButtonTitle: S.of(context).done,
      cancelButtonTitle: S.of(context).cancel,
      rotateClockwiseButtonHidden: false,
      hidesNavigationBar: false,
      rectX: 0,
      rectY: 0,
      rectWidth: 0,
      rectHeight: 0,
    );
  }

  /// Returns Web UI settings for web platform
  static WebUiSettings getWebUiSettings(BuildContext context) {
    return WebUiSettings(
      context: context,
    );
  }

  /// Returns a complete list of UI settings for all platforms
  static List<PlatformUiSettings> getAllPlatformSettings(BuildContext context) {
    return [
      getAndroidUiSettings(context),
      getIOSUiSettings(context),
      getWebUiSettings(context),
    ];
  }
}
