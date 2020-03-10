#import "FrefreshPlugin.h"
#if __has_include(<frefresh/frefresh-Swift.h>)
#import <frefresh/frefresh-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "frefresh-Swift.h"
#endif

@implementation FrefreshPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFrefreshPlugin registerWithRegistrar:registrar];
}
@end
