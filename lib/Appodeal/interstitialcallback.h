#ifndef INTERSTITIALCALLBACK
#define INTERSTITIALCALLBACK

class InterstitialCallback
{
public:
    InterstitialCallback ();
    //virtual ~Appodeal();
    static void onInterstitialLoaded (JNIEnv*, jobject);

    //private:
    //    QAndroidJniObject* m_Activity;
};

#endif // INTERSTITIALCALLBACK

