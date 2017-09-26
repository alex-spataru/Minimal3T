#ifdef ANDROID

#include "appodealandroid.h"
#include "QAndroidJniObject"
#include <qpa/qplatformnativeinterface.h>
#include <QApplication>
#include <QDebug>
#include <jni.h>

SignalReceiver* AppodealAndroid::signalReceiver = 0;

AppodealAndroid::AppodealAndroid(): m_Activity (0)
{
    if (!m_Activity) {
        QPlatformNativeInterface* interface = QApplication::platformNativeInterface();
        jobject activity = (jobject)interface->nativeResourceForIntegration ("QtActivity");
        if (activity)
            m_Activity = new QAndroidJniObject (activity);
    }
    signalReceiver = new SignalReceiver;
    //
}
AppodealAndroid::~AppodealAndroid()
{
    if (m_Activity) {
        delete m_Activity;
        m_Activity = 0;
        delete signalReceiver;
        signalReceiver = 0;
    }
}

void AppodealAndroid::initialize (const QString& appKey, const int& adType)
{
    QAndroidJniObject appKeyS = QAndroidJniObject::fromString (appKey);
    m_Activity->callMethod<void> ("initialize", "(Ljava/lang/String;I)V",  appKeyS.object<jstring>(),
                                  adType);
}

bool AppodealAndroid::show (const int& adType)
{
    return m_Activity->callMethod<jboolean> ("show", "(I)Z", adType);
}

bool AppodealAndroid::show (const int& adType, const QString& placement)
{
    QAndroidJniObject placementS = QAndroidJniObject::fromString (placement);
    return m_Activity->callMethod<jboolean> ("show", "(ILjava/lang/String;)Z", adType,
                                             placementS.object<jstring>());
}

void AppodealAndroid::hide (const int& adType)
{
    m_Activity->callMethod<void> ("hide", "(I)V", adType);
}

void AppodealAndroid::setTesting (const bool& flag)
{
    m_Activity->callMethod<void> ("setTesting", "(Z)V", flag);
}

void AppodealAndroid::setLogLevel (const int& level)
{
    m_Activity->callMethod<void> ("setLogLevel", "(I)V", level);
}

bool AppodealAndroid::isLoaded (const int& adType)
{
    return m_Activity->callMethod<jboolean> ("isLoaded", "(I)Z", adType);
}

bool AppodealAndroid::isPrecache (const int& adType)
{
    return m_Activity->callMethod<jboolean> ("isPrecache", "(I)Z", adType);
}

void AppodealAndroid::cache (const int& adType)
{
    qDebug ("Android.cache");
    m_Activity->callMethod<void> ("cache", "(I)V", adType);
}

void AppodealAndroid::setAutoCache (const int& adType, const bool& flag)
{
    m_Activity->callMethod<void> ("setAutoCache", "(IZ)V", adType, flag);
}

void AppodealAndroid::setOnLoadedTriggerBoth (const int& adType, const bool& flag)
{
    m_Activity->callMethod<void> ("setOnLoadedTriggerBoth", "(IZ)V", adType, flag);
}
void AppodealAndroid::setInterstitialCallback (InterstitialCallbacks* callback)
{
    signalReceiver->setInterstitialCallback (callback);
    m_Activity->callMethod<void> ("setInterstitialCallback", "()V");
}

void AppodealAndroid::setBannerCallback (BannerCallbacks* callbacks)
{
    signalReceiver->setBannerCallback (callbacks);
    m_Activity->callMethod<void> ("setBannerCallback", "()V");
}

void AppodealAndroid::setSkippableVideoCallback (SkippableVideoCallbacks* callbacks)
{
    signalReceiver->setSkippableVideoCallback (callbacks);
    m_Activity->callMethod<void> ("setSkippableVideoCallback", "()V");
}

void AppodealAndroid::setRewardedVideoCallback (RewardedVideoCallbacks* callbacks)
{
    signalReceiver->setRewardedVideoCallback (callbacks);
    m_Activity->callMethod<void> ("setRewardedVideoCallback", "()V");
}


void AppodealAndroid::disableNetwork (const QString& network)
{
    QAndroidJniObject networkS = QAndroidJniObject::fromString (network);
    m_Activity->callMethod<void> ("disableNetwork", "(Ljava/lang/String)V",
                                  networkS.object<jstring>());
}

void AppodealAndroid::disableNetwork (const QString& network, const int& adType)
{
    QAndroidJniObject networkS = QAndroidJniObject::fromString (network);
    m_Activity->callMethod<void> ("disableNetwork", "(Ljava/lang/String;I)V",
                                  networkS.object<jstring>(), adType);
}

void AppodealAndroid::disableLocationPermissionCheck()
{
    m_Activity->callMethod<void> ("disableLocationPermissionCheck", "()V");
}

void AppodealAndroid::trackInAppPurchase (const QString& currencyCode, const int& amount)
{
    QAndroidJniObject currencyCodeS = QAndroidJniObject::fromString (currencyCode);
    m_Activity->callMethod<void> ("trackInAppPurchase", "(Ljava/lang/String;I)V",
                                  currencyCodeS.object<jstring>(), amount);
}

