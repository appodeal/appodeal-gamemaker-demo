#import "AppodealExt.h"

#include <asl.h>
#include <stdio.h>
#include <UIKit/UIKit.h>
#include <Foundation/Foundation.h>


@implementation AppodealAds

const int EVENT_OTHER_SOCIAL = 70;
extern UIView *g_glView;

extern "C" NSString* findOption( const char* _key );
extern bool F_DsMapAdd_Internal(int _index, char* _pKey, double _value);
extern bool F_DsMapAdd_Internal(int _index, char* _pKey, char* _pValue);

extern int CreateDsMap( int _num, ... );
extern void CreateAsynEventWithDSMap(int dsmapindex, int event_index);

#pragma mark - Plugin

#pragma mark Custom properties

NSMutableDictionary *customRules;



#pragma mark Type, log, styles convertion

- (AppodealShowStyle)appodealShowStyleConvert:(int) showType
{
    int resultType = 0;
    if (showType == 3) {
        resultType |= AppodealShowStyleInterstitial;
    }
    
    if (showType == 16) {
        resultType |= AppodealShowStyleBannerTop;
    }
    
    if (showType == 8) {
        resultType |= AppodealShowStyleBannerBottom;
    }
    
    if (showType == 128) {
        resultType |= AppodealShowStyleRewardedVideo;
    }
    
    if (showType == 256) {
        resultType |= AppodealShowStyleNonSkippableVideo;
    }
   
    return (AppodealShowStyle) resultType;
}

- (AppodealAdType)appodealAdTypeConvert:(int) adType
{
    int nativeAdTypes = 0;
    
    if ((adType & 3) > 0) {
        nativeAdTypes |= AppodealAdTypeInterstitial;
    }
    
    if ((adType & 4) > 0) {
        nativeAdTypes |= AppodealAdTypeBanner;
    }
    
    if ((adType & 128) > 0) {
        nativeAdTypes |= AppodealAdTypeRewardedVideo;
    }
    
    if ((adType & 256) > 0) {
        nativeAdTypes |= AppodealAdTypeNonSkippableVideo;
    }
    
    return nativeAdTypes;
}

APDLogLevel parseLogLevel (NSString * log) {
    __block APDLogLevel tempLogLevel = APDLogLevelOff;
    void (^selectedCase)() = @{
                               @"off" : ^{
                                   tempLogLevel = APDLogLevelOff;
                               },
                               @"warning" : ^{
                                   tempLogLevel = APDLogLevelWarning;
                               },
                               @"info" : ^{
                                   tempLogLevel = APDLogLevelInfo;
                               },
                               @"error" : ^{
                                   tempLogLevel = APDLogLevelError;
                               },
                               @"verbose" : ^{
                                   tempLogLevel = APDLogLevelVerbose;
                               },
                               }[log];
    if (selectedCase != nil)
        selectedCase();
    return tempLogLevel;
}



#pragma mark Common methods

- (void)appodeal_init:(char*)appKey Arg2:(double)AdTypes
{
    customRules = [[NSMutableDictionary alloc] init];
    [Appodeal setFramework:APDFrameworkGameMaker];
    [Appodeal setPluginVersion:@"3.1.10"];
    [Appodeal initializeWithApiKey:[NSString stringWithCString:appKey encoding:NSUTF8StringEncoding] types:[self appodealAdTypeConvert: ((int) AdTypes)]];
    [Appodeal setInterstitialDelegate:self];
    [Appodeal setBannerDelegate:self];
    [Appodeal setRewardedVideoDelegate:self];
    [Appodeal setNonSkippableVideoDelegate:self];
}

-(void)appodeal_show:(double)AdType
{
    if((int)AdType == 8000) {
        [self appodeal_bannerTopRight];
    } else if((int)AdType == 8001) {
        [self appodeal_bannerTopLeft];
    } else if((int)AdType == 8002) {
        [self appodeal_bannerBottomRight];
    } else if((int)AdType == 8003) {
        [self appodeal_bannerBottomLeft];
    } else {
        [Appodeal showAd:[self appodealShowStyleConvert:((int) AdType)] rootViewController:[[UIApplication sharedApplication] keyWindow].rootViewController];
    }
}

