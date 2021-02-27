#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    int flutter_native_splash = 1;
    UIApplication.sharedApplication.statusBarHidden = false;

  [GeneratedPluginRegistrant registerWithRegistry:self];
    
  [[ZaloSDK sharedInstance] initializeWithAppId:@"2252284608446108140"];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options {
  return [[ZDKApplicationDelegate sharedInstance] application:application openURL:url options:options];
}

@end
