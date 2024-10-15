import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jni/jni.dart';

import 'generated.dart';

const viewTypeId = 'plugins.flutter.io/webview';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Webview demo',
      theme: ThemeData.dark(),
      home: const HomeWidget(),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) => CounterWebView(
          index,
          key: ValueKey(index),
        ),
      ),
    );
  }
}

class CounterWebView extends StatefulWidget {
  final int index;

  const CounterWebView(
    this.index, {
    super.key,
  });

  @override
  State<CounterWebView> createState() => _CounterWebViewState();
}

class _CounterWebViewState extends State<CounterWebView> {
  late final WebView webView;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    webView = WebView(JObject.fromReference(Jni.getCachedApplicationContext()));
    counter = widget.index;
    updateView(webView, counter);
  }

  void updateView(WebView webView, int counter) {
    webView.loadData(
        '<h1>$counter</h1>'.toJString(), ''.toJString(), ''.toJString());
  }

  @override
  void dispose() {
    webView.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 300,
        width: 300,
        child: Stack(
          children: [
            Center(
              child: AndroidView(
                viewType: viewTypeId,
                // ignore: invalid_use_of_internal_member
                creationParams: webView.reference.pointer.address,
                creationParamsCodec: const StandardMessageCodec(),
              ),
            ),
            Center(
              child: FloatingActionButton(
                onPressed: () {
                  ++counter;
                  updateView(webView, counter);
                },
                child: const Icon(Icons.plus_one),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
