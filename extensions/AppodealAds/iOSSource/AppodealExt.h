#include <Appodeal/Appodeal.h>

#include <UIKit/UIKit.h>
#include <Foundation/Foundation.h>

@interface AppodealAds: NSObject <AppodealInterstitialDelegate, AppodealBannerDelegate, AppodealRewardedVideoDelegate, APDBannerViewDelegate, AppodealNonSkippableVideoDelegate>

@property (nonatomic, strong) UIView* myView;
@property (nonatomic) NSInteger adViewType;
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;

//common methods

- (void)appodeal_init:(char*)appKey Arg2:(double)AdTypes;
- (void)appodeal_show:(double)AdType;
- (void)appodeal_show_with_placement:(double)type Arg2:(char*)placement;
- (NSString *)appodeal_is_loaded:(double)type;
- (void)appodeal_cache:(double)type;
- (void)appodeal_hide:(double)type;
- (void)appodeal_set_auto_cache:(double)autoCache Arg2:(double)type;

//banner settings

- (void)appodeal_set_banner_animated:(double)boolean;
- (void)appodeal_set_smart_banner_enabled:(double)boolean;
- (void)appodeal_set_background_visible:(double)boolean;

//Advanced features

- (void)appodeal_set_testing:(double)boolean;
- (void)appodeal_set_log_level:(char*)logLevel; //MODIFIED
- (void)appodeal_set_child_directed_treatment:(double)boolean; //NEW
- (void)appodeal_disable_network_for_adtype:(double)type Arg2:(char*)network;
- (void)appodeal_disable_network:(char*)network;
- (void)appodeal_disable_location_permission_check;
- (NSString *)appodeal_get_version; //NEW
- (NSString *)appodeal_is_autocache_enabled:(double)type; //NEW
- (NSString *)appodeal_is_initialised;
- (void)appodeal_disable_user_data:(char*)network; //NEW

//Placement features

- (NSString *)appodeal_can_show:(double)type; //MODIFIED
- (NSString *)appodeal_can_show_for_placement:(double)type Arg2:(char*)placement; //NEW
- (void)appodeal_set_custom_string_rule:(char*)name Arg2:(char*)value;
- (void)appodeal_set_custom_int_rule:(char*)name Arg2:(double)value;
- (void)appodeal_set_custom_boolean_rule:(char*)name Arg2:(double)value;
- (void)appodeal_set_custom_double_rule:(char*)name Arg2:(double)value;
- (NSString *)appodeal_get_reward:(char*)placement; //NEW
- (NSString *)appodeal_get_reward_amount:(char*)placement; //NEW
- (NSString *)appodeal_get_reward_currency:(char*)placement; //NEW

//User data

- (void)appodeal_set_user_age:(double)type;
- (void)appodeal_set_user_gender:(double)type;
- (void)appodeal_set_user_id:(char*)userId;
- (void)appodeal_track_in_app_purchase:(double)amount Arg2:(char*)currency;

//Callbacks

- (void)appodeal_setInterstitialDelegate;
- (void)appodeal_setRewardedVideoDelegate;
- (void)appodeal_setNonSkippableVideoDelegate;
- (void)appodeal_setBannerDelegate;


@end
