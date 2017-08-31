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
    property real lineWidth: app.spacing / 5

    //
    // For drawing the winning lines
    //
    property real x1: 0
    property real x2: 0
    property real y1: 0
    property real y2: 0
    property real lineLength: 0

    //
    // Calculate tile size on init
    //
    onGridWidthChanged: redraw()
    onLineLengthChanged: redraw()
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
    // Finds the (x,y) coordinates of the winning fields
    //
    function findWinningLine() {
        if (Board.gameWon) {
            /* Get first and last winning fields */
            var fieldA = Board.allignedFields() [0]
            var fieldB = Board.allignedFields() [Board.fieldsToAllign - 1]

            /* Get location of both fields */
            x1 = repeater.itemAt (fieldA).x
            y1 = repeater.itemAt (fieldA).y
            x2 = repeater.itemAt (fieldB).x
            y2 = repeater.itemAt (fieldB).y

            /* Update the points to create a line between corners */
            if (y1 == y2) {
                y1 += cellSize / 2
                y2 += cellSize / 2
                x2 += cellSize / 2
            } else if (x1 > x2) {
                x1 += cellSize
                y2 += cellSize
            } else if (x1 < x2) {
                x2 += cellSize
                y2 += cellSize
            } else if (x1 == x2) {
                x1 += cellSize / 2
                x2 += cellSize / 2
                y2 += cellSize
            }

            /* Set line length to 0 (inverse prop. to drawn line) */
            lineLength = 0
        }

        else {
            x1 = 0; y1 = 0
            x2 = 0; y2 = 0
            lineLength = cellSize * Board.fieldsToAllign
        }
    }

    //
    // Animate winning line
    //
    Behavior on lineLength { NumberAnimation{} }

    //
    // Redraw board canvas when board size is changed
    //
    Connections {
        target: Board
        onBoardSizeChanged: board.redraw()
        onGameStateChanged: {
            findWinningLine()
            board.redraw()
        }
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
        }

        onPaint: {
            /* Get context */
            var ctx = getContext (contextType)
            ctx.lineCap = 'round'

            /* Clear canvas */
            ctx.clearRect (0, 0, canvas.width + 2, canvas.height + 2)

            /* Obtain constants */
            var spacing = 0
            cellSize = grid.width / Board.boardSize
            var initialValue = app.showAllBorders ? 0 : 1
            var boardSize = Board.boardSize + (app.showAllBorders ? 1 : 0)

            /* Abort drawing if cell width is invalid */
            if (cellSize <= 0)
                return;

            /* Set line style */
            ctx.strokeStyle = "#fff"
            ctx.lineWidth = board.lineWidth

            /* Draw columns */
            for (var x = initialValue; x < boardSize; ++x) {
                /* Calculate spacing (to fit outer borders) */
                spacing = 0
                if (app.showAllBorders) {
                    if (x === 0)
                        spacing = (ctx.lineWidth / 2)
                    else if (x === boardSize - 1)
                        spacing = (ctx.lineWidth / 2) * -1
                }

                /* Draw column */
                ctx.beginPath()
                ctx.moveTo (spacing + cellSize * x, 0)
                ctx.lineTo (spacing + cellSize * x, canvas.height)
                ctx.closePath()
                ctx.stroke()
            }

            /* Draw rows */
            for (var y = initialValue; y < boardSize; ++y) {
                /* Calculate spacing (to fit outer borders) */
                spacing = 0
                if (app.showAllBorders) {
                    if (y === 0)
                        spacing = (ctx.lineWidth / 2)
                    else if (y === boardSize - 1)
                        spacing = (ctx.lineWidth / 2) * -1
                }

                /* Draw row */
                ctx.beginPath()
                ctx.moveTo (0, cellSize * y + spacing)
                ctx.lineTo (canvas.width, cellSize * y + spacing)
                ctx.closePath()
                ctx.stroke()
            }

            /* Draw the winning line */
            if (Board.gameWon) {
                var fx = x2
                var fy = y2

                /* Get end point based on line length */
                if (lineLength > 0) {
                    if (x2 > x1)
                        fx -= lineLength
                    else if (x2 < x1)
                        fx += lineLength
                    if (y2 > y1)
                        fy -= lineLength
                    else if (y2 < y1)
                        fy += lineLength
                }

                /* Set line style */
                ctx.strokeStyle = "#fff"
                ctx.lineWidth = 0//board.lineWidth

                /* Draw the line */
                ctx.beginPath()
                ctx.moveTo (x1, y1)
                ctx.lineTo (fx, fy)
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
            verticalCenterOffset: app.showAllBorders ? -board.lineWidth : 0
            horizontalCenterOffset: app.showAllBorders ? -board.lineWidth : 0
        }

        //
        // Tile/filed generator
        //
        Repeater {
            id: repeater
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
