package com.example.webview_demo

import android.content.Context
import android.view.View
import android.webkit.WebView
import io.flutter.plugin.platform.PlatformView

internal class NativeView(context: Context) : PlatformView {
    private val webView: WebView

    override fun getView(): View {
        return webView
    }

    override fun dispose() {}

    init {
        webView = WebView(context)
    }
}
