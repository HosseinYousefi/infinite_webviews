package com.example.webview_demo

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.plugin.platform.PlatformViewRegistry

class NativePlugin: FlutterPlugin, ActivityAware {
    @Suppress("unused", "deprecation")
    fun registerWith(
        registrar: Registrar
    ) {
        NativePlugin().setUp(registrar.messenger(), registrar.platformViewRegistry())
    }

    @Suppress("unused", "deprecation")
    private fun setUp(binaryMessenger: BinaryMessenger, viewRegistry: PlatformViewRegistry) {
        viewRegistry.registerViewFactory(
            "plugins.flutter.io/webview", NativeViewFactory(binaryMessenger)
        )
    }
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        setUp(binding.binaryMessenger, binding.platformViewRegistry)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {}

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {}

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onDetachedFromActivity() {}

}
