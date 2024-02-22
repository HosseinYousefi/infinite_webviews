import 'dart:async';
import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:jni/internal_helpers_for_jnigen.dart';
import 'package:jni/jni.dart';
import 'package:webview_demo/generated.dart';
import 'package:webview_demo/generated.dart' as gen;

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
  late final int viewId;
  int address = -1;
  int counter = 0;

  static Future<void> updateView(int counter, int address) async {
    await PlatformIsolate.run(() {
      final webView = WebView.fromRef(Pointer<Void>.fromAddress(address));
      webView.loadData(
          '<h1>$counter</h1>'.toJString(), ''.toJString(), ''.toJString());
      webView.setAsReleased();
    });
  }

  @override
  void initState() {
    super.initState();
    counter = widget.index;
  }

  @override
  void dispose() {
    if (address != -1) {
      PlatformIsolate.run(() {
        JObject.fromRef(Pointer<Void>.fromAddress(address)).release();
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SizedBox(
              height: 300,
              width: 300,
              child: PlatformViewLink(
                viewType: viewTypeId,
                surfaceFactory: (context, controller) {
                  return AndroidViewSurface(
                    controller: controller as AndroidViewController,
                    gestureRecognizers: const <Factory<
                        OneSequenceGestureRecognizer>>{},
                    hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                  );
                },
                onCreatePlatformView: (params) {
                  return PlatformViewsService.initSurfaceAndroidView(
                    id: params.id,
                    viewType: viewTypeId,
                    layoutDirection: TextDirection.ltr,
                    creationParams: {},
                    creationParamsCodec: const StandardMessageCodec(),
                    onFocus: () {
                      params.onFocusChanged(true);
                    },
                  )
                    ..addOnPlatformViewCreatedListener((id) {
                      viewId = id;
                      final methodChannel = MethodChannel('WebView/$id');
                      methodChannel.setMethodCallHandler((call) async {
                        print(call);
                        if (call.method == 'address') {
                          print('address got called');
                          address = call.arguments as int;
                          updateView(counter, address);
                          return;
                        }
                      });
                    })
                    ..addOnPlatformViewCreatedListener(
                        params.onPlatformViewCreated)
                    ..create();
                },
              )),
        ),
        Center(
          child: FloatingActionButton(
            onPressed: () async {
              ++counter;
              if (address != -1) {
                await updateView(counter, address);
              }
            },
            child: const Icon(Icons.plus_one),
          ),
        ),
      ],
    );
  }
}