-(void)appodeal_show_with_placement:(double)type Arg2:(char*)placement
{
    if((int)type == 8000) {
        [self appodeal_bannerTopRightWithPlacement:[NSString stringWithCString:placement encoding:NSUTF8StringEncoding]];
    } else if((int)type == 8001) {
        [self appodeal_bannerTopLeftWithPlacement:[NSString stringWithCString:placement encoding:NSUTF8StringEncoding]];
    } else if((int)type == 8002) {
        [self appodeal_bannerBottomRightWithPlacement:[NSString stringWithCString:placement encoding:NSUTF8StringEncoding]];
    } else if((int)type == 8003) {
        [self appodeal_bannerBottomLeftWithPlacement:[NSString stringWithCString:placement encoding:NSUTF8StringEncoding]];
    } else {
        [Appodeal showAd:[self appodealShowStyleConvert:((int) type)] forPlacement:[NSString stringWithCString:placement encoding:NSUTF8StringEncoding] rootViewController:[[UIApplication sharedApplication] keyWindow].rootViewController];
    }
}

- (NSString *)appodeal_is_loaded:(double)type
{
    if([Appodeal isReadyForShowWithStyle:[self appodealShowStyleConvert:((int) type)]]) {
        return @"true";
    } else {
        return @"false";
    }
}

- (void)appodeal_cache:(double)type
{
    [Appodeal cacheAd:[self appodealAdTypeConvert:((int) type)]];
}

- (void)appodeal_hide:(double)type
{
    for (UIView * view in [[UIApplication sharedApplication] keyWindow].rootViewController.view.subviews) {
        if ([view isKindOfClass:[APDBannerView class]]) {
            [view removeFromSuperview];
        }
    }
    [Appodeal hideBanner];
}

- (void) appodeal_set_auto_cache:(double)autoCache Arg2:(double)type
{
    if (autoCache == 0)
        [Appodeal setAutocache:NO types:[self appodealAdTypeConvert:((int) type)]];
    else
        [Appodeal setAutocache:YES types:[self appodealAdTypeConvert:((int) type)]];
}



#pragma mark Banner settings

- (void)appodeal_set_banner_animated:(double)boolean
{
    if (boolean == 0)
        [Appodeal setBannerAnimationEnabled:NO];
    else if (boolean == 1)
        [Appodeal setBannerAnimationEnabled:YES];
}

- (void)appodeal_set_smart_banner_enabled:(double)boolean
{
    if (boolean == 0)
        [Appodeal setSmartBannersEnabled:NO];
    else if (boolean == 1)
        [Appodeal setSmartBannersEnabled:YES];
}

- (void)appodeal_set_background_visible:(double)boolean
{
    if (boolean == 0)
        [Appodeal setBannerBackgroundVisible:NO];
    else if (boolean == 1)
        [Appodeal setBannerBackgroundVisible:YES];
}



#pragma mark Advanced features

- (void)appodeal_set_testing:(double)boolean
{
    if (boolean == 0)
        [Appodeal setTestingEnabled:NO];
    else
        [Appodeal setTestingEnabled:YES];
}

- (void)appodeal_set_log_level:(char*)logLevel
{
    APDLogLevel level = parseLogLevel([NSString stringWithCString:logLevel encoding:NSUTF8StringEncoding]);
    [Appodeal setLogLevel:level];
}

- (void)appodeal_set_child_directed_treatment:(double)boolean
{
    if (boolean == 0)
        [Appodeal setChildDirectedTreatment:NO];
    else
        [Appodeal setChildDirectedTreatment:YES];
}


- (void)appodeal_disable_network_for_adtype:(double)type Arg2:(char *)network
{
    [Appodeal disableNetworkForAdType:[self appodealAdTypeConvert: ((int) type)] name:[NSString stringWithCString:network encoding:NSUTF8StringEncoding]];
}

- (void)appodeal_disable_network:(char *)network
{
    [Appodeal disableNetworkForAdType:AppodealAdTypeBanner name:[NSString stringWithCString:network encoding:NSUTF8StringEncoding]];
    [Appodeal disableNetworkForAdType:AppodealAdTypeInterstitial name:[NSString stringWithCString:network encoding:NSUTF8StringEncoding]];
    [Appodeal disableNetworkForAdType:AppodealAdTypeSkippableVideo name:[NSString stringWithCString:network encoding:NSUTF8StringEncoding]];
    [Appodeal disableNetworkForAdType:AppodealAdTypeNonSkippableVideo name:[NSString stringWithCString:network encoding:NSUTF8StringEncoding]];
    [Appodeal disableNetworkForAdType:AppodealAdTypeRewardedVideo name:[NSString stringWithCString:network encoding:NSUTF8StringEncoding]];
}

