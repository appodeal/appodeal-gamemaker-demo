package ${YYAndroidPackageName};

import android.os.Build;
import ${YYAndroidPackageName}.R;
import android.app.Activity;
import android.view.ViewGroup;
import android.view.View;
import android.widget.AbsoluteLayout;

import com.appodeal.ads.utils.Log;
import com.yoyogames.runner.RunnerJNILib;
import ${YYAndroidPackageName}.RunnerActivity;

import com.appodeal.ads.Appodeal;
import com.appodeal.ads.UserSettings;
import com.appodeal.ads.InterstitialCallbacks;
import com.appodeal.ads.SkippableVideoCallbacks;
import com.appodeal.ads.NonSkippableVideoCallbacks;
import com.appodeal.ads.RewardedVideoCallbacks;
import com.appodeal.ads.BannerCallbacks;

import android.util.TypedValue;
import android.content.res.Resources;
import android.view.Gravity;
import android.widget.FrameLayout;


public class AppodealAds extends Activity  {

    private static final int EVENT_OTHER_SOCIAL = 70;
    private UserSettings userSettings;

    public int getAdsType(double Arg) {
        int typeArg = (int) Arg;
        int adType = 0;
        if((typeArg & Appodeal.INTERSTITIAL) > 0) {
            adType |= Appodeal.INTERSTITIAL;
        }
        if((typeArg & Appodeal.SKIPPABLE_VIDEO) > 0) {
            adType |= Appodeal.SKIPPABLE_VIDEO;
        }
        if((typeArg & 256) > 0) {
            adType |= Appodeal.NON_SKIPPABLE_VIDEO;
        }
        if((typeArg & Appodeal.REWARDED_VIDEO) > 0) {
            adType |= Appodeal.REWARDED_VIDEO;
        }
        if(((typeArg & Appodeal.BANNER) > 0) || ((typeArg & Appodeal.BANNER_BOTTOM) > 0) || ((typeArg & Appodeal.BANNER_TOP) > 0)) {
            adType |= Appodeal.BANNER;
        }
        return adType;
    }

    public int getBannerType(double Arg) {
        return (int) Arg;
    }

    public void createDsMap(String Arg0, String Arg1){
        int dsmapindex = RunnerJNILib.jCreateDsMap(null,null,null);
        RunnerJNILib.DsMapAddString(dsmapindex,Arg0,Arg1 );
        RunnerJNILib.CreateAsynEventWithDSMap(dsmapindex,EVENT_OTHER_SOCIAL);
    }

//+++++++++++++++++++++++++++++++++++++++++++++
// GMS functions
//+++++++++++++++++++++++++++++++++++++++++++++


    public void appodeal_init(String Arg, double Arg1){
        Appodeal.disableNetwork(RunnerActivity.CurrentActivity, "cheetah");
        setSkippableVideoCallbacks();
        setNonSkippableVideoCallbacks();
        setRewardedVideoCallbacks();
        setInterstitialCallbacks();
        setBannerCallbacks();
        Appodeal.initialize(RunnerActivity.CurrentActivity, Arg, getAdsType(Arg1));
    }

