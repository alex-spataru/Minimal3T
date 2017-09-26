#ifndef NONSKIPPABLEVIDEOCALLBACKS_H
#define NONSKIPPABLEVIDEOCALLBACKS_H

class NonSkippableVideoCallbacks
{
public:
    virtual void onNonSkippableVideoLoaded() = 0;
    virtual void onNonSkippableVideoFailedToLoad() = 0;
    virtual void onNonSkippableVideoShown() = 0;
    virtual void onNonSkippableVideoFinished() = 0;
    virtual void onNonSkippableVideoClosed (bool isFinished) = 0;
};

#endif // NONSKIPPABLEVIDEOCALLBACKS_H
