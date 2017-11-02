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
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import Qt.labs.settings 1.0 as QtLabs

import "../Components"

Overlay {
    id: overlay

    //
    // Only show the page if user wants it to be shown
    //
    function show() {
        if (Qt.platform.os === "android")
            if (!alreadyRated && !doNotRate)
                open()
    }

    //
    // Rate me pleeease! variables
    //
    property int appLaunches: 0
    property bool doNotRate: false
    property bool alreadyRated: false

    //
    // Save settings
    //
    QtLabs.Settings {
        category: "Ratings"
        property alias doNotRate: overlay.doNotRate
        property alias appLaunches: overlay.appLaunches
        property alias alreadyRated: overlay.alreadyRated
    }

    //
    // Display overlay on init
    //
    Component.onCompleted: {
        ++appLaunches
        if (appLaunches == 3)
            show()
        else if (appLaunches % 10 == 0)
            show()
    }

    //
    // UI
    //
    contentData: ColumnLayout {
        id: layout
        spacing: app.spacing
        anchors.centerIn: parent

        SvgImage {
            source: "qrc:/images/rate.svg"
            anchors.horizontalCenter: parent.horizontalCenter
            sourceSize: Qt.size (app.iconSize * 0.75, app.iconSize * 0.75)
        }

        Item {
            Layout.preferredHeight: app.spacing
        }

        Label {
            Layout.fillWidth: true
            font.pixelSize: app.mediumLabel
            font.capitalization: Font.AllUppercase
            horizontalAlignment: Label.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr ("Rate %1").arg (app.title) + Translator.dummy
        }

        Label {
            Layout.preferredWidth: app.paneWidth
            horizontalAlignment: Label.AlignHCenter
            font.pixelSize: app.font.pixelSize * 0.8
            wrapMode: Label.WrapAtWordBoundaryOrAnywhere
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr ("If you enjoy this app, would you like taking a moment to rate it?") + Translator.dummy
        }

        Item {
            Layout.fillHeight: true
            Layout.minimumHeight: 2 * app.spacing
        }

        Button {
            Layout.fillWidth: true
            text: qsTr ("Rate") + Translator.dummy
            font.capitalization: Font.AllUppercase
            anchors.horizontalCenter: parent.horizontalCenter

            onClicked: {
                hide()
                app.openWebsite()
                doNotRate = false
                alreadyRated = true
            }
        }

        Button {
            Layout.fillWidth: true
            font.capitalization: Font.AllUppercase
            text: qsTr ("Later") + Translator.dummy
            anchors.horizontalCenter: parent.horizontalCenter

            onClicked: {
                hide()
                doNotRate = false
                alreadyRated = false
            }
        }

        Button {
            Layout.fillWidth: true
            font.capitalization: Font.AllUppercase
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr ("No, thanks") + Translator.dummy

            onClicked: {
                hide()
                doNotRate = true
                alreadyRated = false
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.minimumHeight: 2 * app.spacing
        }
    }
}
