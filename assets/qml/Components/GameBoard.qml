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
    // For drawing the winning line
    //
    property real _wl_xA: 0
    property real _wl_xB: 0
    property real _wl_yA: 0
    property real _wl_yB: 0
    property real _wl_limit: 0

    //
    // Calculate tile size on init
    //
    onGridWidthChanged: redraw()
    onGridHeightChanged: redraw()
    Component.onCompleted: redraw()
    on_Wl_limitChanged: redraw()

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
            _wl_xA = repeater.itemAt (fieldA).x
            _wl_yA = repeater.itemAt (fieldA).y
            _wl_xB = repeater.itemAt (fieldB).x
            _wl_yB = repeater.itemAt (fieldB).y

            /* Update the points to create a line between corners */
            if (_wl_yA == _wl_yB) {
                _wl_yA += cellSize / 2
                _wl_yB += cellSize / 2
                _wl_xB += cellSize
            } else if (_wl_xA > _wl_xB) {
                _wl_xA += cellSize
                _wl_yB += cellSize
            } else if (_wl_xA < _wl_xB) {
                _wl_xB += cellSize
                _wl_yB += cellSize
            } else if (_wl_xA == _wl_xB) {
                _wl_xA += cellSize / 2
                _wl_xB += cellSize / 2
                _wl_yB += cellSize
            }

            /* Set line length to 0 (inverse prop. to drawn line) */
            _wl_limit = 0
        }

        else {
            _wl_xA = 0; _wl_yA = 0
            _wl_xB = 0; _wl_yB = 0
            _wl_limit = cellSize * Board.fieldsToAllign
        }
    }

    //
    // Animate winning line
    //
    Behavior on _wl_limit { NumberAnimation {duration: pieceAnimation} }

    //
    // Redraw board canvas when board size is changed
    //
    Connections {
        target: Board
        onBoardSizeChanged: board.redraw()
        onGameStateChanged: findWinningLine()
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
                var fx = _wl_xB
                var fy = _wl_yB

                /* Get end point based on line length */
                if (_wl_xB > _wl_xA)
                    fx -= _wl_limit
                else if (_wl_xB < _wl_xA)
                    fx += _wl_limit
                if (_wl_yB > _wl_yA)
                    fy -= _wl_limit
                else if (_wl_yB < _wl_yA)
                    fy += _wl_limit

                /* Set line style */
                ctx.strokeStyle = "#fff"
                ctx.lineWidth = 0//board.lineWidth

                /* Draw the line */
                ctx.beginPath()
                ctx.moveTo (_wl_xA, _wl_yA)
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