- (void) appodeal_disable_location_permission_check
{
    [Appodeal setLocationTracking:NO];
}

- (NSString *)appodeal_get_version
{
    return [Appodeal getVersion];
}

- (NSString *)appodeal_is_autocache_enabled:(double)type
{
    if([Appodeal isAutocacheEnabled:[self appodealShowStyleConvert:((int) type)]]) {
        return @"true";
    } else {
        return @"false";
    }
}

- (void)appodeal_disable_user_data:(char *)network
{
    [Appodeal disableUserData: [NSString stringWithCString:network encoding:NSUTF8StringEncoding] ];
}




#pragma mark Placement features

- (NSString *)appodeal_can_show:(double)type
{
    if([Appodeal canShowAd:[self appodealShowStyleConvert:((int) type)] forPlacement:@"default"]) {
        return @"true";
    } else {
        return @"false";
    }
}

- (NSString *)appodeal_can_show_for_placement:(double)type Arg2:(char*)placement
{
    if([Appodeal canShowAd:[self appodealShowStyleConvert:((int) type)] forPlacement:[NSString stringWithCString:placement]]) {
        return @"true";
    } else {
        return @"false";
    }
}

- (void)appodeal_set_custom_string_rule:(char*)name Arg2:(char*)value
{
    if (customRules) {
        NSDictionary *tempDictionary = @{[NSString stringWithUTF8String:name]: [NSString stringWithUTF8String:value]};
        [customRules addEntriesFromDictionary:tempDictionary];
        [Appodeal setCustomRule:customRules];
    }
}

- (void)appodeal_set_custom_int_rule:(char*)name Arg2:(double)value
{
    if (customRules) {
        NSDictionary *tempDictionary = @{[NSString stringWithUTF8String:name]: [NSNumber numberWithInt:(int)value]};
        [customRules addEntriesFromDictionary:tempDictionary];
        [Appodeal setCustomRule:customRules];
    }
}

- (void)appodeal_set_custom_boolean_rule:(char*)name Arg2:(double)value
{
    if (customRules) {
        BOOL BoolFromDouble;
        if(value == 0) {
            BoolFromDouble = NO;
        } else {
            BoolFromDouble = YES;
        }
        NSDictionary *tempDictionary = @{[NSString stringWithUTF8String:name]: [NSNumber numberWithBool:BoolFromDouble]};
        [customRules addEntriesFromDictionary:tempDictionary];
        [Appodeal setCustomRule:customRules];
    }
}

- (void)appodeal_set_custom_double_rule:(char*)name Arg2:(double)value
{
    if (customRules) {
        NSDictionary *tempDictionary = @{[NSString stringWithUTF8String:name]: [NSNumber numberWithDouble:value]};
        [customRules addEntriesFromDictionary:tempDictionary];
        [Appodeal setCustomRule:customRules];
    }
}

- (NSString *)appodeal_get_reward:(char*)placement
{
    NSObject <APDReward> * reward = [Appodeal rewardForPlacement:[NSString stringWithCString:placement encoding:NSUTF8StringEncoding]];
    if (reward) {
        NSString *rewardCurrency = reward.currencyName;
        NSUInteger rewardAmount = reward.amount;
        return [NSString stringWithFormat: @"%ld %s", (long)rewardAmount, rewardCurrency];
    }
    else
        return @"";
}

- (NSString *)appodeal_get_reward_amount:(char*)placement
{
    NSObject <APDReward> * reward = [Appodeal rewardForPlacement:[NSString stringWithCString:placement encoding:NSUTF8StringEncoding]];
    if (reward) {
        NSUInteger rewardAmount = reward.amount;
        return [NSString stringWithFormat: @"%ld", (long)rewardAmount];
    }
    else
        return @"";
}

- (NSString *)appodeal_get_reward_currency:(char*)placement
{
    NSObject <APDReward> * reward = [Appodeal rewardForPlacement:[NSString stringWithCString:placement encoding:NSUTF8StringEncoding]];
    if (reward) {
        NSString *rewardCurrency = reward.currencyName;
        return rewardCurrency;
    }
    else
        return @"";
}




