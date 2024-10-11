import 'dart:async';
import 'dart:ui';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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
      backgroundColor: Colors.amber,
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
  late final Future<WebView> webView;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    webView = runOnPlatformThread(() =>
        WebView(JObject.fromReference(Jni.getCachedApplicationContext())));
    counter = widget.index;
  }

  static Future<void> updateView(WebView webView, int counter) async {
    await runOnPlatformThread(() {
      webView.loadData(
          '<h1>$counter</h1>'.toJString(), ''.toJString(), ''.toJString());
    });
  }

  static Future<void> disposeWebView(WebView webView) {
    return runOnPlatformThread(() {
      webView.release();
    });
  }

  @override
  void dispose() {
    (() async => disposeWebView(await webView))();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 300,
        width: 300,
        child: FutureBuilder(
            future: webView,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('...');
              final view = snapshot.data!;
              updateView(view, counter);
              return Stack(
                children: [
                  Center(
                    child: AndroidView(
                      viewType: viewTypeId,
                      // ignore: invalid_use_of_internal_member
                      creationParams: view.reference.pointer.address,
                      creationParamsCodec: const StandardMessageCodec(),
                    ),
                  ),
                  Center(
                    child: FloatingActionButton(
                      onPressed: () async {
                        ++counter;
                        await updateView(view, counter);
                      },
                      child: const Icon(Icons.plus_one),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
