/*
 * Copyright (c) 2017 Alex Spataru <alex_spataru@outlook.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#ifndef _ADS_H
#define _ADS_H

#include <QObject>
#include "appodealads.h"

#ifdef QT_QML_LIB
    #include <QtQml>
#endif

class AdEngine : public QObject, public BannerCallbacks
{
    Q_OBJECT
#ifdef QT_QML_LIB
    Q_PROPERTY (bool adsEnabled
                READ adsEnabled
                WRITE setAdsEnabled
                NOTIFY adsEnabledChanged)
#endif

public:
    static void DeclareQML()
    {
#ifdef QT_QML_LIB
        qmlRegisterType<AdEngine> ("AdEngine", 1, 0, "Ads");
#endif
    }

signals:
    void bannerLoaded();
    void adsEnabledChanged();
    void interstitialLoaded();

public:
    explicit AdEngine();

    QString appKey() const;
    bool adsEnabled() const;

    void onBannerShown() {}
    void onBannerClicked() {}
    void onBannerFailedToLoad() {}
    void onBannerLoaded (int height, bool isPrecache);

public slots:
    void showInterstitial();
    void init (const QString& appKey);
    void setAdsEnabled (const bool enabled);

private slots:
    void displayBanner();
    void initializeAds();

private:
    QString m_appKey;
    bool m_adsEnabled;
};

#endif

