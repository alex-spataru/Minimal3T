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
import QtPurchasing 1.0
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

import Qt.labs.settings 1.0

Item {
    id: ads
    property bool adsEnabled: false
    property bool removeAdsBought: false
    readonly property bool showAds: adsEnabled && !removeAdsBought

    //
    // Save ad-settings (used by the purchases)
    //
    Settings {
        category: "ads"
        property alias enabled: ads.adsEnabled
        property alias bought:  ads.removeAdsBought
    }

    //
    // Shows or hides the ads
    //
    Component.onCompleted: {
        /* Enable ads if needed */
        if (!removeAdsBought && Qt.platform.os === "android" || Qt.platform.os === "ios") {
            adsEnabled = true
            bannerAd.visible = true
        }

        /* Hide ads */
        else {
            adsEnabled = false
            removeAdsBought = true
            bannerAd.visible = false
        }
    }

    //
    // Available purchase items
    //
    Store {
        id: store

        Product {
            id: productRemoveAds
            type: Product.Unlockable
            identifier: "com.alexspataru.supertac.remove_ads"

            onPurchaseSucceeded: {
                transaction.finalize()
                messageBox.text = qsTr ("Thanks for your purchase!") + Translator.dummy
                messageBox.open()

                adsEnabled = false
                removeAdsBought = true
            }

            onPurchaseFailed: {
                transition.finalize()
                messageBox.text = qsTr ("Failed to perform transaction") + Translator.dummy
                messageBox.open()
            }

            onPurchaseRestored: {
                adsEnabled = false
                removeAdsBought = true
                messageBox.title = qsTr ("Purchases Restored!") + Translator.dummy
                messageBox.open()
            }
        }
    }

    //
    // Used to confirm purchases
    //
    MessageDialog {
        id: messageBox
        title: app.title
        icon: StandardIcon.Information
        standardButtons: StandardButton.Close
    }
}
