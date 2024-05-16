//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<path_provider_foundation/PathProviderPlugin.h>)
#import <path_provider_foundation/PathProviderPlugin.h>
#else
@import path_provider_foundation;
#endif

#if __has_include(<yandex_mobileads/YandexMobileAdsPlugin.h>)
#import <yandex_mobileads/YandexMobileAdsPlugin.h>
#else
@import yandex_mobileads;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [PathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"PathProviderPlugin"]];
  [YandexMobileAdsPlugin registerWithRegistrar:[registry registrarForPlugin:@"YandexMobileAdsPlugin"]];
}

@end
