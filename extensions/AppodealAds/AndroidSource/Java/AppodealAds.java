package ${YYAndroidPackageName};

import android.os.Build;
import ${YYAndroidPackageName}.R;
import android.app.Activity;
import android.view.ViewGroup;
import android.view.View;
import android.widget.AbsoluteLayout;
import com.yoyogames.runner.RunnerJNILib;
import ${YYAndroidPackageName}.RunnerActivity;
import com.appodeal.ads.*;

import android.util.TypedValue;
import android.content.res.Resources;
import android.view.Gravity;
import android.widget.FrameLayout;


public class AppodealAds extends Activity  {

	private static final int EVENT_OTHER_SOCIAL = 70;

	public int getAdsType(double Arg) {
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
		Appodeal.initialize(RunnerActivity.CurrentActivity, Arg, getAdsType(Arg1));
		setSkippableVideoCallbacks();
		setNonSkippableVideoCallbacks();
		setRewardedVideoCallbacks();
		setInterstitialCallbacks();
		setBannerCallbacks();
	}

	public void appodeal_show(double Arg){
		if(getAdsType(Arg) == 8000) {
			RunnerActivity.CurrentActivity.runOnUiThread(new Runnable() {
				public void run() {
					FrameLayout.LayoutParams appodeaBannerParams = new FrameLayout.LayoutParams(convertDPToPixels(320), FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.TOP | Gravity.RIGHT);
					RunnerActivity.CurrentActivity.addContentView(Appodeal.getBannerView(RunnerActivity.CurrentActivity), appodeaBannerParams);
					Appodeal.setSmartBanners(false);
					Appodeal.show(RunnerActivity.CurrentActivity, Appodeal.BANNER_VIEW);
				}
			});
		} else if (getAdsType(Arg) == 8001) {
			RunnerActivity.CurrentActivity.runOnUiThread(new Runnable() {
				public void run() {
					FrameLayout.LayoutParams appodeaBannerParams = new FrameLayout.LayoutParams(convertDPToPixels(320), FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.TOP | Gravity.LEFT);
					RunnerActivity.CurrentActivity.addContentView(Appodeal.getBannerView(RunnerActivity.CurrentActivity), appodeaBannerParams);
					Appodeal.setSmartBanners(false);
					Appodeal.show(RunnerActivity.CurrentActivity, Appodeal.BANNER_VIEW);
				}
			});
		} else if (getAdsType(Arg) == 8002) {
			RunnerActivity.CurrentActivity.runOnUiThread(new Runnable() {
				public void run() {
					FrameLayout.LayoutParams appodeaBannerParams = new FrameLayout.LayoutParams(convertDPToPixels(320), FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.BOTTOM | Gravity.RIGHT);
					RunnerActivity.CurrentActivity.addContentView(Appodeal.getBannerView(RunnerActivity.CurrentActivity), appodeaBannerParams);
					Appodeal.setSmartBanners(false);
					Appodeal.show(RunnerActivity.CurrentActivity, Appodeal.BANNER_VIEW);
				}
			});
		} else if (getAdsType(Arg) == 8003) {
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
		Appodeal.show(RunnerActivity.CurrentActivity, getAdsType(Arg), placement);
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
			arg = true;
		Appodeal.setLogging(arg);
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
	
	public void appodeal_set_custom_boolean_segment(String Arg, double Arg1){
		boolean arg1 = false;
		if (Arg1!=0)
			arg1 = true;
		Appodeal.setCustomSegment(Arg, arg1);
	}
	
	public void appodeal_set_custom_double_segment(String Arg, double Arg1){
		Appodeal.setCustomSegment(Arg, Arg1);
	}
	
	public void appodeal_set_custom_int_segment(String Arg, double Arg1){
		Appodeal.setCustomSegment(Arg, (int) Arg1);
	}
	
	public void appodeal_set_custom_string_segment(String Arg, String Arg1){
		Appodeal.setCustomSegment(Arg, Arg1);
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