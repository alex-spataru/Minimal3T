#include "appodealads.h"

#include "appodealandroid.h"
#include "appodealunsupported.h"

AppodealInterface* AppodealAds::appodeal = 0;

#if (__ANDROID_API__ >= 9)
    const int AppodealAds::NONE                = 0;
    const int AppodealAds::INTERSTITIAL        = 1;
    const int AppodealAds::SKIPPABLE_VIDEO     = 2;
    const int AppodealAds::BANNER              = 4;
    const int AppodealAds::BANNER_BOTTOM       = 8;
    const int AppodealAds::BANNER_TOP          = 16;
    const int AppodealAds::REWARDED_VIDEO      = 128;
    const int AppodealAds::NON_SKIPPABLE_VIDEO = 128;
#else
    const int AppodealAds::NONE                = 0;
    const int AppodealAds::INTERSTITIAL        = 1;
    const int AppodealAds::SKIPPABLE_VIDEO     = 2;
    const int AppodealAds::BANNER              = 4;
    const int AppodealAds::BANNER_BOTTOM       = 8;
    const int AppodealAds::BANNER_TOP          = 16;
    const int AppodealAds::REWARDED_VIDEO      = 128;
    const int AppodealAds::NON_SKIPPABLE_VIDEO = 256;
#endif

AppodealInterface* AppodealAds::getInstance()
{
    if (!AppodealAds::appodeal) {
#if (__ANDROID_API__ >= 9)
        appodeal = new AppodealAndroid();
#elif (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
        appodeal = new AppodealiOS();
#else
        appodeal = new AppodealUnsupported();
#endif
    }
    return AppodealAds::appodeal;
}

void AppodealAds::initialize (const QString& appKey, const int& adType)
{
    AppodealAds::getInstance()->initialize (appKey, adType);
}

bool AppodealAds::show (const int& adType)
{
    return AppodealAds::getInstance()->show (adType);
}

bool AppodealAds::show (const int& adType, const QString& placement)
{
    return AppodealAds::getInstance()->show (adType, placement);
}

void AppodealAds::hide (const int& adType)
{
    AppodealAds::getInstance()->hide (adType);
}
void AppodealAds::setTesting (const bool& flag)
{
    AppodealAds::getInstance()->setTesting (flag);
}
void AppodealAds::setLogLevel (const LogLevel& level)
{
    AppodealAds::getInstance()->setLogLevel (level);
}
bool AppodealAds::isLoaded (const int& adType)
{
    return AppodealAds::getInstance()->isLoaded (adType);
}
bool AppodealAds::isPrecache (const int& adType)
{
    return AppodealAds::getInstance()->isPrecache (adType);
}
void AppodealAds::cache (const int& adType)
{
    AppodealAds::getInstance()->cache (adType);
}
void AppodealAds::setAutoCache (const int& adType, const bool& flag)
{
    AppodealAds::getInstance()->setAutoCache (adType, flag);
}
void AppodealAds::setOnLoadedTriggerBoth (const int& adType, const bool& flag)
{
    AppodealAds::getInstance()->setOnLoadedTriggerBoth (adType, flag);
}
void AppodealAds::setInterstitialCallback (InterstitialCallbacks* callback)
{
    AppodealAds::getInstance()->setInterstitialCallback (callback);
}
void AppodealAds::setSkippableVideoCallback (SkippableVideoCallbacks* callbacks)
{
    AppodealAds::getInstance()->setSkippableVideoCallback (callbacks);
}
void AppodealAds::setBannerCallback (BannerCallbacks* callbacks)
{
    AppodealAds::getInstance()->setBannerCallback (callbacks);
}
void AppodealAds::setRewardedVideoCallback (RewardedVideoCallbacks* callbacks)
{
    AppodealAds::getInstance()->setRewardedVideoCallback (callbacks);
}
void AppodealAds::disableNetwork (const QString& network)
{
    AppodealAds::getInstance()->disableNetwork (network);
}
void AppodealAds::disableNetwork (const QString& network, const int& adType)
{
    AppodealAds::getInstance()->disableNetwork (network, adType);
}
void AppodealAds::disableLocationPermissionCheck()
{
    AppodealAds::getInstance()->disableLocationPermissionCheck();
}
void AppodealAds::trackInAppPurchase (const QString& currencyCode, const int& amount)
{
    AppodealAds::getInstance()->trackInAppPurchase (currencyCode, amount);
}

void AppodealAds::setNonSkippableVideoCallback (NonSkippableVideoCallbacks* callbacks)
{
    AppodealAds::getInstance()->setNonSkippableVideoCallback (callbacks);
}

void AppodealAds::setAge (const int& age)
{
    AppodealAds::getInstance()->setAge (age);
}

void AppodealAds::setBirthday (const QString& bDay)
{
    AppodealAds::getInstance()->setBirthday (bDay);
}

void AppodealAds::setEmail (const QString& email)
{
    AppodealAds::getInstance()->setEmail (email);
}

void AppodealAds::setGender (const Gender& gender)
{
    AppodealAds::getInstance()->setGender (gender);
}

void AppodealAds::setInterests (const QString& interests)
{
    AppodealAds::getInstance()->setInterests (interests);
}

void AppodealAds::setOccupation (const Occupation& occupation)
{
    AppodealAds::getInstance()->setOccupation (occupation);
}

void AppodealAds::setRelation (const Relation& relation)
{
    AppodealAds::getInstance()->setRelation (relation);
}

void AppodealAds::setAlcohol (const Alcohol& alcohol)
{
    AppodealAds::getInstance()->setAlcohol (alcohol);
}

void AppodealAds::setSmoking (const Smoking& smoking)
{
    AppodealAds::getInstance()->setSmoking (smoking);
}

void AppodealAds::setUserId (const QString& userId)
{
    AppodealAds::getInstance()->setUserId (userId);
}

void AppodealAds::confirm (const int& adType)
{
    AppodealAds::getInstance()->confirm (adType);
}

void AppodealAds::disableWriteExternalStoragePermissionCheck()
{
    AppodealAds::getInstance()->disableWriteExternalStoragePermissionCheck();
}

void AppodealAds::requestAndroidMPermissions (/*callback*/)
{
    AppodealAds::getInstance()->requestAndroidMPermissions();
}

void AppodealAds::set728x90Banners (const bool& flag)
{
    AppodealAds::getInstance()->set728x90Banners (flag);
}

void AppodealAds::setBannerAnimation (const bool& flag)
{
    AppodealAds::getInstance()->setBannerAnimation (flag);
}

void AppodealAds::setSmartBanners (const bool& flag)
{
    AppodealAds::getInstance()->setSmartBanners (flag);
}

void AppodealAds::setCustomRule (const QString& name, const double& value)
{
    AppodealAds::getInstance()->setCustomRule (name, value);
}

void AppodealAds::setCustomRule (const QString& name, const int& value)
{
    AppodealAds::getInstance()->setCustomRule (name, value);
}

void AppodealAds::setCustomRule (const QString& name, const bool& value)
{
    AppodealAds::getInstance()->setCustomRule (name, value);
}

void AppodealAds::setCustomRule (const QString& name, const QString& value)
{
    AppodealAds::getInstance()->setCustomRule (name, value);
}
