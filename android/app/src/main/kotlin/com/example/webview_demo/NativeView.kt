package com.example.webview_demo

import android.content.Context
import android.view.View
import android.webkit.WebView
import io.flutter.plugin.platform.PlatformView
import com.github.dart_lang.jni.JniUtils
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformViewFactory

class NativeViewFactory(private val messenger: BinaryMessenger) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(
        context: Context,
        id: Int,
        args: Any?
    ): PlatformView {
        return NativeView(
            context,
            messenger,
            id,
            args
        )
    }
}

class NativeView internal constructor(private val context: Context, messenger: BinaryMessenger, id: Int, args: Any?) :
    PlatformView {
    private val webView: WebView = WebView(context)
    private val methodChannel: MethodChannel

    init {
        methodChannel = MethodChannel(messenger, "WebView/$id")
        methodChannel.invokeMethod("address", JniUtils.globalReferenceAddressOf(webView))
    }

    override fun getView(): View {
        return webView
    }

    override fun dispose() {}
}