#ifndef APPODEALADS_H
#define APPODEALADS_H

#include "appodealinterface.h"

class AppodealAds
{
public:
    enum Gender {MALE = 0, FFEMALE = 1, OTHER = 2};
    enum Occupation {WORK = 0, UNIVERSITY = 1, SCHOOL = 2, OCCUPATION_OTHER = 3};
    enum Relation {DATING = 0, ENGAGED = 1, MARRIED = 2, SEARCHING = 3, SINGLE = 4, RELATION_OTHER = 5};
    enum Smoking {SMOKING_NEGATIVE = 0, SMOKING_NEUTRAL = 1, SMOKING_POSITIVE = 2};
    enum Alcohol {ALCOHOL_NEGATIVE = 0, ALCOHOL_NEUTRAL = 1, ALCOHOL_POSITIVE = 2};
    enum LogLevel {none = 2, debug = 0, verbose = 1};
    static const int NONE;
    static const int INTERSTITIAL;
    static const int SKIPPABLE_VIDEO;
    static const int BANNER;
    static const int BANNER_BOTTOM;
    static const int BANNER_TOP;
    static const int REWARDED_VIDEO;
    static const int NON_SKIPPABLE_VIDEO;

    static void initialize (const QString& appKey, const int& adType);
    static bool show (const int& adType);
    static bool show (const int& adType, const QString& placement);
    static void hide (const int& adType);
    static void setTesting (const bool& flag);
    static void setLogLevel (const LogLevel& level);
    static bool isLoaded (const int& adType);
    static bool isPrecache (const int& adType);
    static void cache (const int& adType);
    static void setAutoCache (const int& adType, const bool& flag);
    static void setOnLoadedTriggerBoth (const int& adType, const bool& flag);
    static void setInterstitialCallback (InterstitialCallbacks* callback);
    static void setBannerCallback (BannerCallbacks* callbacks);
    static void setSkippableVideoCallback (SkippableVideoCallbacks* callbacks);
    static void setRewardedVideoCallback (RewardedVideoCallbacks* callbacks);
    static void disableNetwork (const QString& network);
    static void disableNetwork (const QString& network, const int& adType);
    static void disableLocationPermissionCheck();
    static void trackInAppPurchase (const QString& currencyCode, const int& amount);

    static void setNonSkippableVideoCallback (NonSkippableVideoCallbacks* callbacks);
    static void setAge (const int& age);
    static void setBirthday (const QString& bDay);
    static void setEmail (const QString& email);
    static void setGender (const Gender& gender);
    static void setInterests (const QString& interests);
    static void setOccupation (const Occupation& occupation);
    static void setRelation (const Relation& relation);
    static void setAlcohol (const Alcohol& alcohol);
    static void setSmoking (const Smoking& smoking);
    static void setUserId (const QString& userId);
    static void confirm (const int& adType);
    static void disableWriteExternalStoragePermissionCheck();
    static void requestAndroidMPermissions (/*callback*/);
    static void set728x90Banners (const bool& flag);
    static void setBannerAnimation (const bool& flag);
    static void setSmartBanners (const bool& flag);
    static void setCustomRule (const QString& name, const double& value);
    static void setCustomRule (const QString& name, const int& value);
    static void setCustomRule (const QString& name, const bool& value);
    static void setCustomRule (const QString& name, const QString& value);

private:
    static AppodealInterface* appodeal;
    static AppodealInterface* getInstance();
};

#endif // APPODEALADS_H
