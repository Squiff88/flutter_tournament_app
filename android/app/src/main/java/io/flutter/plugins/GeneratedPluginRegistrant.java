package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.aloisdeniel.flutter.appcenter.AppcenterPlugin;
import com.aloisdeniel.flutter.appcenter_analytics.AppcenterAnalyticsPlugin;
import com.aloisdeniel.flutter.appcenter_crashes.AppcenterCrashesPlugin;
import io.flutter.plugins.deviceinfo.DeviceInfoPlugin;
import io.flutter.plugins.webviewflutter.WebViewFlutterPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    AppcenterPlugin.registerWith(registry.registrarFor("com.aloisdeniel.flutter.appcenter.AppcenterPlugin"));
    AppcenterAnalyticsPlugin.registerWith(registry.registrarFor("com.aloisdeniel.flutter.appcenter_analytics.AppcenterAnalyticsPlugin"));
    AppcenterCrashesPlugin.registerWith(registry.registrarFor("com.aloisdeniel.flutter.appcenter_crashes.AppcenterCrashesPlugin"));
    DeviceInfoPlugin.registerWith(registry.registrarFor("io.flutter.plugins.deviceinfo.DeviceInfoPlugin"));
    WebViewFlutterPlugin.registerWith(registry.registrarFor("io.flutter.plugins.webviewflutter.WebViewFlutterPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
