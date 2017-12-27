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

import QtQuick 2.0
import QtQuick.Window 2.0
import com.dreamdev.QtAdMobBanner 1.0
import com.dreamdev.QtAdMobInterstitial 1.0

Item {
    id: ads
    property alias adsEnabled: ads.enabled

    //
    // Locate the banner when the custom properties are changed
    //
    onAdsEnabledChanged: {
        locateBanner()
        bannerAd.visible = adsEnabled
    }

    //
    // Shows the interstitial ad
    //
    function showInterstitialAd() {
        if (interstitialAd.isLoaded && adsEnabled)
            interstitialAd.visible = true
    }

    //
    // Locates the banner on the bottom of the screen
    //
    function locateBanner() {
        var w = bannerAd.width / DevicePixelRatio
        var h = bannerAd.height / DevicePixelRatio

        if (adsEnabled) {
            var sbHeight = Screen.height - Screen.desktopAvailableHeight
            bannerAd.x = (app.width - w) * DevicePixelRatio / 2
            bannerAd.y = (app.height - h - app.spacing + sbHeight + 1) * DevicePixelRatio
        }

        else {
            bannerAd.x = app.width * 2 * DevicePixelRatio
            bannerAd.y = app.height * 2 * DevicePixelRatio
        }
    }

    //
    // Update banner location when window size changes
    //
    Connections {
        target: app
        onWidthChanged: locateBanner()
        onHeightChanged: locateBanner()
    }

    //
    // Show ads
    //
    Component.onCompleted: {
        locateBanner()
        bannerAd.visible = adsEnabled
    }

    //
    // Banner ad
    //
    AdMobBanner {
        id: bannerAd
        onLoaded: locateBanner()
        Component.onCompleted: {
            visible = true
            unitId = BannerId
            size = AdMobBanner.Banner
        }
    }

    //
    // Interstitial ad
    //
    AdMobInterstitial {
        id: interstitialAd
        onClosed: interstitialAd.unitId = InterstitialId
        Component.onCompleted: interstitialAd.unitId = InterstitialId
    }
}
