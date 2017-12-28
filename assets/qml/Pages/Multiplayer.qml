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
import QtQuick.Controls.Material 2.0

import "../Components"

Page {
    //
    // Signals
    //
    signal lanClicked
    signal onlineClicked
    signal sameDeviceClicked

    //
    // Sound effects
    //
    onLanClicked: app.playSoundEffect ("click")
    onOnlineClicked: app.playSoundEffect ("click")
    onSameDeviceClicked: app.playSoundEffect ("click")

    //
    // Transparent bacground
    //
    background: Item {}

    //
    // Main layout
    //
    ColumnLayout {
        spacing: 0
        anchors.fill: parent
        anchors.centerIn: parent
        anchors.margins: 2 * app.spacing

        //
        // Spacer
        //
        Item {
            Layout.fillHeight: true
        }

        //
        // Multiplayer icon
        //
        SvgImage {
            fillMode: Image.Pad
            source: "qrc:/images/multiplayer.svg"
            verticalAlignment: Image.AlignVCenter
            horizontalAlignment: Image.AlignHCenter
            sourceSize: Qt.size (app.iconSize, app.iconSize)
            anchors.horizontalCenter: parent.horizontalCenter
        }

        //
        // Subtitle
        //
        Label {
            Layout.fillHeight: false
            font.pixelSize: app.mediumLabel
            font.capitalization: Font.AllUppercase
            horizontalAlignment: Label.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr ("Choose game type") + Translator.dummy
        }

        //
        // Spacer
        //
        Item {
            Layout.fillHeight: true
        }

        //
        // Same device button
        //
        Button {
            flat: true
            onClicked: lanClicked()
            Layout.fillHeight: false
            font.pixelSize: app.largeLabel
            font.capitalization: Font.MixedCase
            Layout.preferredWidth: app.paneWidth
            text: qsTr ("Same Device") + Translator.dummy
            anchors.horizontalCenter: parent.horizontalCenter
        }

        //
        // LAN button
        //
        Button {
            flat: true
            onClicked: lanClicked()
            Layout.fillHeight: false
            font.pixelSize: app.largeLabel
            font.capitalization: Font.MixedCase
            Layout.preferredWidth: app.paneWidth
            text: qsTr ("LAN Game") + Translator.dummy
            anchors.horizontalCenter: parent.horizontalCenter
        }

        //
        // Online button
        //
        Button {
            flat: true
            onClicked: lanClicked()
            Layout.fillHeight: false
            font.pixelSize: app.largeLabel
            font.capitalization: Font.MixedCase
            Layout.preferredWidth: app.paneWidth
            text: qsTr ("Online") + Translator.dummy
            anchors.horizontalCenter: parent.horizontalCenter
        }

        //
        // Spacer
        //
        Item {
            Layout.fillHeight: true
        }
    }
}
