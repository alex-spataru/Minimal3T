#ifdef ANDROID

#include <QString>
#include "appodealandroid.h"
#include "interstitialcallbacks.h"
#include "bannercallbacks.h"
#include "skippablevideocallbacks.h"
#include "nonskippablevideocallbacks.h"
#include "rewardedvideocallbacks.h"


JNIEXPORT jint JNI_OnLoad (JavaVM* vm, void*)
{
    JNINativeMethod methods[] = {
        {
            "onInterstitialLoaded",                              // const char* function name;
            "(Z)V",                                               // const char* function signature
            (void*) AppodealAndroid::onInterstitialLoaded        // function pointer
        },
        {
            "onInterstitialFailedToLoad",
            "()V",
            (void*) AppodealAndroid::onInterstitialFailedToLoad
        },
        {
            "onInterstitialShown",
            "()V",
            (void*) AppodealAndroid::onInterstitialShown
        },
        {
            "onInterstitialClicked",
            "()V",
            (void*) AppodealAndroid::onInterstitialClicked
        },
        {
            "onInterstitialClosed",
            "()V",
            (void*) AppodealAndroid::onInterstitialClosed
        },
        {
            "onBannerLoaded",
            "(IZ)V",
            (void*) AppodealAndroid::onBannerLoaded
        },
        {
            "onBannerFailedToLoad",
            "()V",
            (void*) AppodealAndroid::onBannerFailedToLoad
        },
        {
            "onBannerShown",
            "()V",
            (void*) AppodealAndroid::onBannerShown
        },
        {
            "onBannerClicked",
            "()V",
            (void*) AppodealAndroid::onBannerClicked
        },
        {
            "onRewardedVideoLoaded",
            "()V",
            (void*) AppodealAndroid::onRewardedVideoLoaded
        },
        {
            "onRewardedVideoFailedToLoad",
            "()V",
            (void*) AppodealAndroid::onRewardedVideoFailedToLoad
        },
        {
            "onRewardedVideoShown",
            "()V",
            (void*) AppodealAndroid::onRewardedVideoShown
        },
        {
            "onRewardedVideoFinished",
            "(ILjava/lang/String;)V",
            (void*) AppodealAndroid::onRewardedVideoFinished
        },
        {
            "onRewardedVideoClosed",
            "(Z)V",
            (void*) AppodealAndroid::onRewardedVideoClosed
        },
        {
            "onNonSkippableVideoLoaded",
            "()V",
            (void*) AppodealAndroid::onNonSkippableVideoLoaded
        },
        {
            "onNonSkippableVideoFailedToLoad",
            "()V",
            (void*) AppodealAndroid::onNonSkippableVideoFailedToLoad
        },
        {
            "onNonSkippableVideoShown",
            "()V",
            (void*) AppodealAndroid::onNonSkippableVideoShown
        },
        {
            "onNonSkippableVideoFinished",
            "()V",
            (void*) AppodealAndroid::onNonSkippableVideoFinished
        },
        {
            "onNonSkippableVideoClosed",
            "(Z)V",
            (void*) AppodealAndroid::onNonSkippableVideoClosed
        },
        {
            "onSkippableVideoLoaded",
            "()V",
            (void*) AppodealAndroid::onSkippableVideoLoaded
        },
        {
            "onSkippableVideoFailedToLoad",
            "()V",
            (void*) AppodealAndroid::onSkippableVideoFailedToLoad
        },
        {
            "onSkippableVideoShown",
            "()V",
            (void*) AppodealAndroid::onSkippableVideoShown
        },
        {
            "onSkippableVideoFinished",
            "()V",
            (void*) AppodealAndroid::onSkippableVideoFinished
        },
        {
            "onSkippableVideoClosed",
            "(Z)V",
            (void*) AppodealAndroid::onSkippableVideoClosed
        }

    };

    JNIEnv* env;
    // get the JNIEnv pointer.
    if (vm->GetEnv (reinterpret_cast<void**> (&env), JNI_VERSION_1_6) != JNI_OK)
        return JNI_ERR;
    qDebug ("Got enviroment");

    // search for Java class which declares the native methods
    jclass javaClass = env->FindClass (PACKAGE_NAME);
    if (!javaClass)
        return JNI_ERR;

    // register our native methods
    if (env->RegisterNatives (javaClass, methods, sizeof (methods) / sizeof (methods[0])) < 0)
        return JNI_ERR;
    return JNI_VERSION_1_6;
}

#endif
