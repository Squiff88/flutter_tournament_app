//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <appcenter/AppcenterPlugin.h>
#import <appcenter_analytics/AppcenterAnalyticsPlugin.h>
#import <appcenter_crashes/AppcenterCrashesPlugin.h>
#import <device_info/DeviceInfoPlugin.h>
#import <webview_flutter/WebViewFlutterPlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [AppcenterPlugin registerWithRegistrar:[registry registrarForPlugin:@"AppcenterPlugin"]];
  [AppcenterAnalyticsPlugin registerWithRegistrar:[registry registrarForPlugin:@"AppcenterAnalyticsPlugin"]];
  [AppcenterCrashesPlugin registerWithRegistrar:[registry registrarForPlugin:@"AppcenterCrashesPlugin"]];
  [FLTDeviceInfoPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTDeviceInfoPlugin"]];
  [FLTWebViewFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTWebViewFlutterPlugin"]];
}

@end
