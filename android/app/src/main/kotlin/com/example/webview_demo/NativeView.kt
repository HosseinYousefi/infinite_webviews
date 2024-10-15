package com.example.webview_demo

import android.content.Context
import android.view.View
import android.webkit.WebView
import io.flutter.plugin.platform.PlatformView
import com.github.dart_lang.jni.JniUtils
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformViewFactory

class NativeViewFactory(private val messenger: BinaryMessenger) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(
        context: Context,
        id: Int,
        args: Any?
    ): PlatformView {
        return NativeView((args as Number).toLong())
    }
}

class NativeView internal constructor(private val address: Long) :
    PlatformView {
    private val webView: WebView = JniUtils.fromReferenceAddress(address) as WebView

    override fun getView(): View {
        return webView
    }

    override fun dispose() {}
}