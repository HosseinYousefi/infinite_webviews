package com.example.webview_demo

import android.content.Context
import android.view.View
import android.webkit.WebView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.systemchannels.PlatformViewsChannel
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class MainActivity : FlutterActivity() {
    companion object {
        @JvmStatic
        val theView: HashMap<Int, View> = HashMap()
    }
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.platformViewsController.registry.registerViewFactory(
            "<platform-view-type>",
            NativeViewFactoryWrapper(object : NativeViewFactory {
                override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
                    return object : PlatformView {
                        override fun getView(): View {
                            theView[viewId] = theView[viewId] ?: WebView(context)
                            return theView[viewId]!!
                        }

                        override fun dispose() {
                            theView.remove(viewId)
                        }
                    }
                }
            })
        )
    }
}