    public void appodeal_show(double Arg){
        if(getBannerType(Arg) == 8000) {
            RunnerActivity.CurrentActivity.runOnUiThread(new Runnable() {
                public void run() {
                    FrameLayout.LayoutParams appodeaBannerParams = new FrameLayout.LayoutParams(convertDPToPixels(320), FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.TOP | Gravity.RIGHT);
                    RunnerActivity.CurrentActivity.addContentView(Appodeal.getBannerView(RunnerActivity.CurrentActivity), appodeaBannerParams);
                    Appodeal.setSmartBanners(false);
                    Appodeal.show(RunnerActivity.CurrentActivity, Appodeal.BANNER_VIEW);
                }
            });
        } else if (getBannerType(Arg) == 8001) {
            RunnerActivity.CurrentActivity.runOnUiThread(new Runnable() {
                public void run() {
                    FrameLayout.LayoutParams appodeaBannerParams = new FrameLayout.LayoutParams(convertDPToPixels(320), FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.TOP | Gravity.LEFT);
                    RunnerActivity.CurrentActivity.addContentView(Appodeal.getBannerView(RunnerActivity.CurrentActivity), appodeaBannerParams);
                    Appodeal.setSmartBanners(false);
                    Appodeal.show(RunnerActivity.CurrentActivity, Appodeal.BANNER_VIEW);
                }
            });
        } else if (getBannerType(Arg) == 8002) {
            RunnerActivity.CurrentActivity.runOnUiThread(new Runnable() {
                public void run() {
                    FrameLayout.LayoutParams appodeaBannerParams = new FrameLayout.LayoutParams(convertDPToPixels(320), FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.BOTTOM | Gravity.RIGHT);
                    RunnerActivity.CurrentActivity.addContentView(Appodeal.getBannerView(RunnerActivity.CurrentActivity), appodeaBannerParams);
                    Appodeal.setSmartBanners(false);
                    Appodeal.show(RunnerActivity.CurrentActivity, Appodeal.BANNER_VIEW);
                }
            });
        } else if (getBannerType(Arg) == 8003) {
            RunnerActivity.CurrentActivity.runOnUiThread(new Runnable() {
                public void run() {
                    FrameLayout.LayoutParams appodeaBannerParams = new FrameLayout.LayoutParams(convertDPToPixels(320), FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.BOTTOM | Gravity.LEFT);
                    RunnerActivity.CurrentActivity.addContentView(Appodeal.getBannerView(RunnerActivity.CurrentActivity), appodeaBannerParams);
                    Appodeal.setSmartBanners(false);
                    Appodeal.show(RunnerActivity.CurrentActivity, Appodeal.BANNER_VIEW);
                }
            });
        } else {
            Appodeal.show(RunnerActivity.CurrentActivity, getAdsType(Arg));
        }
    }

