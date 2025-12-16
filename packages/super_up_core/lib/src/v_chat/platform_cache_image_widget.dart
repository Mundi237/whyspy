// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';

class VPlatformCacheImageWidget extends StatefulWidget {
  final VPlatformFile source;
  final Size? size;
  final BoxFit? fit;
  final BorderRadius? borderRadius;

  const VPlatformCacheImageWidget({
    super.key,
    required this.source,
    this.size,
    this.fit,
    this.borderRadius,
  });

  @override
  State<VPlatformCacheImageWidget> createState() =>
      _VPlatformCacheImageWidgetState();
}

class _VPlatformCacheImageWidgetState extends State<VPlatformCacheImageWidget> {
  var imageKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    if (widget.borderRadius != null) {
      return ClipRRect(
        borderRadius: widget.borderRadius!,
        child: _getImage(),
      );
    }
    return _getImage();
  }

  Widget _getImage() {
    if (widget.source.isFromAssets) {
      return Image.asset(
        widget.source.assetsPath!,
        width: widget.size?.width,
        fit: widget.fit,
        height: widget.size?.height,
      );
    }
    if (widget.source.isFromBytes) {
      return Image.memory(
        Uint8List.fromList(widget.source.bytes!),
        width: widget.size?.width,
        fit: widget.fit,
        height: widget.size?.height,
      );
    }
    if (widget.source.fileLocalPath != null) {
      return Image.file(
        File(widget.source.fileLocalPath!),
        width: widget.size?.width,
        height: widget.size?.height,
        fit: widget.fit,
      );
    }
    return CachedNetworkImage(
      key: imageKey,
      height: widget.size?.height,
      width: widget.size?.width,
      fit: widget.fit,
      cacheKey: widget.source.getCachedUrlKey,
      imageUrl: widget.source.fullNetworkUrl!,
      placeholder: (context, url) =>
          const CupertinoActivityIndicator.partiallyRevealed(),
      errorWidget: (context, url, error) => GestureDetector(
        onTap: () {
          setState(() {
            imageKey = UniqueKey();
          });
        },
        child: const Icon(
          Icons.refresh,
        ),
      ),
    );
  }
}



class VPlatformImageProvider {
  final VPlatformFile source;

  const VPlatformImageProvider({
    required this.source,
  });

  ImageProvider getImageProvider() {
    if (source.isFromAssets) {
      return AssetImage(source.assetsPath!);
    }

    if (source.isFromBytes) {
      return MemoryImage(Uint8List.fromList(source.bytes!));
    }

    if (source.fileLocalPath != null) {
      return FileImage(File(source.fileLocalPath!));
    }

    return CachedNetworkImageProvider(
      source.fullNetworkUrl!,
      cacheKey: source.getCachedUrlKey,
    );
  }

  /// Helper method to create a widget with the image provider
  Widget buildImage({
    Size? size,
    BoxFit? fit,
    BorderRadius? borderRadius,
    Widget Function(BuildContext, ImageProvider)? imageBuilder,
    Widget Function(BuildContext, String)? placeholder,
    Widget Function(BuildContext, String, dynamic)? errorWidget,
  }) {
    Widget image;

    if (source.fullNetworkUrl != null) {
      image = CachedNetworkImage(
        imageUrl: source.fullNetworkUrl!,
        cacheKey: source.getCachedUrlKey,
        width: size?.width,
        height: size?.height,
        fit: fit,
        imageBuilder: imageBuilder,
        placeholder: placeholder ??
                (context, url) => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
        errorWidget: errorWidget ??
                (context, url, error) => Center(
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  // Trigger reload if needed
                },
              ),
            ),
      );
    } else {
      image = Image(
        image: getImageProvider(),
        width: size?.width,
        height: size?.height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
        errorWidget?.call(context, '', error) ??
            Center(
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  // Trigger reload if needed
                },
              ),
            ),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: image,
      );
    }

    return image;
  }

  /// Extension method to easily convert to ImageProvider
  ImageProvider toImageProvider() => getImageProvider();
}

/// Extension on VPlatformFile to easily create an image provider
extension VPlatformFileImageExtension on VPlatformFile {
  ImageProvider toImageProvider() {
    return VPlatformImageProvider(source: this).getImageProvider();
  }

  Widget toImage({
    Size? size,
    BoxFit? fit,
    BorderRadius? borderRadius,
    Widget Function(BuildContext, ImageProvider)? imageBuilder,
    Widget Function(BuildContext, String)? placeholder,
    Widget Function(BuildContext, String, dynamic)? errorWidget,
  }) {
    return VPlatformImageProvider(source: this).buildImage(
      size: size,
      fit: fit,
      borderRadius: borderRadius,
      imageBuilder: imageBuilder,
      placeholder: placeholder,
      errorWidget: errorWidget,
    );
  }
}