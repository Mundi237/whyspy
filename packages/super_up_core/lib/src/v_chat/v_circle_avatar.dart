// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';
import 'package:badges/badges.dart' as badges;

class VCircleAvatar extends StatelessWidget {
  final int radius;
  final VPlatformFile vFileSource;

  const VCircleAvatar({
    super.key,
    this.radius = 28,
    required this.vFileSource,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: double.tryParse(radius.toString()),
      backgroundImage: CachedNetworkImageProvider(
        vFileSource.fullNetworkUrl!,
        cacheKey: vFileSource.getCachedUrlKey,
      ),
    );
  }

  ImageProvider getImageProvider() {
    if (vFileSource.fullNetworkUrl != null) {
      return CachedNetworkImageProvider(vFileSource.fullNetworkUrl!);
    }

    if (vFileSource.assetsPath != null) {
      return AssetImage(vFileSource.assetsPath!);
    }
    if (vFileSource.isFromBytes) {
      return MemoryImage(vFileSource.uint8List);
    }

    if (vFileSource.isFromPath) {
      return FileImage(File(vFileSource.fileLocalPath!));
    } else {
      return CachedNetworkImageProvider(vFileSource.fullNetworkUrl!);
    }
  }
}

class VCircleVerifiedAvatar extends StatelessWidget {
  final int radius;
  final VPlatformFile vFileSource;

  const VCircleVerifiedAvatar({
    super.key,
    this.radius = 28,
    required this.vFileSource,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VCircleAvatar(
          vFileSource: vFileSource,
          radius: radius,
        ),
        PositionedDirectional(
          end: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            child: const badges.Badge(
              badgeAnimation: badges.BadgeAnimation.fade(toAnimate: false),
              badgeContent: Icon(
                Icons.check,
                color: Colors.white,
                size: 7,
              ),
              badgeStyle: badges.BadgeStyle(
                shape: badges.BadgeShape.twitter,
                badgeColor: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
