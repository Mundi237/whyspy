// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_up_core/src/utils/utils.dart';
import 'package:super_up_core/src/v_chat/extension.dart';
import 'package:textless/textless.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class SElevatedButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPress;

  const SElevatedButton({
    super.key,
    required this.title,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    if (onPress == null) {
      return TouchableOpacity(
        activeOpacity: 0.2,
        onTap: onPress,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: CupertinoColors.inactiveGray,
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: title.text.black.size(17).color(Colors.white),
        ),
      );
    }
    return TouchableOpacity(
      activeOpacity: 0.2,
      onTap: onPress,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: context.isDark ? Colors.white24 : AppTheme.primaryGreen,
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: title.text.black.size(17).color(Colors.white),
      ),
    );
  }
}
