import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cash/aatkit/aatkit_banner_type.dart';
import 'package:cash/aatkit/native_view_android.dart';
import 'package:cash/aatkit/native_view_ios.dart';

class AATKitBanner extends StatefulWidget {
  static const String methodChannelName = "net.gravite.aatkit/cached-banner";

  static const String sizeMethodName = "onSizeChanged";

  final AATKitBannerType type;

  static int get nextId {
    _lastId++;
    return _lastId;
  }

  static int _lastId = 0;

  AATKitBanner({
    super.key,
    this.type = AATKitBannerType.sticky,
  });

  @override
  State<AATKitBanner> createState() => _AATKitBannerState();
}

class _AATKitBannerState extends State<AATKitBanner> {
  //Change the sticky banner size to match the placement size if needed.
  static const Size stickyBannerSize = Size(320, 53);

  //Change the initial cached banner size if needed. The width and height
  //should be at least 1.0
  static const Size initialCachedBannerSize = Size(1, 1);

  MethodChannel? methodChannel;

  Size? size;

  @override
  Widget build(BuildContext context) {
    //NativeViewAndroid must be wrapped by SizedBox of the same size as the
    //banner placement.
    return SizedBox(
      width: size?.width ??
          (widget.type == AATKitBannerType.sticky
              ? stickyBannerSize.width
              : initialCachedBannerSize.width),
      height: size?.height ??
          (widget.type == AATKitBannerType.sticky
              ? stickyBannerSize.height
              : initialCachedBannerSize.height),
      child: _buildBanner(),
    );
  }

  Widget _buildBanner() {
    switch (widget.type) {
      case AATKitBannerType.cached:
        return _buildCachedBanner();
      default:
        return _buildStickyBanner();
    }
  }

  StatelessWidget _buildStickyBanner() {
    if (Platform.isAndroid) {
      return NativeViewAndroid();
    } else if (Platform.isIOS) {
      return NativeViewIos();
    } else {
      throw UnsupportedError('Unsupported platform view');
    }
  }

  StatelessWidget _buildCachedBanner() {
    final id = AATKitBanner.nextId;
    methodChannel = MethodChannel("${AATKitBanner.methodChannelName}-$id");
    methodChannel?.setMethodCallHandler(_onChannelCallback);
    if (Platform.isAndroid) {
      return NativeViewAndroid(
        param: NativeViewAndroid.cachedParam,
        id: id,
      );
    } else if (Platform.isIOS) {
      return NativeViewIos(
        param: NativeViewIos.cachedParam,
        id: id,
      );
    } else {
      throw UnsupportedError('Unsupported platform view');
    }
  }

  Future<dynamic> _onChannelCallback(MethodCall methodCall) async {
    if (methodCall.method == AATKitBanner.sizeMethodName) {
      final arguments = methodCall.arguments;
      setState(() {
        size = Size(arguments[0] as double, arguments[1] as double);
      });
    }
  }
}
