package com.example.webview_demo

import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

interface NativeViewFactory {
    fun create(context: Context, viewId: Int, args: Any?): PlatformView
}

class NativeViewFactoryWrapper(private val factory: NativeViewFactory) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return factory.create(context, viewId, args);
    }
}
