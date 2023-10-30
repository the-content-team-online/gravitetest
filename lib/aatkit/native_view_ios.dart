import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class NativeViewIos extends StatelessWidget {
  static const String viewType = "<aatkit-banner-view>";

  static const cachedParam = "cached";

  final int id;

  final String param;

  const NativeViewIos({this.param = "", this.id = -1});

  @override
  Widget build(BuildContext context) {
    return UiKitView(
      viewType: viewType,
      creationParams: "{\"type\":\"$param\",\"id\":\"$id\"}",
      creationParamsCodec: const StringCodec(),
    );
  }
}
