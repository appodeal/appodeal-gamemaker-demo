#include <Appodeal/Appodeal.h>

#include <UIKit/UIKit.h>
#include <Foundation/Foundation.h>

@interface AppodealAds: NSObject <AppodealInterstitialDelegate, AppodealBannerDelegate, AppodealSkippableVideoDelegate, AppodealRewardedVideoDelegate, AppodealBannerViewDelegate, AppodealNonSkippableVideoDelegate>

@property (nonatomic, strong) UIView* myView;
@property (nonatomic) NSInteger adViewType;
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;

//modified

- (void)appodeal_init:(char*)appKey Arg2:(double)AdTypes;
//- (void)appodeal_init:(char *)key type:(char *)type;
- (void)appodeal_set_testing:(double)boolean;
- (void)appodeal_setSkippableVideoDelegate;
- (void)appodeal_setNonSkippableVideoDelegate;
- (void)appodeal_is_loaded:(double)type;
//- (void)appodeal_show:(char*)type;
-(void)appodeal_show:(double)AdType;
- (void)appodeal_show_with_placement:(double)type placement:(char*)placement ;
- (void)appodeal_cache:(double)type;
- (void)appodeal_setInterstitialDelegate;
- (void)appodeal_setBannerDelegate;
- (void)appodeal_setRewardedVideoDelegate;
- (void)appodeal_set_auto_cache:(double)autoCache type:(double)type;
- (void)appodeal_hide;
- (void)appodeal_confirm:(double)type;
- (void)appodeal_disable_location_permission_check;
- (void)appodeal_set_banner_animated:(double)boolean;
- (void)appodeal_set_smart_banner_enabled:(double)boolean;
- (void)appodeal_set_background_visible:(double)boolean;

- (void)appodeal_set_custom_double_segment:(char*)name Arg2:(double)value;
- (void)appodeal_set_custom_boolean_segment:(char*)name Arg2:(double)value;
- (void)appodeal_set_custom_int_segment:(char*)name Arg2:(double)value;
- (void)appodeal_set_custom_string_segment:(char*)name Arg2:(char*)value;

//to add

- (void)appodeal_set_user_id:(char*)userId;
- (void)appodeal_set_user_email:(char*)userId;
- (void)appodeal_set_user_birthday:(char*)type;
- (void)appodeal_set_user_age:(char*)type;
- (void)appodeal_set_user_gender:(double)type;
- (void)appodeal_set_user_occupation:(double)type;
- (void)appodeal_set_user_relationship:(double)type;
- (void)appodeal_set_user_smoking_attitude:(double)type;
- (void)appodeal_set_user_alcohol_attitude:(double)type;
- (void)appodeal_set_user_interests:(char*)Interests;

//old

//- (void)appodeal_disableNetworkForAdType:(char*)type network:(char*)network;
//- (void)appodeal_attachToView;
//- (void)appodeal_detachFromView;
//- (void)appodeal_isAutocacheEnabled:(char *)type;
//- (void)appodeal_deinitialize;
//- (void)appodeal_isInitalized;
//- (void)appodeal_isReadyWithPriceFloorForShowWithStyle:(char*)type;
//- (void)appodeal_showAdWithPriceFloor:(char*)type;
//- (void)appodeal_getVersion;
//- (void)appodeal_bannerBottomLeft:(double)width heigth:(double)heigth;
//- (void)appodeal_bannerBottomRight:(double)width heigth:(double)heigth;
//- (void)appodeal_bannerTopLeft:(double)width heigth:(double)heigth;
//- (void)appodeal_bannerTopRight:(double)width heigth:(double)heigth;


@end
