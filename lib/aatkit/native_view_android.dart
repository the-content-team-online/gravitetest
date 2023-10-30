import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeViewAndroid extends StatelessWidget {
  static const String viewType = "<aatkit-banner-view>";

  static const cachedParam = "cached";

  final int id;

  final String param;

  NativeViewAndroid({this.param = "", this.id = -1});

  @override
  Widget build(BuildContext context) {
    return AndroidView(
      viewType: viewType,
      creationParams: [param, id.toString()],
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
