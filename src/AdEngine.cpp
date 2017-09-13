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

#include "AdEngine.h"
#include "appodealads.h"

AdEngine::AdEngine() : m_adsEnabled (false)
{
    connect (this, SIGNAL (adsEnabledChanged()), this, SLOT (displayBanner()));
}

QString AdEngine::appKey() const
{
    return m_appKey;
}

bool AdEngine::adsEnabled() const
{
    return m_adsEnabled;
}

void AdEngine::onBannerLoaded (int height, bool isPrecache)
{
    (void) height;
    (void) isPrecache;

    displayBanner();
}

void AdEngine::showInterstial()
{
    if (adsEnabled())
        if (AppodealAds::isLoaded (AppodealAds::INTERSTITIAL))
            AppodealAds::show (AppodealAds::INTERSTITIAL);
}

void AdEngine::init (const QString& appKey)
{
    if (m_appKey.isEmpty()) {
        m_appKey = appKey;
        initializeAds();
    }
}

void AdEngine::setAdsEnabled (const bool enabled)
{
    if (adsEnabled() != enabled) {
        m_adsEnabled = enabled;
        emit adsEnabledChanged();
    }
}

void AdEngine::displayBanner()
{
    if (adsEnabled())
        AppodealAds::show (AppodealAds::BANNER_BOTTOM);

    else
        AppodealAds::hide (AppodealAds::BANNER_BOTTOM);
}

void AdEngine::initializeAds()
{
    AppodealAds::disableLocationPermissionCheck();
    AppodealAds::initialize (m_appKey,
                             AppodealAds::INTERSTITIAL |
                             AppodealAds::BANNER_BOTTOM);

#ifdef ENABLE_REAL_ADS
    AppodealAds::setTesting (false);
#else
    AppodealAds::setTesting (true);
#endif

    AppodealAds::setSmartBanners (true);
    AppodealAds::setBannerCallback (this);
    AppodealAds::setAlcohol (AppodealAds::ALCOHOL_NEGATIVE);
    AppodealAds::setSmoking (AppodealAds::SMOKING_NEGATIVE);
}