    public static int convertDPToPixels(float dp){
        Resources r = RunnerActivity.CurrentActivity.getResources();
        float px = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp, r.getDisplayMetrics());
        return Math.round(px);
    }

    public void appodeal_show_with_placement(double Arg, String placement){
        final String placement1 = placement;
        if(getBannerType(Arg) == 8000) {
            RunnerActivity.CurrentActivity.runOnUiThread(new Runnable() {
                public void run() {
                    FrameLayout.LayoutParams appodeaBannerParams = new FrameLayout.LayoutParams(convertDPToPixels(320), FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.TOP | Gravity.RIGHT);
                    RunnerActivity.CurrentActivity.addContentView(Appodeal.getBannerView(RunnerActivity.CurrentActivity), appodeaBannerParams);
                    Appodeal.setSmartBanners(false);
                    Appodeal.show(RunnerActivity.CurrentActivity, Appodeal.BANNER_VIEW, placement1);
                }
            });
        } else if (getBannerType(Arg) == 8001) {
            RunnerActivity.CurrentActivity.runOnUiThread(new Runnable() {
                public void run() {
                    FrameLayout.LayoutParams appodeaBannerParams = new FrameLayout.LayoutParams(convertDPToPixels(320), FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.TOP | Gravity.LEFT);
                    RunnerActivity.CurrentActivity.addContentView(Appodeal.getBannerView(RunnerActivity.CurrentActivity), appodeaBannerParams);
                    Appodeal.setSmartBanners(false);
                    Appodeal.show(RunnerActivity.CurrentActivity, Appodeal.BANNER_VIEW, placement1);
                }
            });
        } else if (getBannerType(Arg) == 8002) {
            RunnerActivity.CurrentActivity.runOnUiThread(new Runnable() {
                public void run() {
                    FrameLayout.LayoutParams appodeaBannerParams = new FrameLayout.LayoutParams(convertDPToPixels(320), FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.BOTTOM | Gravity.RIGHT);
                    RunnerActivity.CurrentActivity.addContentView(Appodeal.getBannerView(RunnerActivity.CurrentActivity), appodeaBannerParams);
                    Appodeal.setSmartBanners(false);
                    Appodeal.show(RunnerActivity.CurrentActivity, Appodeal.BANNER_VIEW, placement1);
                }
            });
        } else if (getBannerType(Arg) == 8003) {
            RunnerActivity.CurrentActivity.runOnUiThread(new Runnable() {
                public void run() {
                    FrameLayout.LayoutParams appodeaBannerParams = new FrameLayout.LayoutParams(convertDPToPixels(320), FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.BOTTOM | Gravity.LEFT);
                    RunnerActivity.CurrentActivity.addContentView(Appodeal.getBannerView(RunnerActivity.CurrentActivity), appodeaBannerParams);
                    Appodeal.setSmartBanners(false);
                    Appodeal.show(RunnerActivity.CurrentActivity, Appodeal.BANNER_VIEW, placement1);
                }
            });
        } else {
            Appodeal.show(RunnerActivity.CurrentActivity, getAdsType(Arg), placement);
        }
    }

    public void appodeal_hide(double Arg){
        Appodeal.hide(RunnerActivity.CurrentActivity, getAdsType(Arg));
    }

    public void appodeal_set_testing(double Arg){
        boolean arg = false;
        if (Arg!=0)
            arg = true;
        Appodeal.setTesting(arg);
    }

    public void appodeal_set_logging(double Arg){
        boolean arg = false;
        if (Arg!=0)
            Appodeal.setLogLevel(Log.LogLevel.verbose);
		else
			Appodeal.setLogLevel(Log.LogLevel.none);
    }

    public String appodeal_is_loaded(double Arg){
        String arg = "false";
        if (Appodeal.isLoaded(getAdsType(Arg)))
            arg = "true";
        return arg;
    }

    public String appodeal_is_precache(double Arg){
        String arg = "false";
        if (Appodeal.isPrecache(getAdsType(Arg)))
            arg = "true";
        return arg;
    }

    public void appodeal_cache(double Arg){
        Appodeal.cache(RunnerActivity.CurrentActivity, getAdsType(Arg));
    }

    public void appodeal_set_auto_cache(double Arg0, double Arg1){
        boolean arg1 = false;
        if (Arg1!=0)
            arg1 = true;
        Appodeal.setAutoCache(getAdsType(Arg0), arg1);
    }

    public void appodeal_set_on_loaded_trigger_both(double Arg0, double Arg1){
        boolean arg1 = false;
        if (Arg1!=0)
            arg1 = true;
        Appodeal.setOnLoadedTriggerBoth(getAdsType(Arg0), arg1);
    }

    public void appodeal_disable_network(String Arg){
        Appodeal.disableNetwork(RunnerActivity.CurrentActivity, Arg);
    }

    public void appodeal_disable_network_for_adtype(String Arg, double Arg1){
        Appodeal.disableNetwork(RunnerActivity.CurrentActivity, Arg, getAdsType(Arg1));
    }

    public void appodeal_disable_location_permission_check(){
        Appodeal.disableLocationPermissionCheck();
    }

    public void appodeal_disable_write_external_storage_check(){
        Appodeal.disableWriteExternalStoragePermissionCheck();
    }

    public void appodeal_confirm(double Arg){
        Appodeal.confirm(getAdsType(Arg));
    }

    public void appodeal_track_in_app_purchase(double Arg, String Arg1){
        Appodeal.trackInAppPurchase(RunnerActivity.CurrentActivity, (int) Arg, Arg1);
    }

    public void appodeal_set_custom_boolean_rule(String Arg, double Arg1){
        boolean arg1 = false;
        if (Arg1!=0)
            arg1 = true;
        Appodeal.setCustomRule(Arg, arg1);
    }

    public void appodeal_set_custom_double_rulet(String Arg, double Arg1){
        Appodeal.setCustomRule(Arg, Arg1);
    }

    public void appodeal_set_custom_int_rule(String Arg, double Arg1){
        Appodeal.setCustomRule(Arg, (int) Arg1);
    }

    public void appodeal_set_custom_string_rule(String Arg, String Arg1){
        Appodeal.setCustomRule(Arg, Arg1);
    }

    public void appodeal_set_background_visible(double Arg) {

    }

    public void appodeal_set_smart_banner_enabled(double Arg) {
        boolean arg1 = false;
        if (Arg!=0)
            arg1 = true;
        Appodeal.setSmartBanners(arg1);
    }

    public void appodeal_set_banner_animated(double Arg) {
        boolean arg1 = false;
        if (Arg!=0)
            arg1 = true;
        Appodeal.setBannerAnimation(arg1);
    }

    private UserSettings getUserSettings() {
        if(userSettings == null) {
            userSettings = Appodeal.getUserSettings(RunnerActivity.CurrentActivity);
        }
        return userSettings;
    }

    public void appodeal_set_user_id(String Arg) {
        getUserSettings().setUserId(Arg);
    }

    public void appodeal_set_user_email(String Arg) {
        getUserSettings().setEmail(Arg);
    }

    public void appodeal_set_user_birthday(String Arg) {
        getUserSettings().setBirthday(Arg);
    }

    public void appodeal_set_user_age(double Arg) {
        getUserSettings().setAge((int)Arg);
    }

    public void appodeal_set_user_gender(double Arg) {
        switch ((int)Arg) {
            case 0:
                getUserSettings().setGender(UserSettings.Gender.OTHER);
                break;
            case 1:
                getUserSettings().setGender(UserSettings.Gender.MALE);
                break;
            case 2:
                getUserSettings().setGender(UserSettings.Gender.FEMALE);
                break;
        }
    }

    public void appodeal_set_user_occupation(double Arg) {
        switch ((int)Arg) {
            case 0:
                getUserSettings().setOccupation(UserSettings.Occupation.OTHER);
                break;
            case 1:
                getUserSettings().setOccupation(UserSettings.Occupation.WORK);
                break;
            case 2:
                getUserSettings().setOccupation(UserSettings.Occupation.SCHOOL);
                break;
            case 3:
                getUserSettings().setOccupation(UserSettings.Occupation.UNIVERSITY);
                break;
        }
    }

    public void appodeal_set_user_relationship(double Arg) {
        switch ((int)Arg) {
            case 0:
                getUserSettings().setRelation(UserSettings.Relation.OTHER);
                break;
            case 1:
                getUserSettings().setRelation(UserSettings.Relation.SINGLE);
                break;
            case 2:
                getUserSettings().setRelation(UserSettings.Relation.DATING);
                break;
            case 3:
                getUserSettings().setRelation(UserSettings.Relation.ENGAGED);
                break;
            case 4:
                getUserSettings().setRelation(UserSettings.Relation.MARRIED);
                break;
            case 5:
                getUserSettings().setRelation(UserSettings.Relation.SEARCHING);
                break;
        }
    }

    public void appodeal_set_user_smoking_attitude(double Arg) {
        switch ((int)Arg) {
            case 0:
                getUserSettings().setSmoking(UserSettings.Smoking.NEGATIVE);
                break;
            case 1:
                getUserSettings().setSmoking(UserSettings.Smoking.NEUTRAL);
                break;
            case 2:
                getUserSettings().setSmoking(UserSettings.Smoking.POSITIVE);
                break;
        }
    }

    public void appodeal_set_user_alcohol_attitude(double Arg) {
        switch ((int)Arg) {
            case 0:
                getUserSettings().setAlcohol(UserSettings.Alcohol.NEGATIVE);
                break;
            case 1:
                getUserSettings().setAlcohol(UserSettings.Alcohol.NEUTRAL);
                break;
            case 2:
                getUserSettings().setAlcohol(UserSettings.Alcohol.POSITIVE);
                break;
        }
    }

    public void appodeal_set_user_interests(String Arg) {
        getUserSettings().setInterests(Arg);
    }
	
	public void appodeal_request_android_m_permissions(){
		Appodeal.requestAndroidMPermissions(RunnerActivity.CurrentActivity, null);
	}
	
	public void appodeal_set_728x90_banners(double Arg){
		boolean arg = false;
		if(Arg!=0)
			arg = true;
		Appodeal.set728x90Banners(arg);
	}