void AppodealAndroid::setNonSkippableVideoCallback (NonSkippableVideoCallbacks* callbacks)
{
    signalReceiver->setNonSkippableCallback (callbacks);
    m_Activity->callMethod<void> ("setNonSkippableVideoCallback", "()V");

}
void AppodealAndroid::setAge (const int& age)
{
    m_Activity->callMethod<void> ("setAge", "(I)V", age);
}
void AppodealAndroid::setBirthday (const QString& bDay)
{
    QAndroidJniObject bDayS = QAndroidJniObject::fromString (bDay);
    m_Activity->callMethod<void> ("setBirthday", "(Ljava/lang/String;)V", bDayS.object<jstring>());
}
void AppodealAndroid::setEmail (const QString& email)
{
    QAndroidJniObject emailS = QAndroidJniObject::fromString (email);
    m_Activity->callMethod<void> ("setEmail", "(Ljava/lang/String;)V", emailS.object<jstring>());
}
void AppodealAndroid::setGender (const int& gender)
{
    m_Activity->callMethod<void> ("setGender", "(I)V", gender);
}
void AppodealAndroid::setInterests (const QString& interests)
{
    QAndroidJniObject interestsS = QAndroidJniObject::fromString (interests);
    m_Activity->callMethod<void> ("setInterests", "(Ljava/lang/String;)V",
                                  interestsS.object<jstring>());
}
void AppodealAndroid::setOccupation (const int& occupation)
{
    m_Activity->callMethod<void> ("setOccupation", "(I)V", occupation);
}
void AppodealAndroid::setRelation (const int& relation)
{
    m_Activity->callMethod<void> ("setRelation", "(I)V", relation);
}
void  AppodealAndroid::setAlcohol (const int& alcohol)
{
    m_Activity->callMethod<void> ("setAlcohol", "(I)V", alcohol);
}
void AppodealAndroid::setSmoking (const int& smoking)
{
    m_Activity->callMethod<void> ("setSmoking", "(I)V", smoking);
}
void AppodealAndroid::setUserId (const QString& userId)
{
    QAndroidJniObject userIdS = QAndroidJniObject::fromString (userId);
    m_Activity->callMethod<void> ("setUserId", "(Ljava/lang/String;)V", userIdS.object<jstring>());
}
void AppodealAndroid::confirm (const int& adType)
{
    m_Activity->callMethod<void> ("confirm", "(I)V", adType);
}
void AppodealAndroid::disableWriteExternalStoragePermissionCheck()
{
    m_Activity->callMethod<void> ("disableWriteExternalStoragePermissionCheck", "(V)V");
}
void AppodealAndroid::requestAndroidMPermissions (/*callback*/)
{
    m_Activity->callMethod<void> ("requestAndroidMPermissions", "(V)V");
}
void AppodealAndroid::set728x90Banners (const bool& flag)
{
    m_Activity->callMethod<void> ("set728x90Banners", "(Z)V", flag);
}
void AppodealAndroid::setBannerAnimation (const bool& flag)
{
    m_Activity->callMethod<void> ("setBannerAnimation", "(Z)V", flag);
}
void AppodealAndroid::setSmartBanners (const bool& flag)
{
    m_Activity->callMethod<void> ("setSmartBanners", "(Z)V", flag);
}
void AppodealAndroid::setCustomRule (const QString& name, const double& value)
{
    QAndroidJniObject nameS = QAndroidJniObject::fromString (name);
    m_Activity->callMethod<void> ("setCustomRule", "(Ljava/lang/String;D)V", nameS.object<jstring>(),
                                  value);
}
void AppodealAndroid::setCustomRule (const QString& name, const int& value)
{
    QAndroidJniObject nameS = QAndroidJniObject::fromString (name);
    m_Activity->callMethod<void> ("setCustomRule", "(Ljava/lang/String;I)V", nameS.object<jstring>(),
                                  value);
}
void AppodealAndroid::setCustomRule (const QString& name, const bool& value)
{
    QAndroidJniObject nameS = QAndroidJniObject::fromString (name);
    m_Activity->callMethod<void> ("setCustomRule", "(Ljava/lang/String;Z)V", nameS.object<jstring>(),
                                  value);
}
void AppodealAndroid::setCustomRule (const QString& name, const QString& value)
{
    QAndroidJniObject nameS = QAndroidJniObject::fromString (name);
    QAndroidJniObject valueS = QAndroidJniObject::fromString (value);
    m_Activity->callMethod<void> ("setCustomRule", "(Ljava/lang/String;Ljava/lang/String;)V",
                                  nameS.object<jstring>(), valueS.object<jstring>());
}

