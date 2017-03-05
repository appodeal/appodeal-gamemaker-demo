#import "AppodealExt.h"

#include <asl.h>
#include <stdio.h>
#include <UIKit/UIKit.h>
#include <Foundation/Foundation.h>


@implementation AppodealAds

enum eAchievementMessages{
    
    e_achievement_our_info=1002,
    e_achievement_friends_info=1003,
    e_achievement_leaderboard_info=1004,
    e_achievement_achievement_info=1005,
    e_achievement_pic_loaded=1006,
    e_achievement_challenge_completed=1007,
    e_achievement_challenge_completed_by_remote=1008,
    e_achievement_challenge_received=1009,
    e_achievement_challenge_list_received=1010,
    e_achievement_challenge_launched=1011,
    e_achievement_player_info=1012,
    e_achievement_purchase_info=1013
};
enum eAchievementShowTypes{
    
    e_achievement_show_ui=0,
    e_achievement_show_profile,
    e_achievement_show_leaderboard,
    e_achievement_show_achievement,
    e_achievement_show_bank,
    e_achievement_show_friend_picker,
    e_achievement_show_purchase_prompt
};

const int EVENT_OTHER_SOCIAL = 70;
extern UIView *g_glView;

extern "C" NSString* findOption( const char* _key );
extern bool F_DsMapAdd_Internal(int _index, char* _pKey, double _value);
extern bool F_DsMapAdd_Internal(int _index, char* _pKey, char* _pValue);

extern int CreateDsMap( int _num, ... );
extern void CreateAsynEventWithDSMap(int dsmapindex, int event_index);

- (AppodealShowStyle)appodealShowStyleConvert:(int) showType
{
    if (showType == 1) {
        return AppodealShowStyleInterstitial;
    }
    
    if (showType == 2) {
        return AppodealShowStyleSkippableVideo;
    }
    
    if (showType == 16) {
        return AppodealShowStyleBannerTop;
    }
    
    if (showType == 8) {
        return AppodealShowStyleBannerBottom;
    }
    
    if (showType == 128) {
        return AppodealShowStyleRewardedVideo;
    }
    
    if (showType == 256) {
        return AppodealShowStyleNonSkippableVideo;
    }
   
    return (AppodealShowStyle) 0;
}

- (AppodealAdType)appodealAdTypeConvert:(int) adType
{
    int nativeAdTypes = 0;
    
    if ((adType & 1) > 0) {
        nativeAdTypes |= AppodealAdTypeInterstitial;
    }
    
    if ((adType & 2) > 0) {
        nativeAdTypes |= AppodealAdTypeSkippableVideo;
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

- (void)appodeal_init:(char*)appKey Arg2:(double)AdTypes
{
    if(![Appodeal isInitalized]) {
        [Appodeal setFramework:APDFrameworkGameMaker];
        [Appodeal initializeWithApiKey:[NSString stringWithCString:appKey encoding:NSUTF8StringEncoding] types:[self appodealAdTypeConvert: ((int) AdTypes)]];
        [Appodeal setInterstitialDelegate:self];
        [Appodeal setBannerDelegate:self];
        [Appodeal setSkippableVideoDelegate:self];
        [Appodeal setRewardedVideoDelegate:self];
        [Appodeal setNonSkippableVideoDelegate:self];
    }
}

- (void)appodeal_track_in_app_purchase:(double)amount currency:(char *)currency
{
    [[APDSdk sharedSdk] trackInAppPurchase:[NSNumber numberWithInt:amount] currency:[NSString stringWithUTF8String:currency]];
}

- (void)appodeal_set_testing:(double)boolean
{
    if (boolean == 0)
        [Appodeal setTestingEnabled:NO];
    else
        [Appodeal setTestingEnabled:YES];
    
}

- (void)appodeal_set_logging:(double)boolean
{
    if (boolean == 0)
        [Appodeal setDebugEnabled:NO];
    else
        [Appodeal setDebugEnabled:YES];
    
}

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

- (void)appodeal_disable_network:(char *)network
{
    [Appodeal disableNetworkForAdType:AppodealAdTypeBanner name:[NSString stringWithCString:network encoding:NSUTF8StringEncoding]];
    [Appodeal disableNetworkForAdType:AppodealAdTypeInterstitial name:[NSString stringWithCString:network encoding:NSUTF8StringEncoding]];
    [Appodeal disableNetworkForAdType:AppodealAdTypeSkippableVideo name:[NSString stringWithCString:network encoding:NSUTF8StringEncoding]];
    [Appodeal disableNetworkForAdType:AppodealAdTypeNonSkippableVideo name:[NSString stringWithCString:network encoding:NSUTF8StringEncoding]];
    [Appodeal disableNetworkForAdType:AppodealAdTypeRewardedVideo name:[NSString stringWithCString:network encoding:NSUTF8StringEncoding]];
}

- (void)appodeal_disable_network_for_adtype:(double)type network:(char *)network
{
    [Appodeal disableNetworkForAdType:[self appodealAdTypeConvert: ((int) type)] name:[NSString stringWithCString:network encoding:NSUTF8StringEncoding]];
}

- (void)appodeal_set_custom_double_segment:(char*)name Arg2:(double)value
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSString stringWithCString:name encoding:NSUTF8StringEncoding], value,
                          nil];
    [Appodeal setCustomRule:dict];
}

