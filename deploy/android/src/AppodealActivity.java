package com.appodeal.test;//package place your package name here;

import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.util.Log;
import org.qtproject.qt5.android.bindings.QtActivity;
import org.qtproject.qt5.android.bindings.QtApplication;

import android.app.Activity;
import android.content.res.AssetManager;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.R;

import com.appodeal.ads.Appodeal;
import com.appodeal.ads.BannerCallbacks;
import com.appodeal.ads.InterstitialCallbacks;
import com.appodeal.ads.NonSkippableVideoCallbacks;
import com.appodeal.ads.RewardedVideoCallbacks;
import com.appodeal.ads.SkippableVideoCallbacks;
import com.appodeal.ads.UserSettings;


public class AppodealActivity extends QtActivity{

    public static AppodealActivity a_activity = null;
    public static UserSettings userSettings;

    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        a_activity = this;
        super.onCreate(savedInstanceState);
    }

    public void initialize (String appKey, int adType)
    {
        Appodeal.initialize(a_activity, appKey, adType);
    }
	
    public boolean show(int adType)
    {
        return Appodeal.show(a_activity, adType);
    }
	
	public boolean show(int adType, String placement){
		return Appodeal.show(a_activity, adType, placement);
	}

    public void hide (int adType)
    {
        Appodeal.hide(a_activity, adType);
    }

    public void setTesting (boolean flag)
    {
        Appodeal.setTesting(flag);
    }

    public void setLogLevel (int level)
    {
        com.appodeal.ads.utils.Log.LogLevel appodealLevel;
		switch(level)
		{
			case 0:
                appodealLevel = com.appodeal.ads.utils.Log.LogLevel.debug;
				break;
			case 1:
                appodealLevel = com.appodeal.ads.utils.Log.LogLevel.verbose;
				break;
			case 2:
            default:
                appodealLevel = com.appodeal.ads.utils.Log.LogLevel.none;
		}
        Appodeal.setLogLevel(appodealLevel);
    }

    public boolean isLoaded (int adType)
    {
        return Appodeal.isLoaded(adType);
    }

    public boolean isPrecache (int adType)
    {
        return Appodeal.isPrecache(adType);
    }

    public void cache (int adType)
    {
        Appodeal.cache((Activity)a_activity, adType);
    }

    public void setAutoCache (int adType, boolean flag)
    {
         Appodeal.setAutoCache(adType, flag);
    }

    public void setOnLoadedTriggerBoth (int adType, boolean flag)
    {
        Appodeal.setOnLoadedTriggerBoth(adType, flag);
    }

    public static native void onInterstitialLoaded(boolean isPrecache);
    public static native void onInterstitialFailedToLoad();
    public static native void onInterstitialShown();
    public static native void onInterstitialClicked();
    public static native void onInterstitialClosed();

    public void setInterstitialCallback ()
    {
        Appodeal.setInterstitialCallbacks(new InterstitialCallbacks() {

            @Override
            public void onInterstitialLoaded(boolean isPrecache){AppodealActivity.onInterstitialLoaded(isPrecache);}
            @Override
            public void onInterstitialFailedToLoad(){AppodealActivity.onInterstitialFailedToLoad();}
            @Override
            public void onInterstitialShown(){AppodealActivity.onInterstitialShown();}
            @Override
            public void onInterstitialClicked(){AppodealActivity.onInterstitialClicked();}
            @Override
            public void onInterstitialClosed(){AppodealActivity.onInterstitialClosed();}
          });

    }

    public static native void onBannerLoaded (int height, boolean isPrecache);
    public static native void onBannerFailedToLoad ();
    public static native void onBannerShown ();
    public static native void onBannerClicked ();

    public void setBannerCallback ()
    {
        Appodeal.setBannerCallbacks(new BannerCallbacks() {

            @Override
            public void onBannerLoaded(int height, boolean isPrecache){AppodealActivity.onBannerLoaded(height, isPrecache);}
            @Override
            public void onBannerFailedToLoad(){AppodealActivity.onBannerFailedToLoad();}
            @Override
            public void onBannerShown(){AppodealActivity.onBannerShown();}
            @Override
            public void onBannerClicked(){AppodealActivity.onBannerClicked();}
          });
    }

    public static native void onSkippableVideoLoaded ();
    public static native void onSkippableVideoFailedToLoad ();
    public static native void onSkippableVideoShown ();
    public static native void onSkippableVideoFinished ();
    public static native void onSkippableVideoClosed (boolean isFinished);

    public void setSkippableVideoCallback ()
    {
        Appodeal.setSkippableVideoCallbacks(new SkippableVideoCallbacks() {
			@Override
            public void onSkippableVideoLoaded() {AppodealActivity.onSkippableVideoLoaded();}
			@Override
			public void onSkippableVideoFailedToLoad() {AppodealActivity.onSkippableVideoFailedToLoad();}
			@Override
			public void onSkippableVideoShown() {AppodealActivity.onSkippableVideoShown();}
			@Override
			public void onSkippableVideoFinished() {AppodealActivity.onSkippableVideoFinished();}
			@Override
			public void onSkippableVideoClosed(boolean isFinished) {AppodealActivity.onSkippableVideoClosed(isFinished);}

          });
    }
	
    public static native void onNonSkippableVideoLoaded ();
    public static native void onNonSkippableVideoFailedToLoad ();
    public static native void onNonSkippableVideoShown ();
    public static native void onNonSkippableVideoFinished ();
    public static native void onNonSkippableVideoClosed (boolean isFinished);
	
	public void setNonSkippableVideoCallback(){
		runOnUiThread(new Runnable(){
			@Override
			public void run() {
				Appodeal.setNonSkippableVideoCallbacks(new NonSkippableVideoCallbacks(){
						@Override
						public void onNonSkippableVideoLoaded() { AppodealActivity.onNonSkippableVideoLoaded(); }
						@Override
						public void onNonSkippableVideoFailedToLoad() { AppodealActivity.onNonSkippableVideoFailedToLoad(); }
						@Override
						public void onNonSkippableVideoShown() {AppodealActivity.onNonSkippableVideoShown();}
						@Override
						public void onNonSkippableVideoFinished() { AppodealActivity.onNonSkippableVideoFinished(); }
						@Override
						public void onNonSkippableVideoClosed(boolean isFinished) { AppodealActivity.onNonSkippableVideoClosed(isFinished); }
				});
			}
		});
    }

    public static native void onRewardedVideoLoaded ();
    public static native void onRewardedVideoFailedToLoad ();
    public static native void onRewardedVideoShown ();
    public static native void onRewardedVideoFinished (int i, String s);
    public static native void onRewardedVideoClosed (boolean isFinished);

    public void setRewardedVideoCallback ()
    {
        Appodeal.setRewardedVideoCallbacks(new RewardedVideoCallbacks() {
			@Override
			public void onRewardedVideoLoaded() {AppodealActivity.onRewardedVideoLoaded();}
			@Override
			public void onRewardedVideoFailedToLoad() {AppodealActivity.onRewardedVideoFailedToLoad();}
			@Override
			public void onRewardedVideoShown() {AppodealActivity.onRewardedVideoShown();}
			@Override
			public void onRewardedVideoFinished(int i, String s) {AppodealActivity.onRewardedVideoFinished(i, s == null? "" : s);}
			@Override
			public void onRewardedVideoClosed(boolean isFinished) {AppodealActivity.onRewardedVideoClosed(isFinished);}
        });
    }

    public void disableNetwork (String network)
    {
        Appodeal.disableNetwork((Context) a_activity, (String) network);
    }

    public void disableNetwork (String network, int adType)
    {
        Appodeal.disableNetwork((Context) a_activity, (String) network, adType);
    }

    public void disableLocationPermissionCheck ()
    {
        Appodeal.disableLocationPermissionCheck();
    }

    public void trackInAppPurchase (String currencyCode, int amount)
    {
        Appodeal.trackInAppPurchase(a_activity, amount, currencyCode);
    }

    private UserSettings getUserSettings ()
    {
		if(userSettings == null)
			userSettings = Appodeal.getUserSettings(a_activity);
		return userSettings;
    }

    public void setAge (int age)
    {
        getUserSettings().setAge(age);
    }

    public void setBirthday (String day)
    {
        getUserSettings().setBirthday(day);
    }

    public void setEmail (String email)
    {
        getUserSettings().setEmail(email);
    }

    public void setGender (int gender)
    {
        switch (gender)
        {
            case 0:
                getUserSettings().setGender(UserSettings.Gender.FEMALE);
                break;
            case 1:
                getUserSettings().setGender(UserSettings.Gender.MALE);
                break;
            case 2:
                getUserSettings().setGender(UserSettings.Gender.OTHER);
                break;
        }
    }

    public void setInterests (String interest)
    {
        getUserSettings().setInterests(interest);
    }

    public void setOccupation (int occupation)
    {
        switch (occupation)
        {
            case 0:
                getUserSettings().setOccupation(UserSettings.Occupation.WORK);
                break;
            case 1:
                getUserSettings().setOccupation(UserSettings.Occupation.UNIVERSITY);
                break;
            case 2:
                getUserSettings().setOccupation(UserSettings.Occupation.SCHOOL);
                break;
            case 3:
                getUserSettings().setOccupation(UserSettings.Occupation.OTHER);
                break;
        }
    }

    public void setRelation (int relation)
    {
        switch (relation)
        {
            case 0:
                getUserSettings().setRelation(UserSettings.Relation.DATING);
                break;
            case 1:
                getUserSettings().setRelation(UserSettings.Relation.ENGAGED);
                break;
            case 2:
                getUserSettings().setRelation(UserSettings.Relation.MARRIED);
                break;
            case 3:
                getUserSettings().setRelation(UserSettings.Relation.SEARCHING);
                break;
            case 4:
                getUserSettings().setRelation(UserSettings.Relation.SINGLE);
                break;
            case 5:
                getUserSettings().setRelation(UserSettings.Relation.OTHER);
                break;
        }
    }

    public void setAlcohol (int alcohol)
    {
        switch (alcohol)
        {
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

    public void setSmoking (int smoking)
    {
        switch (smoking)
        {
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
	
	public void setUserId(String userId){
		getUserSettings().setUserId(userId);
	}
	
	public void confirm(int adType){
		Appodeal.confirm(adType);
	}
	
	public void disableWriteExternalStoragePermissionCheck(){
		Appodeal.disableWriteExternalStoragePermissionCheck();
	}
	
	public void requestAndroidMPermissions(){
		Appodeal.requestAndroidMPermissions(a_activity, null);
	}
	
	public void set728x90Banners(boolean flag){
		Appodeal.set728x90Banners(flag);
	}
	
	public void setBannerAnimation(boolean flag){
		Appodeal.setBannerAnimation(flag);
	}
	
	public void setCustomRule(String name, String value){
		Appodeal.setCustomRule(name, value);
	}
	
	public void setCustomRule(String name, double value){
		Appodeal.setCustomRule(name, value);
	}
	
	public void setCustomRule(String name, boolean value){
		Appodeal.setCustomRule(name, value);
	}
	
	public void setCustomRule(String name, int value){
		Appodeal.setCustomRule(name, value);
	}
	
	public void setSmartBanners(boolean flag){
		Appodeal.setSmartBanners(flag);
	}

    @Override
    protected void onDestroy ()
    {
        super.onDestroy();
        a_activity = null;
    }
	
}

