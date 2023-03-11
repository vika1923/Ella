import 'package:flutter/material.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';

void main() {
  runApp(const Web());
}

class Web extends StatelessWidget {
  const Web({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            //padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
            color: Colors.white,
            child: const WebView(
              initialUrl: 'https://web.telegram.org/',
              javascriptMode: JavascriptMode.unrestricted,
            )));
  }
}
