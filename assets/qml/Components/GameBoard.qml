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
    // Custom properties
    //
    property real cellSize: 0
    property real gridWidth: app.width
    property real gridHeight: app.height
    property bool clickableFields: false

    //
    // Calculate tile size on init
    //
    onGridWidthChanged: redraw()
    onGridHeightChanged: redraw()
    Component.onCompleted: redraw()

    //
    // Calculates the appropiate size of the game fields/tiles
    //
    function redraw() {
        var side = Math.min (gridHeight, gridWidth) * (gridHeight > gridWidth ? 0.85 : 0.65)
        board.width = side
        board.height = side
        canvas.requestPaint()
    }

    //
    // Redraw board canvas when board size is changed
    //
    Connections {
        target: Board
        onBoardSizeChanged: board.redraw()
    }

    //
    // Changes the size of the game tiles when the application is resized
    //
    Connections {
        target: app
        onWidthChanged: board.redraw()
        onHeightChanged: board.redraw()
        onWindowStateChanged: board.redraw()
        onShowAllBordersChanged: board.redraw()
    }

    //
    // Generate the borders
    //
    Canvas {
        id: canvas
        smooth: true
        contextType: "2d"
        renderStrategy: Canvas.Threaded

        anchors {
            fill: parent
            centerIn: parent
            margins: app.spacing
        }

        onPaint: {
            /* Get context */
            var ctx = getContext (contextType)

            /* Reset and fill with transparent background */
            ctx.reset()
            ctx.fillStyle = "transparent"

            /* Set line properties */
            ctx.lineCap = 'round'
            ctx.strokeStyle = '#fff'
            ctx.lineWidth = app.spacing / 10

            /* Obtain constants */
            cellSize = grid.width / Board.boardSize
            var initialValue = app.showAllBorders ? 0 : 1
            var boardSize = Board.boardSize + (app.showAllBorders ? 1 : 0)

            /* Abort drawing if cell width is invalid */
            if (cellSize <= 0)
                return;

            /* Draw columns */
            for (var x = initialValue; x < boardSize; ++x) {
                ctx.beginPath()
                ctx.moveTo (cellSize * x, 0)
                ctx.lineTo (cellSize * x, canvas.height)
                ctx.closePath()
                ctx.stroke()
            }

            /* Draw rows */
            for (var y = initialValue; y < boardSize; ++y) {
                ctx.beginPath()
                ctx.moveTo (0, cellSize * y)
                ctx.lineTo (canvas.width, cellSize * y)
                ctx.closePath()
                ctx.stroke()
            }
        }
    }

    //
    // Arrange fields in a grid
    //
    Grid {
        id: grid
        rowSpacing: 0
        columnSpacing: 0
        rows: Board.boardSize
        columns: Board.boardSize

        anchors {
            fill: parent
            centerIn: parent
            margins: app.spacing
        }

        //
        // Tile/filed generator
        //
        Repeater {
            model: grid.rows * grid.columns

            Field {
                id: field
                width: cellSize
                height: cellSize
                fieldNumber: index
                enabled: board.enabled
                clickable: board.clickableFields

                Connections {
                    target: board
                    onClickableFieldsChanged: {
                        field.clickable = board.clickableFields
                    }

                    onCellSizeChanged: {
                        width = cellSize
                        height = cellSize
                    }
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
