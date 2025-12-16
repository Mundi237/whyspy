// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';

class STextFiled extends StatefulWidget {
  final String textHint;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final bool obscureText;
  final bool autofocus;
  final int? maxLength;
  final int maxLines;
  final int? minLines;
  final bool autocorrect;
  final Widget? prefix;
  final GestureTapCallback? onTap;

  /// {@macro flutter.widgets.editableText.onChanged}
  final ValueChanged<String>? onChanged;

  const STextFiled({
    super.key,
    required this.textHint,
    this.controller,
    this.inputType,
    this.prefix,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.onTap,
    this.autofocus = false,
    this.autocorrect = true,
    this.obscureText = false,
  });

  @override
  State<STextFiled> createState() => _STextFiledState();
}

class _STextFiledState extends State<STextFiled> {
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _obscurePassword = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: widget.maxLength,
      minLines: widget.minLines,
      autocorrect: widget.autocorrect,
      autofocus: widget.autofocus,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      controller: widget.controller,
      keyboardType: widget.inputType,
      onTap: widget.onTap,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: widget.textHint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Colors.blue,
          ),
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : const SizedBox.shrink(),
      ),
    );

  }
}