- (void)appodeal_set_custom_boolean_segment:(char*)name Arg2:(double)value
{
    if (value == 0)
    {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSString stringWithCString:name encoding:NSUTF8StringEncoding], NO,
                              nil];
        [Appodeal setCustomRule:dict];
    }
    else if (value == 1)
    {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSString stringWithCString:name encoding:NSUTF8StringEncoding], YES,
                              nil];
        [Appodeal setCustomRule:dict];
    }
}

- (void)appodeal_set_custom_int_segment:(char*)name Arg2:(double)value
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSString stringWithCString:name encoding:NSUTF8StringEncoding], (int)value,
                          nil];
    [Appodeal setCustomRule:dict];
}

- (void)appodeal_set_custom_string_segment:(char*)name Arg2:(char*)value
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSString stringWithCString:name encoding:NSUTF8StringEncoding], [NSString stringWithCString:value encoding:NSUTF8StringEncoding],
                          nil];
    [Appodeal setCustomRule:dict];
}


- (void)appodeal_setInterstitialDelegate
{
    [Appodeal setInterstitialDelegate:self];
}
- (void)appodeal_setBannerDelegate
{
    [Appodeal setBannerDelegate:self];
}
- (void)appodeal_setSkippableVideoDelegate
{
    [Appodeal setSkippableVideoDelegate:self];
}
- (void)appodeal_setNonSkippableVideoDelegate
{
    [Appodeal setNonSkippableVideoDelegate:self];
}
- (void)appodeal_setRewardedVideoDelegate
{
    [Appodeal setRewardedVideoDelegate:self];
}

- (NSString *)appodeal_is_loaded:(double)type
{
    if([Appodeal isReadyForShowWithStyle:[self appodealShowStyleConvert:((int) type)]]) {
        return @"true";
    } else {
        return @"false";
    }
}

