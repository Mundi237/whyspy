// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';

class ChatSettingsTileInfo extends StatelessWidget {
  const ChatSettingsTileInfo({
    super.key,
    required this.title,
    this.trailing,
    this.margin = const EdgeInsets.all(10),
    this.padding,
    this.onPressed,
  });

  final Widget title;
  final EdgeInsets? padding;
  final EdgeInsets margin;
  final Widget? trailing;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      hasLeading: false,
      dividerMargin: 0,
      topMargin: 0,
      additionalDividerMargin: 0,
      margin: margin,
      children: [
        CupertinoListTile(
          onTap: onPressed,
          padding: padding,
          leadingSize: 0,
          title: title,
          trailing: trailing,
        )
      ],
    );
  }
}
