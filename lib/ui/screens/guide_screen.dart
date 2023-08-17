import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  var c = WebViewController();

  @override
  void initState() async {
    super.initState();
    await c.loadFlutterAsset('assets/statics/help.htm');
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: c);
  }
}
