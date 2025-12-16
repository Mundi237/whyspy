// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';

class PointerDownUnFocus extends StatelessWidget {
  final Widget child;

  const PointerDownUnFocus({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!VPlatforms.isMobile) return child;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      // onTapDown: (details) {
      //   final currentFocus = FocusScope.of(context);
      //   if (!currentFocus.hasPrimaryFocus &&
      //       currentFocus.focusedChild != null) {
      //     FocusManager.instance.primaryFocus?.unfocus();
      //   }
      // },

      child: child,
    );
    // return Listener(
    //   onPointerDown: (_) {
    //     // Unfocus text fields when user taps outside
    //     final currentFocus = FocusScope.of(context);
    //     if (!currentFocus.hasPrimaryFocus &&
    //         currentFocus.focusedChild != null) {
    //       FocusManager.instance.primaryFocus?.unfocus();
    //     }
    //   },
    //   child: child,
    // );
  }
}
