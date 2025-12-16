// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../super_up_core.dart';

/// Widget for managing room wallpaper settings
class VWallpaperSettingsWidget extends StatefulWidget {
  final String roomId;
  final VoidCallback? onWallpaperChanged;

  const VWallpaperSettingsWidget({
    super.key,
    required this.roomId,
    this.onWallpaperChanged,
  });

  @override
  State<VWallpaperSettingsWidget> createState() => _VWallpaperSettingsWidgetState();
}

class _VWallpaperSettingsWidgetState extends State<VWallpaperSettingsWidget> {
  bool _isLoading = false;
  String? _currentWallpaper;

  @override
  void initState() {
    super.initState();
    _loadCurrentWallpaper();
  }

  void _loadCurrentWallpaper() {
    _currentWallpaper = VWallpaperStorage.getRoomWallpaper(widget.roomId);
  }

  Future<void> _selectWallpaper() async {
    if (!VPlatforms.isMobile) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final wallpaperPath = await VWallpaperPicker.showWallpaperPicker(context);
      if (wallpaperPath != null) {
        await VWallpaperStorage.setRoomWallpaper(widget.roomId, wallpaperPath);
        setState(() {
          _currentWallpaper = wallpaperPath;
        });
        VEventBusSingleton.vEventBus.fire(
          VUpdateRoomWallpaperEvent(roomId: widget.roomId, wallpaperPath: wallpaperPath),
        );
        widget.onWallpaperChanged?.call();
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Failed to set wallpaper');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _removeWallpaper() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await VWallpaperStorage.removeRoomWallpaper(widget.roomId);
      setState(() {
        _currentWallpaper = null;
      });
      VEventBusSingleton.vEventBus.fire(
        VUpdateRoomWallpaperEvent(roomId: widget.roomId, wallpaperPath: null),
      );
      widget.onWallpaperChanged?.call();
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Failed to remove wallpaper');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildWallpaperPreview() {
    if (_currentWallpaper == null) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[300],
        ),
        child: const Icon(
          Icons.wallpaper,
          color: Colors.grey,
        ),
      );
    }

    ImageProvider imageProvider;
    if (_currentWallpaper!.startsWith('assets/')) {
      imageProvider = AssetImage(_currentWallpaper!);
    } else {
      imageProvider = FileImage(File(_currentWallpaper!));
    }

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!VPlatforms.isMobile) {
      return const SizedBox.shrink();
    }

    return CupertinoListTile(
      leading: _buildWallpaperPreview(),
      title: const Text('Wallpaper'),
      subtitle: Text(
        _currentWallpaper != null ? 'Custom wallpaper set' : 'Default wallpaper',
      ),
      trailing: _isLoading
          ? const CupertinoActivityIndicator()
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_currentWallpaper != null)
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(
                      CupertinoIcons.delete,
                      color: CupertinoColors.destructiveRed,
                    ),
                    onPressed: _removeWallpaper,
                  ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.photo),
                  onPressed: _selectWallpaper,
                ),
              ],
            ),
      onTap: _selectWallpaper,
    );
  }
}