import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:jni/jni.dart';
import 'package:webview_demo/generated.dart';
import 'package:webview_demo/generated.dart' as gen;

const viewTypeId = '<platform-view-type>';

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

Future<void> updateView(int which, int counter) async {
  await PlatformIsolate.run(() {
    MainActivity.theView
        .castTo(JMap.type(JInteger.type, gen.View.type))[which.toJInteger()]!
        .castTo(WebView.type)
        .loadData(
          '<h1>$counter</h1>'.toJString(),
          ''.toJString(),
          ''.toJString(),
        );
  });
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
  late int counter = widget.index;
  late final int viewId;

  @override
  void initState() {
    super.initState();
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
                    ..addOnPlatformViewCreatedListener(
                        params.onPlatformViewCreated)
                    ..addOnPlatformViewCreatedListener((id) {
                      viewId = id;
                      updateView(viewId, counter);
                    })
                    ..create();
                },
              )),
        ),
        Center(
          child: FloatingActionButton(
            onPressed: () async {
              ++counter;
              await updateView(viewId, counter);
            },
            child: const Icon(Icons.plus_one),
          ),
        ),
      ],
    );
  }
}
