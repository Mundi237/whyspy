// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';

class VSearchAppBare extends StatefulWidget {
  final VoidCallback onClose;
  final int delay;
  final Function(String value) onSearch;
  final bool requestFocus;
  final String searchLabel;

  const VSearchAppBare({
    super.key,
    required this.onClose,
    required this.searchLabel,
    this.delay = 500,
    required this.onSearch,
    this.requestFocus = true,
  });

  @override
  State<VSearchAppBare> createState() => _VSearchAppBareState();
}

class _VSearchAppBareState extends State<VSearchAppBare> {
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: CupertinoSearchTextField(
        autofocus: widget.requestFocus,
        placeholder: widget.searchLabel,
        onChanged: onSearchChanged,
        onSubmitted: (t) {
          widget.onSearch(t);
        },
      ),
      automaticallyImplyLeading: false,
      actions: [
        TextButton(
          onPressed: widget.onClose,
          child: Text(S.current.close),
        )
      ],
    );
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: widget.delay), () {
      widget.onSearch(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
