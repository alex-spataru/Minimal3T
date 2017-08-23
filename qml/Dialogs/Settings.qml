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
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.0

import Qt.labs.settings 1.0

import "../Components"

Dialog {
    id: dlg

    //
    // Properties
    //
    property bool useCross: false
    property bool humanFirst: true
    property bool enableMusic: true
    property bool enableSoundEffects: true

    //
    // Center window on application
    //
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2

    //
    // Window settings
    //
    modal: true
    title: qsTr ("Settings")
    standardButtons: Dialog.Ok
    parent: ApplicationWindow.overlay
    Component.onCompleted: applySettings()
    width: (app.paneWidth < 512 ? app.width : app.paneWidth) * 0.9

    //
    // Updates the board and AI config bases on selected UI options
    //
    function applySettings() {
        Board.boardSize = _boardSize.currentIndex + 3

        switch (_aiLevel.currentIndex) {
        case 0:
            AiPlayer.randomness = 7
            break
        case 1:
            AiPlayer.randomness = 3
            break
        case 2:
            AiPlayer.randomness = 0
            break
        }
    }

    //
    // Save settings between app runs
    //
    Settings {
        category: "Settings"
        property alias cross: dlg.useCross
        property alias music: dlg.enableMusic
        property alias humanFirst: dlg.humanFirst
        property alias effects: dlg.enableSoundEffects
        property alias boardSize: _boardSize.currentIndex
        property alias aiDifficulty: _aiLevel.currentIndex
        property alias fieldsToAllign: _fieldsToAllign.value
    }

    //
    // Main layout
    //
    ColumnLayout {
        id: layout
        spacing: app.spacing
        anchors.fill: parent
        anchors.centerIn: parent

        //
        // Sound and music
        //
        RowLayout {
            spacing: app.spacing
            Layout.fillWidth: true
            anchors.horizontalCenter: parent.horizontalCenter

            ImageButton {
                btSize: 0
                text: qsTr ("Symbol")
                onClicked: useCross = !useCross
                source: useCross ? "qrc:/images/cross.svg" :
                                   "qrc:/images/circle.svg"
            }

            ImageButton {
                btSize: 0
                text: qsTr ("Starting turn")
                onClicked: humanFirst = !humanFirst
                source: humanFirst ? "qrc:/images/human.svg" :
                                     "qrc:/images/ai.svg"
            }

            ImageButton {
                btSize: 0
                text: qsTr ("Music")
                onClicked: enableMusic = !enableMusic
                source: enableMusic ? "qrc:/images/music-on.svg" :
                                      "qrc:/images/music-off.svg"

                opacity: enableMusic ? 1 : 0.6
                Behavior on opacity { NumberAnimation{} }
            }

            ImageButton {
                btSize: 0
                text: qsTr ("Effects")
                onClicked: enableSoundEffects = !enableSoundEffects
                source: enableSoundEffects ? "qrc:/images/volume-on.svg" :
                                             "qrc:/images/volume-off.svg"

                opacity: enableSoundEffects ? 1 : 0.6
                Behavior on opacity { NumberAnimation{} }
            }
        }

        //
        // Spacer
        //
        Item {
            Layout.preferredHeight: app.spacing
        }

        //
        // Map size
        //
        Label {
            text: qsTr ("Map Dimension") + ":"
        } ComboBox {
            id: _boardSize
            Layout.fillWidth: true
            Material.background: "#dedede"
            Material.foreground: "#000000"
            Layout.preferredWidth: app.paneWidth
            onCurrentIndexChanged: applySettings()
            model: ["3x3", "4x4", "5x5", "6x6", "7x7", "8x8", "9x9", "10x10"]
        }

        //
        // AI difficulty
        //
        Label {
            text: qsTr ("AI Level") + ":"
        } ComboBox {
            id: _aiLevel
            currentIndex: 1
            Layout.fillWidth: true
            Material.background: "#dedede"
            Material.foreground: "#000000"
            Layout.preferredWidth: app.paneWidth
            onCurrentIndexChanged: applySettings()
            model: [
                qsTr ("Easy"),
                qsTr ("Normal"),
                qsTr ("Hard"),
            ]
        }

        //
        // Fields to Allign
        //
        Label {
            text: qsTr ("Fields to Allign") + ":"
        } SpinBox {
            from: 3
            id: _fieldsToAllign
            to: Board.boardSize
            Layout.fillWidth: true
            Layout.preferredWidth: app.paneWidth
            onValueChanged: {
                if (value >= 3)
                    Board.fieldsToAllign = value
            }
        }
    }
}
