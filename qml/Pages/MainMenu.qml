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
    // Constant for setting tool buttons width
    //
    property var utilityWidth: 56

    //
    // Signals
    //
    signal aboutClicked
    signal shareClicked
    signal disableAdsClicked
    signal settingsClicked
    signal multiplayerClicked
    signal singleplayerClicked

    //
    // Sound effects
    //
    onAboutClicked: app.playSoundEffect ("click.wav")
    onShareClicked: app.playSoundEffect ("click.wav")
    onSettingsClicked: app.playSoundEffect ("click.wav")
    onDisableAdsClicked: app.playSoundEffect ("click.wav")
    onMultiplayerClicked: app.playSoundEffect ("click.wav")
    onSingleplayerClicked: app.playSoundEffect ("click.wav")

    //
    // Transparent bacground
    //
    background: Item {}

    //
    // Main layout
    //
    ColumnLayout {
        spacing: app.spacing
        anchors.centerIn: parent

        //
        // App name label
        //
        Label {
            text: AppName
            font.bold: true
            font.pixelSize: 36
            font.capitalization: Font.AllUppercase
            horizontalAlignment: Label.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            font.pixelSize: 18
            text: qsTr ("Tic-Tac-Toe Game")
            font.capitalization: Font.AllUppercase
            horizontalAlignment: Label.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        //
        // Spacer
        //
        Item {
            Layout.fillHeight: true
            Layout.minimumHeight: 3 * app.spacing
        }

        //
        // Play button
        //
        Button {
            flat: true
            Layout.fillHeight: true
            onClicked: singleplayerClicked()
            Layout.preferredWidth: app.paneWidth
            anchors.horizontalCenter: parent.horizontalCenter

            contentItem: ColumnLayout {
                spacing: app.spacing

                Image {
                    fillMode: Image.Pad
                    source: "qrc:/images/play.svg"
                    sourceSize: Qt.size (128, 128)
                    verticalAlignment: Image.AlignVCenter
                    horizontalAlignment: Image.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    font.bold: true
                    font.pixelSize: 24
                    text: qsTr ("Play")
                    Layout.preferredWidth: app.paneWidth
                    horizontalAlignment: Label.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Item {
                    height: app.spacing
                }
            }
        }

        //
        // Multiplayer button
        //
        Button {
            flat: true
            font.pixelSize: 24
            text: qsTr ("Multiplayer")
            onClicked: multiplayerClicked()
            font.capitalization: Font.MixedCase
            Layout.preferredWidth: app.paneWidth
            anchors.horizontalCenter: parent.horizontalCenter
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
            spacing: 0
            Layout.fillWidth: true
            anchors.horizontalCenter: parent.horizontalCenter

            //
            // About button
            //
            ToolButton {
                onClicked: aboutClicked()
                contentItem: ColumnLayout {
                    spacing: app.spacing

                    Image {
                        fillMode: Image.Pad
                        source: "qrc:/images/info.svg"
                        verticalAlignment: Image.AlignVCenter
                        horizontalAlignment: Image.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Label {
                        text: qsTr ("About")
                        Layout.preferredWidth: utilityWidth
                        horizontalAlignment: Label.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            //
            // No Ads button
            //
            ToolButton {
                visible: opacity > 0
                onClicked: disableAdsClicked()
                opacity: app.adsEnabled ? 1 : 0

                Behavior on width { NumberAnimation{} }
                Behavior on opacity { NumberAnimation{} }

                contentItem: ColumnLayout {
                    spacing: app.spacing

                    Image {
                        fillMode: Image.Pad
                        source: "qrc:/images/no-ads.svg"
                        verticalAlignment: Image.AlignVCenter
                        horizontalAlignment: Image.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Label {
                        text: qsTr ("Remove Ads")
                        Layout.preferredWidth: utilityWidth
                        horizontalAlignment: Label.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            //
            // Share button
            //
            ToolButton {
                onClicked: shareClicked()
                contentItem: ColumnLayout {
                    spacing: app.spacing

                    Image {
                        fillMode: Image.Pad
                        source: "qrc:/images/share.svg"
                        verticalAlignment: Image.AlignVCenter
                        horizontalAlignment: Image.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Label {
                        text: qsTr ("Share")
                        Layout.preferredWidth: utilityWidth
                        horizontalAlignment: Label.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            //
            // Preferences button
            //
            ToolButton {
                onClicked: settingsClicked()
                contentItem: ColumnLayout {
                    spacing: app.spacing

                    Image {
                        fillMode: Image.Pad
                        source: "qrc:/images/wrench.svg"
                        verticalAlignment: Image.AlignVCenter
                        horizontalAlignment: Image.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Label {
                        text: qsTr ("Settings")
                        Layout.preferredWidth: utilityWidth
                        horizontalAlignment: Label.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }
    }
}
