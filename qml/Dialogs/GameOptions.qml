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

Dialog {
    id: gameOptions

    //
    // Center window on application
    //
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2

    //
    // Custom properties
    //
    property alias p2StartsFirst: _p2StartsFirst.checked

    //
    // Save settings between runs
    //
    Settings {
        category: "GameOptions"
        property alias p2Begins: _p2StartsFirst.checked
        property alias boardSize: _boardSize.currentIndex
        property alias aiDifficulty: _aiLevel.currentIndex
        property alias fieldsToAllign: _fieldsToAllign.value
    }

    //
    // Window settings
    //
    modal: true
    standardButtons: Dialog.Ok
    title: qsTr ("Game Options")
    parent: ApplicationWindow.overlay
    width: Math.min (app.width * 0.9, layout.implicitWidth * 1.4)

    //
    // Updates the board and AI config bases on selected UI options
    //
    function applySettings() {
        Board.boardSize = _boardSize.currentIndex + 3

        switch (_aiLevel.currentIndex) {
        case 0:
            AiPlayer.randomness = 10
            break
        case 1:
            AiPlayer.randomness = 6
            break
        case 2:
            AiPlayer.randomness = 4
            break
        case 4:
            AiPlayer.randomness = 2
            break
        case 5:
            AiPlayer.randomness = 0
            break
        }
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
        // Board size
        //
        Label {
            text: qsTr ("Board size") + ":"
        } ComboBox {
            id: _boardSize
            currentIndex: -1
            Layout.fillWidth: true
            Material.background: "#dedede"
            Material.foreground: "#000000"
            Layout.preferredWidth: app.paneWidth
            onCurrentIndexChanged: applySettings()
            model: ["3x3", "4x4", "5x5", "6x6", "7x7"]
        }

        //
        // Warning label
        //
        Label {
            visible: opacity > 0
            Behavior on opacity { NumberAnimation{} }
            opacity: _boardSize.currentIndex > 0 ? 1 : 0
            text: "<strong><font color=\"" + app.secondaryColor + "\">" +
                  qsTr ("Warning:") + "</font></strong> " +
                  qsTr ("The AI will be slow on larger boards")
        }

        //
        // Warning spacer
        //
        Item {
            Behavior on Layout.preferredHeight { NumberAnimation {} }
            Layout.preferredHeight: _boardSize.currentIndex > 1 ? app.spacing * 2 : 0
        }

        //
        // AI difficulty
        //
        Label {
            text: qsTr ("AI Level") + ":"
        } ComboBox {
            id: _aiLevel
            currentIndex: 2
            Layout.fillWidth: true
            Material.background: "#dedede"
            Material.foreground: "#000000"
            Layout.preferredWidth: app.paneWidth
            onCurrentIndexChanged: applySettings()
            model: [
                qsTr ("Very Easy"),
                qsTr ("Easy"),
                qsTr ("Normal"),
                qsTr ("Hard"),
                qsTr ("Very Hard")
            ]
        }

        //
        // Fields to Allign
        //
        Label {
            text: qsTr ("Fields to Allign")
        } SpinBox {
            from: 3
            id: _fieldsToAllign
            to: Board.boardSize
            Layout.fillWidth: true
            Layout.preferredWidth: app.paneWidth
            onValueChanged: Board.fieldsToAllign = value
        }

        //
        // Second player first
        //
        Switch {
            id: _p2StartsFirst
            text: qsTr ("Player 2 starts first")
        }
    }
}
