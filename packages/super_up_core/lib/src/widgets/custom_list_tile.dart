// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:textless/textless.dart';

class CustomListTile extends StatelessWidget {
  final Widget leading;
  final Widget? trailing;
  final String title;
  final String? subtitle;
  final GestureTapCallback? onTap;
  final EdgeInsets? padding;

  const CustomListTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
    this.padding,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    leading,
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          title.text.maxLine(1).overflowEllipsis.size(15.5),
                          SizedBox(height: subtitle != null ? 2 : 0),
                          subtitle?.text.size(12).color(Colors.green) ??
                              const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ),
                trailing ?? const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChatListTile extends StatelessWidget {
  final Widget leading;
  final Widget? trailing;
  final String title;
  final Widget? subtitle;
  final GestureTapCallback? onTap;
  final EdgeInsets? padding;

  const ChatListTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
    this.padding,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: leading,
      dense: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      minLeadingWidth: 0,
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle,
      subtitleTextStyle: TextStyle(height: .8),
    );
  }
}
