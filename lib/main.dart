import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jni/jni.dart';
import 'package:webview_demo/generated.dart';

import 'native_view_example.dart';

const viewTypeId = '<platform-view-type>';

void main() {
  Jni.initDLApi();

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

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    super.key,
  });

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

Future<void> updateView(int counter) async {
  await PlatformIsolate.run(() {
    MainActivity.theView.castTo(WebView.type).loadData(
          '<h1>$counter</h1>'.toJString(),
          ''.toJString(),
          ''.toJString(),
        );
  });
}

class _HomeWidgetState extends State<HomeWidget> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ++counter;
          updateView(counter);
        },
        child: const Icon(Icons.plus_one),
      ),
      backgroundColor: Colors.amber,
      body: const Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: NativeViewExample(),
        ),
      ),
    );
  }
}
