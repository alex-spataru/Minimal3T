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

import Board 1.0

Item {
    id: field

    //
    // Custom properties
    //
    property int fieldNumber: -1
    property bool clickable: true


    //
    // Randomize array element order in-place.
    // Using Durstenfeld shuffle algorithm.
    //
    // Source:
    //   https://stackoverflow.com/a/12646864
    //
    function shuffleArray(array) {
        for (var i = array.length - 1; i > 0; i--) {
            var j = Math.floor (Math.random() * (i + 1));
            var temp = array[i];
            array[i] = array[j];
            array[j] = temp;
        }
        return array;
    }

    //
    // Plays a random note when the field is selected
    //
    function playRandomNote() {
        var note = fieldNumber
        var notes = shuffleArray (["a", "b", "c", "d", "e", "f", "g"])

        while (note >= notes.length)
            note -= notes.length

        app.playSoundEffect ("notes/" + notes [note])
    }

    //
    // Displays the appropiate piece given the field owner
    //
    function drawPiece() {
        _symbol.opacity = 1

        var owner = Board.fieldOwner (fieldNumber)
        if (field.enabled && owner > TicTacToe.Undefined) {
            if (app.getSymbol (owner))
                _cross.show()
            else
                _nought.show()

            playRandomNote()
        }

        else {
            _cross.hide()
            _nought.hide()
        }
    }

    //
    // Changes the clickable state of the field and updates the opacity
    // to highlight any winning line streaks
    //
    function updateFieldState() {
        if (fieldNumber >= 0 && field.enabled) {
            clickable = true

            if (Board.gameDraw)
                _symbol.opacity = 0.2

            else if (Board.gameWon) {
                _symbol.opacity = 0.2
                for (var i = 0; i < Board.allignedFields().length; ++i)
                    if (Board.allignedFields()[i] === field.fieldNumber)
                        _symbol.opacity = 1
            }
        }
    }

    //
    // Get component piece on creation
    //
    Component.onCompleted: {
        drawPiece()
        updateFieldState()
    }

    //
    // Symbol icon
    //
    Item {
        id: _symbol
        anchors.centerIn: parent
        width: field.width * 0.7
        height: field.height * 0.7

        Behavior on opacity { NumberAnimation{} }

        Nought {
            id: _nought
            hidden: true
            anchors.fill: parent
            anchors.centerIn: parent
            lineWidth: 1/5 * app.spacing
        }

        Cross {
            id: _cross
            hidden: true
            anchors.fill: parent
            anchors.centerIn: parent
            lineWidth: 1/5 * app.spacing
        }
    }

    //
    // Mouse area, to detect user clicks
    //
    MouseArea {
        enabled: clickable
        anchors.fill: parent
        onClicked: {
            if (fieldNumber >= 0 && Board.gameInProgress)
                if (Board.fieldOwner (fieldNumber) === TicTacToe.Undefined)
                    Board.selectField (fieldNumber)
        }
    }

    //
    // React to game events
    //
    Connections {
        target: Board
        onGameStateChanged: updateFieldState()
        onFieldStateChanged: {
            if (field.fieldNumber != fieldId)
                return

            field.drawPiece()
        }
    }
}
