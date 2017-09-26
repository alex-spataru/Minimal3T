#ifndef INTERSTITIALCALLBACKS_H
#define INTERSTITIALCALLBACKS_H

class InterstitialCallbacks
{
public:
    virtual void onInterstitialLoaded (bool isPrecache) = 0;
    virtual void onInterstitialFailedToLoad () = 0;
    virtual void onInterstitialShown() = 0;
    virtual void onInterstitialClicked() = 0;
    virtual void onInterstitialClosed() = 0;
};

#endif // INTERSTITIALCALLBACKS_H
