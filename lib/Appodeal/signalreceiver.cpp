#include "signalreceiver.h"


SignalReceiver::SignalReceiver(): nonSkippableCallbacks (NULL), bannerCallbacks (NULL),
    interstitialCallbacks (NULL), rewardedVideoCallbacks (NULL), skippableVideoCallbacks (NULL) {}

SignalReceiver::~SignalReceiver() {}
void SignalReceiver::setNonSkippableCallback (NonSkippableVideoCallbacks* callback)
{
    nonSkippableCallbacks = callback;
}

void SignalReceiver::setBannerCallback (BannerCallbacks* callback)
{
    bannerCallbacks = callback;
}

void SignalReceiver::setInterstitialCallback (InterstitialCallbacks* callback)
{
    interstitialCallbacks = callback;
}

void SignalReceiver::setRewardedVideoCallback (RewardedVideoCallbacks* callback)
{
    rewardedVideoCallbacks = callback;
}

void SignalReceiver::setSkippableVideoCallback (SkippableVideoCallbacks* callback)
{
    skippableVideoCallbacks = callback;
}

void SignalReceiver::onNonSkippableVideoLoaded()
{
    if (nonSkippableCallbacks)
        nonSkippableCallbacks->onNonSkippableVideoLoaded();
}

void SignalReceiver::onNonSkippableVideoFailedToLoad()
{
    if (nonSkippableCallbacks)
        nonSkippableCallbacks->onNonSkippableVideoFailedToLoad();
}

void SignalReceiver::onNonSkippableVideoShown()
{
    if (nonSkippableCallbacks)
        nonSkippableCallbacks->onNonSkippableVideoShown();
}

void SignalReceiver::onNonSkippableVideoFinished()
{
    if (nonSkippableCallbacks)
        nonSkippableCallbacks->onNonSkippableVideoFinished();
}

void SignalReceiver::onNonSkippableVideoClosed (bool isFinished)
{
    if (nonSkippableCallbacks)
        nonSkippableCallbacks->onNonSkippableVideoClosed (isFinished);
}

void SignalReceiver::onBannerLoaded (int height, bool isPrecache)
{
    if (bannerCallbacks)
        bannerCallbacks->onBannerLoaded (height, isPrecache);
}

void SignalReceiver::onBannerFailedToLoad()
{
    if (bannerCallbacks)
        bannerCallbacks->onBannerFailedToLoad();
}

void SignalReceiver::onBannerShown()
{
    if (bannerCallbacks)
        bannerCallbacks->onBannerShown();
}

void SignalReceiver::onBannerClicked()
{
    if (bannerCallbacks)
        bannerCallbacks->onBannerClicked();
}

void SignalReceiver::onInterstitialLoaded (bool isPrecache)
{
    if (interstitialCallbacks)
        interstitialCallbacks->onInterstitialLoaded (isPrecache);
}
void SignalReceiver::onInterstitialFailedToLoad ()
{
    if (interstitialCallbacks)
        interstitialCallbacks->onInterstitialFailedToLoad();
}
void SignalReceiver::onInterstitialShown()
{
    if (interstitialCallbacks)
        interstitialCallbacks->onInterstitialShown();
}
void SignalReceiver::onInterstitialClicked()
{
    if (interstitialCallbacks)
        interstitialCallbacks->onInterstitialClicked();
}
void SignalReceiver::onInterstitialClosed()
{
    if (interstitialCallbacks)
        interstitialCallbacks->onInterstitialClosed();
}

void SignalReceiver::onRewardedVideoLoaded ()
{
    if (rewardedVideoCallbacks)
        rewardedVideoCallbacks->onRewardedVideoLoaded();
}

void SignalReceiver::onRewardedVideoFailedToLoad ()
{
    if (rewardedVideoCallbacks)
        rewardedVideoCallbacks->onRewardedVideoFailedToLoad();
}
void SignalReceiver::onRewardedVideoShown ()
{
    if (rewardedVideoCallbacks)
        rewardedVideoCallbacks->onRewardedVideoShown();
}
void SignalReceiver::onRewardedVideoFinished (int value, QString currency)
{
    if (rewardedVideoCallbacks)
        rewardedVideoCallbacks->onRewardedVideoFinished (value, currency);
}
void SignalReceiver::onRewardedVideoClosed (bool isFinished)
{
    if (rewardedVideoCallbacks)
        rewardedVideoCallbacks->onRewardedVideoClosed (isFinished);
}

void SignalReceiver::onSkippableVideoLoaded()
{
    if (skippableVideoCallbacks)
        skippableVideoCallbacks->onSkippableVideoLoaded();
}
void SignalReceiver::onSkippableVideoFailedToLoad()
{
    if (skippableVideoCallbacks)
        skippableVideoCallbacks->onSkippableVideoFailedToLoad();
}
void SignalReceiver::onSkippableVideoShown()
{
    if (skippableVideoCallbacks)
        skippableVideoCallbacks->onSkippableVideoShown();
}
void SignalReceiver::onSkippableVideoFinished()
{
    if (skippableVideoCallbacks)
        skippableVideoCallbacks->onSkippableVideoFinished();
}
void SignalReceiver::onSkippableVideoClosed (bool isFinished)
{
    if (skippableVideoCallbacks)
        skippableVideoCallbacks->onSkippableVideoClosed (isFinished);
}
