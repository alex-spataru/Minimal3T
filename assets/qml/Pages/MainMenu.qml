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
    signal aboutClicked
    signal shareClicked
    signal settingsClicked
    signal multiplayerClicked
    signal singleplayerClicked

    //
    // Sound effects
    //
    onMultiplayerClicked: app.playSoundEffect ("click")
    onSingleplayerClicked: app.playSoundEffect ("game-start")

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
        // App name label
        //
        Label {
            Layout.fillHeight: false
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: app.xLargeLabel * 1.2
            font.capitalization: Font.AllUppercase
            horizontalAlignment: Label.AlignHCenter
            text: qsTr ("Minimal") + Translator.dummy
        }

        //
        // Subtitle
        //
        Label {
            Layout.fillHeight: false
            font.pixelSize: app.mediumLabel
            Layout.alignment: Qt.AlignHCenter
            font.capitalization: Font.AllUppercase
            horizontalAlignment: Label.AlignHCenter
            text: qsTr ("Tic Tac Toe Game") + Translator.dummy
        }

        //
        // Spacer
        //
        Item {
            Layout.fillHeight: true
        }

        //
        // Play button
        //
        Button {
            flat: true
            Layout.fillHeight: false
            onClicked: singleplayerClicked()
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: app.paneWidth

            contentItem: ColumnLayout {
                spacing: app.spacing
                anchors.fill: parent
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                Item {
                    Layout.fillHeight: true
                }

                Image {
                    fillMode: Image.Pad
                    source: "qrc:/images/play.svg"
                    Layout.alignment: Qt.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    horizontalAlignment: Image.AlignHCenter
                    sourceSize: Qt.size (app.iconSize, app.iconSize)
                }

                Label {
                    font.pixelSize: app.largeLabel
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: app.paneWidth
                    text: qsTr ("Play") + Translator.dummy
                    horizontalAlignment: Label.AlignHCenter
                }

                Item {
                    Layout.fillHeight: true
                }
            }
        }

        //
        // Multiplayer button
        //
        Button {
            flat: true
            Layout.fillHeight: false
            font.pixelSize: app.largeLabel
            onClicked: multiplayerClicked()
            Layout.alignment: Qt.AlignHCenter
            font.capitalization: Font.MixedCase
            Layout.preferredWidth: app.paneWidth
            text: qsTr ("Multiplayer") + Translator.dummy
        }

        //
        // Spacer
        //
        Item {
            Layout.fillHeight: true
        }

        //
        // Utility buttons
        //
        RowLayout {
            id: buttons
            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.maximumWidth: 512
            opacity: 1 - settings.opacity
            Layout.alignment: Qt.AlignHCenter

            property int pxSixe: app.font.pixelSize - 1

            ImageButton {
                btSize: 0
                onClicked: aboutClicked()
                source: "qrc:/images/info.svg"
                font.pixelSize: buttons.pxSixe
                text: qsTr ("About") + Translator.dummy
            }

            ImageButton {
                btSize: 0
                onClicked: shareClicked()
                font.pixelSize: buttons.pxSixe
                source: "qrc:/images/share.svg"
                text: qsTr ("Share") + Translator.dummy
            }

            ImageButton {
                btSize: 0
                onClicked: settingsClicked()
                font.pixelSize: buttons.pxSixe
                source: "qrc:/images/settings.svg"
                text: qsTr ("Settings") + Translator.dummy
            }
        }

        //
        // Spacer
        //
        Item {
            Layout.fillHeight: true
        }
    }
}
