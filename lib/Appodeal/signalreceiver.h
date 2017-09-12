#ifndef SIGNALRECEIVER_H
#define SIGNALRECEIVER_H

#include <QObject>
#include "nonskippablevideocallbacks.h"
#include "bannercallbacks.h"
#include "interstitialcallbacks.h"
#include "rewardedvideocallbacks.h"
#include "skippablevideocallbacks.h"

class SignalReceiver: public QObject, public NonSkippableVideoCallbacks, public BannerCallbacks,
    public InterstitialCallbacks, public RewardedVideoCallbacks, public SkippableVideoCallbacks
{
    Q_OBJECT
public:
    SignalReceiver();
    ~SignalReceiver();
    void setNonSkippableCallback (NonSkippableVideoCallbacks* callback);
    void setBannerCallback (BannerCallbacks* callback);
    void setInterstitialCallback (InterstitialCallbacks* callback);
    void setRewardedVideoCallback (RewardedVideoCallbacks* callback);
    void setSkippableVideoCallback (SkippableVideoCallbacks* callback);
public slots:
    virtual void onNonSkippableVideoLoaded();
    virtual void onNonSkippableVideoFailedToLoad();
    virtual void onNonSkippableVideoShown();
    virtual void onNonSkippableVideoFinished();
    virtual void onNonSkippableVideoClosed (bool isFinished);
    virtual void onBannerLoaded (int height, bool isPrecache);
    virtual void onBannerFailedToLoad();
    virtual void onBannerShown();
    virtual void onBannerClicked();
    virtual void onInterstitialLoaded (bool isPrecache);
    virtual void onInterstitialFailedToLoad ();
    virtual void onInterstitialShown();
    virtual void onInterstitialClicked();
    virtual void onInterstitialClosed();
    virtual void onRewardedVideoLoaded ();
    virtual void onRewardedVideoFailedToLoad ();
    virtual void onRewardedVideoShown ();
    virtual void onRewardedVideoFinished (int value, QString currency);
    virtual void onRewardedVideoClosed (bool isFinished);
    virtual void onSkippableVideoLoaded();
    virtual void onSkippableVideoFailedToLoad();
    virtual void onSkippableVideoShown();
    virtual void onSkippableVideoFinished();
    virtual void onSkippableVideoClosed (bool isFinished);

private:
    NonSkippableVideoCallbacks* nonSkippableCallbacks;
    BannerCallbacks* bannerCallbacks;
    InterstitialCallbacks* interstitialCallbacks;
    RewardedVideoCallbacks* rewardedVideoCallbacks;
    SkippableVideoCallbacks* skippableVideoCallbacks;
};

#endif // SIGNALRECEIVER_H
