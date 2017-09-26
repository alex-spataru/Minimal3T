#ifndef SKIPPABLEVIDEOCALLBACKS_H
#define SKIPPABLEVIDEOCALLBACKS_H

class SkippableVideoCallbacks
{
public:
    virtual void onSkippableVideoLoaded() = 0;
    virtual void onSkippableVideoFailedToLoad() = 0;
    virtual void onSkippableVideoShown() = 0;
    virtual void onSkippableVideoFinished() = 0;
    virtual void onSkippableVideoClosed (bool isFinished) = 0;
};

#endif // SKIPPABLEVIDEOCALLBACKS_H
