#ifndef REWARDEDVIDEOCALLBACKS_H
#define REWARDEDVIDEOCALLBACKS_H

#include <QString>

class RewardedVideoCallbacks
{
public:
    virtual void onRewardedVideoLoaded () = 0;
    virtual void onRewardedVideoFailedToLoad () = 0;
    virtual void onRewardedVideoShown () = 0;
    virtual void onRewardedVideoFinished (int i, QString s) = 0;
    virtual void onRewardedVideoClosed (bool isFinished) = 0;
};

#endif // REWARDEDVIDEOCALLBACKS_H
