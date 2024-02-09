package com.example.webview_demo

import android.content.Context
import android.view.View
import android.webkit.WebView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class MainActivity : FlutterActivity() {
    companion object {
        @JvmStatic
        lateinit var theView: View
    }
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        theView = WebView(context)
        flutterEngine.platformViewsController.registry.registerViewFactory(
            "<platform-view-type>",
            NativeViewFactoryWrapper(object : NativeViewFactory {
                override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
                    return object : PlatformView {
                        override fun getView(): View {
                            return theView
                        }

                        override fun dispose() {}
                    }
                }
            })
        )
    }
}