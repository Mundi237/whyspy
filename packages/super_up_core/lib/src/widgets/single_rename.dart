// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/src/widgets/s_text_filed.dart';
import 'package:textless/textless.dart';

class VSingleRename extends StatefulWidget {
  final String appbarTitle;
  final String subTitle;
  final String? oldValue;

  const VSingleRename(
      {super.key,
      required this.appbarTitle,
      required this.subTitle,
      this.oldValue});

  @override
  State<VSingleRename> createState() => _VSingleRenameState();
}

class _VSingleRenameState extends State<VSingleRename> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.oldValue != null) {
      controller.text = widget.oldValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: widget.appbarTitle.text, actions: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).pop(controller.text);
          },
          child: S.of(context).ok.text,
        )
      ]),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(widget.subTitle),
                  const SizedBox(
                    height: 10,
                  ),
                  STextFiled(
                    autocorrect: true,
                    inputType: TextInputType.text,
                    autofocus: true,
                    controller: controller,
                    textHint: widget.oldValue ?? "",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