//++++++++++++++++++++++++++++++++++++++++++++++++++++
// CALLBACKS
//++++++++++++++++++++++++++++++++++++++++++++++++++++

    public void setSkippableVideoCallbacks(){

        Appodeal.setSkippableVideoCallbacks(new SkippableVideoCallbacks() {

            String Arg = "appodeal_skippable_video";

            @Override
            public void onSkippableVideoLoaded() {
                createDsMap(Arg,"loaded");
            }
            @Override
            public void onSkippableVideoFailedToLoad() {
                createDsMap(Arg,"failed");
            }
            @Override
            public void onSkippableVideoShown() {
                createDsMap(Arg,"shown");
            }
            @Override
            public void onSkippableVideoFinished() {
                createDsMap(Arg,"finished");
            }
            @Override
            public void onSkippableVideoClosed(boolean finished) {
                createDsMap(Arg,"closed");
            }

        });

    }

    public void setNonSkippableVideoCallbacks(){

        Appodeal.setNonSkippableVideoCallbacks(new NonSkippableVideoCallbacks() {

            String Arg = "appodeal_non_skippable_video";

            @Override
            public void onNonSkippableVideoLoaded() {
                createDsMap(Arg,"loaded");
            }
            @Override
            public void onNonSkippableVideoFailedToLoad() {
                createDsMap(Arg,"failed");
            }
            @Override
            public void onNonSkippableVideoShown() {
                createDsMap(Arg,"shown");
            }
            @Override
            public void onNonSkippableVideoFinished() {
                createDsMap(Arg,"finished");
            }
            @Override
            public void onNonSkippableVideoClosed(boolean finished) {
                createDsMap(Arg,"closed");
            }

        });

    }

    public void setRewardedVideoCallbacks(){

        Appodeal.setRewardedVideoCallbacks(new RewardedVideoCallbacks() {

            String Arg = "appodeal_rewarded_video";

            @Override
            public void onRewardedVideoLoaded() {
                createDsMap(Arg,"loaded");
            }
            @Override
            public void onRewardedVideoFailedToLoad() {
                createDsMap(Arg,"failed");
            }
            @Override
            public void onRewardedVideoShown() {
                createDsMap(Arg,"shown");
            }
            @Override
            public void onRewardedVideoFinished(int amount, String name) {
                createDsMap(Arg,"finished");
            }
            @Override
            public void onRewardedVideoClosed(boolean finished) {
                createDsMap(Arg,"closed");
            }

        });

    }


    public void setInterstitialCallbacks(){

        Appodeal.setInterstitialCallbacks(new InterstitialCallbacks() {

            String Arg = "appodeal_interstitial";

            @Override
            public void onInterstitialLoaded(boolean isPrecache) {
                createDsMap(Arg,"loaded");
            }
            @Override
            public void onInterstitialFailedToLoad() {
                createDsMap(Arg,"failed");
            }
            @Override
            public void onInterstitialShown() {
                createDsMap(Arg,"shown");
            }
            @Override
            public void onInterstitialClicked() {
                createDsMap(Arg,"clicked");
            }
            @Override
            public void onInterstitialClosed() {
                createDsMap(Arg,"closed");
            }

        });

    }


    public void setBannerCallbacks(){

        Appodeal.setBannerCallbacks(new BannerCallbacks() {

            String Arg = "appodeal_banner";

            @Override
            public void onBannerLoaded(int height, boolean isPrecache) {
                createDsMap(Arg,"loaded");
            }
            @Override
            public void onBannerFailedToLoad() {
                createDsMap(Arg,"failed");
            }
            @Override
            public void onBannerShown() {
                createDsMap(Arg,"shown");
            }
            @Override
            public void onBannerClicked() {
                createDsMap(Arg,"clicked");
            }

        });

    }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++

    @Override
    public void onResume() {
        super.onResume();
        Appodeal.onResume(RunnerActivity.CurrentActivity, Appodeal.BANNER);
    }

}