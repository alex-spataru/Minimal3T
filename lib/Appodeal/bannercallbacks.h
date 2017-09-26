#ifndef BANNERCALLBACKS_H
#define BANNERCALLBACKS_H


class BannerCallbacks
{
public:
    virtual void onBannerLoaded (int height, bool isPrecache) = 0;
    virtual void onBannerFailedToLoad() = 0;
    virtual void onBannerShown() = 0;
    virtual void onBannerClicked() = 0;
};

#endif // BANNERCALLBACKS_H
