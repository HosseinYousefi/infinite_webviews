package io.flutter.plugins.webviewflutter;

import android.content.Context;
import android.os.Build;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import java.util.function.Consumer;

public class WebViewWrapper extends WebView {
  public WebViewWrapper(@NonNull Context context) {
    super(context);
  }
}