//Callbacks for interaction with java
void AppodealAndroid::onNonSkippableVideoLoaded()
{
    QMetaObject::invokeMethod (signalReceiver, "onNonSkippableVideoLoaded", Qt::QueuedConnection);
}
void AppodealAndroid::onNonSkippableVideoFailedToLoad()
{

    QMetaObject::invokeMethod (signalReceiver, "onNonSkippableVideoFailedToLoad", Qt::QueuedConnection);
}
void AppodealAndroid::onNonSkippableVideoShown()
{
    QMetaObject::invokeMethod (signalReceiver, "onNonSkippableVideoShown", Qt::QueuedConnection);
}
void AppodealAndroid::onNonSkippableVideoFinished()
{
    QMetaObject::invokeMethod (signalReceiver, "onNonSkippableVideoFinished", Qt::QueuedConnection);
}
void AppodealAndroid::onNonSkippableVideoClosed (JNIEnv*, jobject, jboolean isFinished)
{
    QMetaObject::invokeMethod (signalReceiver, "onNonSkippableVideoClosed", Qt::QueuedConnection,
                               Q_ARG (bool, (bool)isFinished));
}
void AppodealAndroid::onBannerLoaded (JNIEnv*, jobject, jint height, jboolean isPrecache)
{
    QMetaObject::invokeMethod (signalReceiver, "onBannerLoaded", Qt::QueuedConnection, Q_ARG (int,
                               (int)height), Q_ARG (bool, (bool)isPrecache));
}
void AppodealAndroid::onBannerFailedToLoad()
{
    QMetaObject::invokeMethod (signalReceiver, "onBannerFailedToLoad", Qt::QueuedConnection);
}
void AppodealAndroid::onBannerShown()
{
    QMetaObject::invokeMethod (signalReceiver, "onBannerShown", Qt::QueuedConnection);
}
void AppodealAndroid::onBannerClicked()
{
    QMetaObject::invokeMethod (signalReceiver, "onBannerClicked", Qt::QueuedConnection);
}

void AppodealAndroid::onInterstitialLoaded (JNIEnv*, jobject, jboolean isPrecache)
{
    QMetaObject::invokeMethod (signalReceiver, "onInterstitialLoaded", Qt::QueuedConnection,
                               Q_ARG (bool, (bool)isPrecache));
}
void AppodealAndroid::onInterstitialFailedToLoad ()
{
    QMetaObject::invokeMethod (signalReceiver, "onInterstitialFailedToLoad", Qt::QueuedConnection);
}
void AppodealAndroid::onInterstitialShown()
{
    QMetaObject::invokeMethod (signalReceiver, "onInterstitialShown", Qt::QueuedConnection);
}
void AppodealAndroid::onInterstitialClicked()
{
    QMetaObject::invokeMethod (signalReceiver, "onInterstitialClicked", Qt::QueuedConnection);
}
void AppodealAndroid::onInterstitialClosed()
{
    QMetaObject::invokeMethod (signalReceiver, "onInterstitialClosed", Qt::QueuedConnection);
}

void AppodealAndroid::onRewardedVideoLoaded ()
{
    QMetaObject::invokeMethod (signalReceiver, "onRewardedVideoLoaded", Qt::QueuedConnection);
}
void AppodealAndroid::onRewardedVideoFailedToLoad ()
{
    QMetaObject::invokeMethod (signalReceiver, "onRewardedVideoFailedToLoad", Qt::QueuedConnection);
}
void AppodealAndroid::onRewardedVideoShown ()
{
    QMetaObject::invokeMethod (signalReceiver, "onRewardedVideoShown", Qt::QueuedConnection);
}
void AppodealAndroid::onRewardedVideoFinished (JNIEnv* env, jobject, jint value, jstring currency)
{
    QMetaObject::invokeMethod (signalReceiver, "onRewardedVideoFinished", Qt::QueuedConnection,
                               Q_ARG (int, (int)value), Q_ARG (QString, QString (env->GetStringUTFChars (currency, NULL))));
}
void AppodealAndroid::onRewardedVideoClosed (JNIEnv*, jobject, jboolean isFinished)
{
    QMetaObject::invokeMethod (signalReceiver, "onRewardedVideoClosed", Qt::QueuedConnection,
                               Q_ARG (bool, (bool)isFinished));
}
void AppodealAndroid::onSkippableVideoLoaded()
{
    QMetaObject::invokeMethod (signalReceiver, "onSkippableVideoLoaded", Qt::QueuedConnection);
}
void AppodealAndroid::onSkippableVideoFailedToLoad()
{
    QMetaObject::invokeMethod (signalReceiver, "onSkippableVideoFailedToLoad", Qt::QueuedConnection);
}
void AppodealAndroid::onSkippableVideoShown()
{
    QMetaObject::invokeMethod (signalReceiver, "onSkippableVideoShown", Qt::QueuedConnection);
}
void AppodealAndroid::onSkippableVideoFinished()
{
    QMetaObject::invokeMethod (signalReceiver, "onSkippableVideoFinished", Qt::QueuedConnection);
}
void AppodealAndroid::onSkippableVideoClosed (JNIEnv*, jobject, jboolean  isFinished)
{
    QMetaObject::invokeMethod (signalReceiver, "onSkippableVideoClosed", Qt::QueuedConnection,
                               Q_ARG (bool, (bool)isFinished));
}

#endif
