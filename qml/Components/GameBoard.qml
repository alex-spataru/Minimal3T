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

import Board 1.0

Item {
    id: board

    //
    // Allows or disallows the human player to change field states
    //
    property bool clickableFields: false

    //
    // Calculate tile size on init
    //
    Component.onCompleted: updateSize()

    //
    // Calculates the appropiate size of the game fields/tiles
    //
    function updateSize() {
        var side = Math.min (app.height, app.width) * 0.8
        board.width = side
        board.height = side
    }

    //
    // Changes the size of the game tiles when the application is resized
    //
    Connections {
        target: app
        onWidthChanged: board.updateSize()
        onHeightChanged: board.updateSize()
        onWindowStateChanged: board.updateSize()
    }

    //
    // Main layout of the tiles
    //
    GridLayout {
        id: grid
        anchors.fill: parent
        rows: Board.boardSize
        columns: Board.boardSize
        Layout.margins: app.spacing
        rowSpacing: app.spacing * -1/4
        columnSpacing: app.spacing * -1/4

        //
        // Tile/filed generator
        //
        Repeater {
            model: parent.rows * parent.columns

            Field {
                id: field
                fieldNumber: index
                Layout.fillWidth: true
                Layout.fillHeight: true
                clickable: board.clickableFields
                border.width: grid.rowSpacing * -1

                Connections {
                    target: board
                    onClickableFieldsChanged: field.clickable = board.clickableFields
                }

                Connections {
                    target: Board
                    onBoardReset: field.clickable = board.clickableFields
                    onTurnChanged: field.clickable = board.clickableFields
                    onGameStateChanged: field.clickable = board.clickableFields
                }
            }
        }
    }
}