- (void)appodeal_confirm:(double)type
{
    [Appodeal confirmUsage:[self appodealShowStyleConvert:((int) type)]];
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

-(void)appodeal_show_with_placement:(double)type placement:(char*)placement
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

- (void)appodeal_hide
{
    for (UIView * view in [[UIApplication sharedApplication] keyWindow].rootViewController.view.subviews) {
        if ([view isKindOfClass:[APDBannerView class]]) {
            [view removeFromSuperview];
        }
    }
    [Appodeal hideBanner];
}

- (void)appodeal_cache:(double)type
{
    [Appodeal cacheAd:[self appodealAdTypeConvert:((int) type)]];
}

- (void) appodeal_set_auto_cache:(double)autoCache type:(double)type
{
    if (autoCache == 0)
        [Appodeal setAutocache:NO types:[self appodealAdTypeConvert:((int) type)]];
    else
        [Appodeal setAutocache:YES types:[self appodealAdTypeConvert:((int) type)]];
}

- (void) appodeal_disable_location_permission_check
{
    [Appodeal setLocationTracking:NO];
}

- (void) appodeal_set_user_id:(char*)userId
{
    [Appodeal setUserId:[NSString stringWithCString:userId encoding:NSUTF8StringEncoding]];
}

- (void) appodeal_set_user_email:(char*)userId
{
    [Appodeal setUserEmail:[NSString stringWithCString:userId encoding:NSUTF8StringEncoding]];
}

- (void) appodeal_set_user_birthday:(char*)type
{
    NSString *dateStr = [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    [Appodeal setUserBirthday:date];
}

- (void) appodeal_set_user_age:(double)type
{
    [Appodeal setUserAge:(int)type];
}

- (void) appodeal_set_user_gender:(double)type
{
    int intType = (int) type;
    if (intType == 0)
    {
        [Appodeal setUserGender:AppodealUserGenderOther];
    }
    if (intType == 1)
    {
        [Appodeal setUserGender:AppodealUserGenderMale];
    }
    if (intType == 2)
    {
        [Appodeal setUserGender:AppodealUserGenderFemale];
    }
}

- (void) appodeal_set_user_occupation:(double)type
{
    int intType = (int) type;
    if (intType == 0)
    {
        [Appodeal setUserOccupation:AppodealUserOccupationOther];
    }
    if (intType == 1)
    {
        [Appodeal setUserOccupation:AppodealUserOccupationWork];
    }
    if (intType == 2)
    {
        [Appodeal setUserOccupation:AppodealUserOccupationSchool];
    }
    if (intType == 3)
    {
        [Appodeal setUserOccupation:AppodealUserOccupationUniversity];
    }
}

- (void) appodeal_set_user_relationship:(double)type
{
    int intType = (int) type;
    if (intType == 0)
    {
        [Appodeal setUserRelationship:AppodealUserRelationshipOther];
    }
    if (intType == 1)
    {
        [Appodeal setUserRelationship:AppodealUserRelationshipSingle];
    }
    if (intType == 2)
    {
        [Appodeal setUserRelationship:AppodealUserRelationshipDating];
    }
    if (intType == 3)
    {
        [Appodeal setUserRelationship:AppodealUserRelationshipEngaged];
    }
    if (intType == 4)
    {
        [Appodeal setUserRelationship:AppodealUserRelationshipMarried];
    }
    if (intType == 5)
    {
        [Appodeal setUserRelationship:AppodealUserRelationshipSearching];
    }
}

- (void) appodeal_set_user_smoking_attitude:(double)type
{
    int intType = (int) type;
    if (intType == 0)
    {
        [Appodeal setUserSmokingAttitude:AppodealUserSmokingAttitudeNegative];
    }
    if (intType == 1)
    {
        [Appodeal setUserSmokingAttitude:AppodealUserSmokingAttitudeNeutral];
    }
    if (intType == 2)
    {
        [Appodeal setUserSmokingAttitude:AppodealUserSmokingAttitudePositive];
    }
}

- (void) appodeal_set_user_alcohol_attitude:(double)type
{
    int intType = (int) type;
    if (intType == 0)
    {
        [Appodeal setUserAlcoholAttitude:AppodealUserAlcoholAttitudeNegative];
    }
    if (intType == 1)
    {
        [Appodeal setUserAlcoholAttitude:AppodealUserAlcoholAttitudeNeutral];
    }
    if (intType == 2)
    {
        [Appodeal setUserAlcoholAttitude:AppodealUserAlcoholAttitudePositive];
    }
}

- (void) appodeal_set_user_interests:(char*)Interests
{
    [Appodeal setUserInterests:[NSString stringWithCString:Interests encoding:NSUTF8StringEncoding]];
}

// banner
- (void)bannerDidLoadAd
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_banner", (char*)"loaded");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)bannerDidFailToLoadAd
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_banner", (char*)"failed");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)bannerDidRefresh {
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_banner", (char*)"refreshed");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)bannerDidClick
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_banner", (char*)"clicked");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)bannerDidShow
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_banner", (char*)"shown");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)bannerViewDidLoadAd:(APDBannerView *)bannerView {
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_banner", (char*)"loaded");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)precacheBannerViewDidLoadAd:(APDBannerView *)precacheBannerView {
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_banner", (char*)"loaded");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)bannerViewDidRefresh:(APDBannerView *)bannerView {
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_banner", (char*)"refreshed");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)bannerView:(APDBannerView *)bannerView didFailToLoadAdWithError:(NSError *)error {
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_banner", (char*)"failed");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)bannerViewDidReceiveTapAction:(APDBannerView *)bannerView {
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_banner", (char*)"clicked");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}


// interstitial
- (void)interstitialDidLoadAd
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_interstitial", (char*)"loaded");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)interstitialDidFailToLoadAd
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_interstitial", (char*)"failed");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)interstitialWillPresent
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_interstitial", (char*)"shown");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)interstitialDidDismiss
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_interstitial", (char*)"closed");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)interstitialDidClick
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_interstitial", (char*)"clicked");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

// skipp video
- (void)skippableVideoDidLoadAd
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_skippable_video", (char*)"loaded");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)skippableVideoDidFailToLoadAd
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_skippable_video", (char*)"failed");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)skippableVideoDidPresent
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_skippable_video", (char*)"shown");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)skippableVideoWillDismiss
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_skippable_video", (char*)"closed");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)skippableVideoDidFinish
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_skippable_video", (char*)"finished");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}


// nonskipp video
- (void)nonSkippableVideoDidLoadAd
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_non_skippable_video", (char*)"loaded");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)nonSkippableVideoDidFailToLoadAd
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_non_skippable_video", (char*)"failed");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)nonSkippableVideoDidPresent
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_non_skippable_video", (char*)"shown");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)nonSkippableVideoWillDismiss
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_non_skippable_video", (char*)"closed");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)nonSkippableVideoDidFinish
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_non_skippable_video", (char*)"finished");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}


// rewarded video
- (void)rewardedVideoDidLoadAd
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_rewarded_video", (char*)"loaded");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)rewardedVideoDidFailToLoadAd
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_rewarded_video", (char*)"failed");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)rewardedVideoWillDismiss
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_rewarded_video", (char*)"closed");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)rewardedVideoDidPresent
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_rewarded_video", (char*)"shown");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}

- (void)rewardedVideoDidFinish:(NSUInteger)rewardAmount name:(NSString *)rewardName
{
    int my_map_index = CreateDsMap( 0 );
    F_DsMapAdd_Internal(my_map_index, (char*)"appodeal_rewarded_video", (char*)"finished");
    CreateAsynEventWithDSMap(my_map_index, EVENT_OTHER_SOCIAL);
}


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
