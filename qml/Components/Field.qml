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
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.0

import Board 1.0

Item {
    id: field

    //
    // Custom properties
    //
    property int fieldNumber: -1
    property bool clickable: false
    property alias border: bg.border
    property alias symbol: _symbol.text

    //
    // Background rectangle
    //
    Rectangle {
        id: bg
        color: "transparent"
        anchors.fill: parent
        border.color: app.borderColor
        border.width: app.spacing / 2
    }

    //
    // Symbol icon
    //
    Symbol {
        text: " "
        id: _symbol
        anchors.centerIn: parent
        font.pixelSize: bg.height * 0.8
        opacity: fieldNumber == -1 ? 1 : 0
        onOpacityChanged: {
            if (opacity === 0)
                text = " "
        }

        Behavior on opacity { NumberAnimation{} }
    }

    //
    // Mouse area, to detect user clicks
    //
    MouseArea {
        enabled: clickable
        anchors.fill: parent
        onClicked: {
            if (fieldNumber >= 0)
                Board.selectField (fieldNumber)
        }
    }

    //
    // React to game events
    //
    Connections {
        target: Board
        onGameStateChanged: {
            if (fieldNumber >= 0) {
                field.clickable = true

                if (Board.gameDraw)
                    _symbol.opacity = 0.2

                else if (Board.gameInProgress)
                    _symbol.opacity = 1

                else if (Board.gameWon) {
                    _symbol.opacity = 0.2
                    for (var i = 0; i < Board.allignedFields().length; ++i)
                        if (Board.allignedFields()[i] === field.fieldNumber)
                            _symbol.opacity = 1
                }
            }
        }

        onFieldStateChanged: {
            if (field.fieldNumber != fieldId)
                return

            var owner = Board.fieldOwner (fieldNumber)

            if (owner === TicTacToe.Player1) {
                field.symbol = app.p1Symbol
                app.playSoundEffect ("p1_field.wav")
                _symbol.opacity = 1
            }

            else if (owner === TicTacToe.Player2) {
                field.symbol = app.p2Symbol
                app.playSoundEffect ("p2_field.wav")
                _symbol.opacity = 1
            }

            else
                _symbol.opacity = 0
        }
    }
}