#pragma mark User data


- (void) appodeal_set_user_age:(double)type
{
    [Appodeal setUserAge:(int)type];
}

- (void) appodeal_set_user_gender:(double)type
{
    int intType = (int) type;
    switch (intType) {
        case 0:
            [Appodeal setUserGender:AppodealUserGenderOther];
            break;
        case 1:
            [Appodeal setUserGender:AppodealUserGenderMale];
            break;
        case 2:
            [Appodeal setUserGender:AppodealUserGenderMale];
        default:
            break;
    }
}

- (void) appodeal_set_user_id:(char*)userId
{
    [Appodeal setUserId:[NSString stringWithCString:userId encoding:NSUTF8StringEncoding]];
}

- (void)appodeal_track_in_app_purchase:(double)amount Arg2:(char *)currency
{
    [[APDSdk sharedSdk] trackInAppPurchase:[NSNumber numberWithInt:amount] currency:[NSString stringWithUTF8String:currency]];
}




#pragma mark Interstitial callbacks


- (void)appodeal_setInterstitialDelegate
{
    [Appodeal setInterstitialDelegate:self];
}

- (void)interstitialDidLoadAd
{
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_interstitial", (char*)"loaded");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)interstitialDidFailToLoadAd
{
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_interstitial", (char*)"failed");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)interstitialWillPresent
{
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_interstitial", (char*)"shown");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)interstitialDidDismiss
{
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_interstitial", (char*)"closed");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)interstitialDidClick
{
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_interstitial", (char*)"clicked");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

#pragma mark Rewarded video callbacks

- (void)appodeal_setRewardedVideoDelegate
{
    [Appodeal setRewardedVideoDelegate:self];
}

- (void)rewardedVideoDidLoadAd
{
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_rewarded_video", (char*)"loaded");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)rewardedVideoDidFailToLoadAd
{
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_rewarded_video", (char*)"failed");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)rewardedVideoWillDismiss
{
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_rewarded_video", (char*)"closed");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)rewardedVideoDidPresent
{
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_rewarded_video", (char*)"shown");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)rewardedVideoDidFinish:(NSUInteger)rewardAmount name:(NSString *)rewardName
{
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_rewarded_video", (char*)"finished");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}



#pragma mark Non skippable callbacks

- (void)appodeal_setNonSkippableVideoDelegate
{
    [Appodeal setNonSkippableVideoDelegate:self];
}

- (void)nonSkippableVideoDidLoadAd
{
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_non_skippable_video", (char*)"loaded");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)nonSkippableVideoDidFailToLoadAd
{
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_non_skippable_video", (char*)"failed");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)nonSkippableVideoDidPresent
{
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_non_skippable_video", (char*)"shown");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)nonSkippableVideoWillDismiss
{
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_non_skippable_video", (char*)"closed");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)nonSkippableVideoDidFinish
{
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_non_skippable_video", (char*)"finished");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}




#pragma mark Banner callbacks

- (void)appodeal_setBannerDelegate
{
    [Appodeal setBannerDelegate:self];
}

- (void)bannerDidLoadAd
{
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_banner", (char*)"loaded");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)bannerDidFailToLoadAd
{
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_banner", (char*)"failed");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)bannerDidRefresh {
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_banner", (char*)"refreshed");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)bannerDidClick
{
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_banner", (char*)"clicked");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)bannerDidShow
{
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_banner", (char*)"shown");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)bannerViewDidLoadAd:(APDBannerView *)bannerView {
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_banner", (char*)"loaded");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)precacheBannerViewDidLoadAd:(APDBannerView *)precacheBannerView {
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_banner", (char*)"loaded");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)bannerViewDidRefresh:(APDBannerView *)bannerView {
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_banner", (char*)"refreshed");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)bannerView:(APDBannerView *)bannerView didFailToLoadAdWithError:(NSError *)error {
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_banner", (char*)"failed");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)bannerViewDidReceiveTapAction:(APDBannerView *)bannerView {
    int my_map_index = CreateDsMap(0);
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_banner", (char*)"clicked");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}




#pragma mark Custom banners

- (void)appodeal_bannerBottomRight
{
    CGSize viewSize = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject].frame.size;
    APDBannerView *bannerView = [[APDBannerView alloc] initWithSize:kAPDAdSize320x50];
    
    [bannerView setFrame:CGRectMake(viewSize.width - bannerView.frame.size.width, viewSize.height - bannerView.frame.size.height, bannerView.frame.size.width, bannerView.frame.size.height)];
    bannerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    bannerView.rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    bannerView.delegate = self;
    [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] addSubview:bannerView];
    [bannerView loadAd];
}

- (void)appodeal_bannerBottomLeft
{
    CGSize viewSize = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject].frame.size;
    APDBannerView *bannerView = [[APDBannerView alloc] initWithSize:kAPDAdSize320x50];
    
    [bannerView setFrame:CGRectMake(0, viewSize.height - bannerView.frame.size.height, bannerView.frame.size.width, bannerView.frame.size.height)];
    bannerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    bannerView.rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    bannerView.delegate = self;
    [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] addSubview:bannerView];
    [bannerView loadAd];
}

- (void)appodeal_bannerTopRight
{
    CGSize viewSize = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject].frame.size;
    APDBannerView *bannerView = [[APDBannerView alloc] initWithSize:kAPDAdSize320x50];
    
    [bannerView setFrame:CGRectMake(viewSize.width - bannerView.frame.size.width, 0, bannerView.frame.size.width, bannerView.frame.size.height)];
    bannerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    bannerView.rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    bannerView.delegate = self;
    [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] addSubview:bannerView];
    [bannerView loadAd];
}

- (void)appodeal_bannerTopLeft
{
    APDBannerView *bannerView = [[APDBannerView alloc] initWithSize:kAPDAdSize320x50];
    [bannerView setFrame:CGRectMake(0, 0, bannerView.frame.size.width, bannerView.frame.size.height)];
    bannerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    bannerView.rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    bannerView.delegate = self;
    [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] addSubview:bannerView];
    [bannerView loadAd];
}

- (void)appodeal_bannerBottomRightWithPlacement:(NSString*)placement
{
    CGSize viewSize = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject].frame.size;
    APDBannerView *bannerView = [[APDBannerView alloc] initWithSize:kAPDAdSize320x50];
    
    [bannerView setFrame:CGRectMake(viewSize.width - bannerView.frame.size.width, viewSize.height - bannerView.frame.size.height, bannerView.frame.size.width, bannerView.frame.size.height)];
    bannerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    bannerView.placement = placement;
    bannerView.rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    bannerView.delegate = self;
    [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] addSubview:bannerView];
    [bannerView loadAd];
}

- (void)appodeal_bannerBottomLeftWithPlacement:(NSString*)placement
{
    CGSize viewSize = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject].frame.size;
    APDBannerView *bannerView = [[APDBannerView alloc] initWithSize:kAPDAdSize320x50];
    [bannerView setFrame:CGRectMake(0, viewSize.height - bannerView.frame.size.height, bannerView.frame.size.width, bannerView.frame.size.height)];
    bannerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    bannerView.placement = placement;
    bannerView.rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    bannerView.delegate = self;
    [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] addSubview:bannerView];
    [bannerView loadAd];
}

- (void)appodeal_bannerTopRightWithPlacement:(NSString*)placement
{
    CGSize viewSize = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject].frame.size;
    APDBannerView *bannerView = [[APDBannerView alloc] initWithSize:kAPDAdSize320x50];
    
    [bannerView setFrame:CGRectMake(viewSize.width - bannerView.frame.size.width, 0, bannerView.frame.size.width, bannerView.frame.size.height)];
    bannerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    bannerView.placement = placement;
    bannerView.rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    bannerView.delegate = self;
    [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] addSubview:bannerView];
    [bannerView loadAd];
}

- (void)appodeal_bannerTopLeftWithPlacement:(NSString*)placement
{
    APDBannerView *bannerView = [[APDBannerView alloc] initWithSize:kAPDAdSize320x50];
    [bannerView setFrame:CGRectMake(0, 0, bannerView.frame.size.width, bannerView.frame.size.height)];
    bannerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    bannerView.placement = placement;
    bannerView.rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    bannerView.delegate = self;
    [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] addSubview:bannerView];
    [bannerView loadAd];
}

@end
