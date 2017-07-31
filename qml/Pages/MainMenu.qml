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
    // Custom properties
    //
    property var utilityWidth: 56
    property var buttonWidth: Math.min (app.paneWidth - (4 * app.spacing), _utility.implicitWidth)

    //
    // Signals
    //
    signal exitClicked()
    signal aboutClicked()
    signal shareClicked()
    signal addonsClicked()
    signal settingsClicked()
    signal multiPlayerClicked()
    signal singlePlayerClicked()

    //
    // Sound effects
    //
    onExitClicked: app.playSoundEffect ("click.wav")
    onAboutClicked: app.playSoundEffect ("click.wav")
    onShareClicked: app.playSoundEffect ("click.wav")
    onAddonsClicked: app.playSoundEffect ("click.wav")
    onSettingsClicked: app.playSoundEffect ("click.wav")
    onMultiPlayerClicked: app.playSoundEffect ("click.wav")
    onSinglePlayerClicked: app.playSoundEffect ("click.wav")

    //
    // Background pane
    //
    background: Pane {
        width: app.paneWidth
        height: app.paneHeight
        anchors.centerIn: parent
        Material.elevation: app.paneElevation
        Material.background: app.paneBackground

        //
        // Controls
        //
        ColumnLayout {
            spacing: app.spacing

            anchors {
                fill: parent
                centerIn: parent
                margins: app.spacing
            }

            //
            // Spacer
            //
            Item {
                Layout.fillHeight: true
            }

            //
            // Logo
            //
            Logo {
                id: _logo
                Component.onCompleted: calculateSize()
                anchors.horizontalCenter: parent.horizontalCenter

                function calculateSize() {
                    var size = Math.min (app.paneHeight * 0.25, 156)
                    width = size
                    height = size
                    Layout.preferredWidth = size
                    Layout.preferredHeight = size
                }

                Connections {
                    target: app
                    onHeightChanged: _logo.calculateSize()
                }
            }

            //
            // Spacer
            //
            Item {
                Layout.fillHeight: true
            }

            //
            // Single player button
            //
            Button {
                text: qsTr ("Single Player")
                Material.theme: Material.Light
                onClicked: singlePlayerClicked()
                Layout.preferredWidth: buttonWidth
                anchors.horizontalCenter: parent.horizontalCenter
            }

            //
            // Multiplayer button
            //
            Button {
                text: qsTr ("Multiplayer")
                Material.theme: Material.Light
                onClicked: multiPlayerClicked()
                Layout.preferredWidth: buttonWidth
                anchors.horizontalCenter: parent.horizontalCenter
            }

            //
            // Exit button
            //
            Button {
                text: qsTr ("Exit")
                onClicked: exitClicked()
                Material.theme: Material.Light
                Layout.preferredWidth: buttonWidth
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
                id: _utility
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
                            source: "qrc:/images/about.svg"
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
                // Store button
                //
                ToolButton {
                    onClicked: addonsClicked()
                    contentItem: ColumnLayout {
                        spacing: app.spacing

                        Image {
                            fillMode: Image.Pad
                            source: "qrc:/images/store.svg"
                            verticalAlignment: Image.AlignVCenter
                            horizontalAlignment: Image.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Label {
                            text: qsTr ("Addons")
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
                            verticalAlignment: Image.AlignVCenter
                            horizontalAlignment: Image.AlignHCenter
                            source: "qrc:/images/settings.svg"
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
}
