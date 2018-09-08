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
    property bool clickableFields: false
    property real lineWidth: app.spacing / 5
    property real gridSize: Math.min (app.width, app.height) * ((app.height * 3/4) > app.width ? 2/3 : 1/2)

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
    onGridSizeChanged: redraw()
    on_Wl_limitChanged: redraw()
    Component.onCompleted: redraw()

    //
    // Calculates the appropiate size of the game fields/tiles
    //
    function redraw() {
        board.width = gridSize
        board.height = gridSize
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
                _wl_xA += app.spacing
                _wl_yA += cellSize / 2
                _wl_xB += cellSize - app.spacing
                _wl_yB += cellSize / 2
            } else if (_wl_xA > _wl_xB) {
                _wl_xA += cellSize - app.spacing
                _wl_yA += app.spacing
                _wl_xB += app.spacing
                _wl_yB += cellSize - app.spacing
            } else if (_wl_xA < _wl_xB) {
                _wl_xA += app.spacing
                _wl_yA += app.spacing
                _wl_xB += cellSize - app.spacing
                _wl_yB += cellSize - app.spacing
            } else if (_wl_xA == _wl_xB) {
                _wl_xA += cellSize / 2
                _wl_xB += cellSize / 2
                _wl_yB += cellSize - app.spacing
                _wl_yA += app.spacing
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
    // Redraw board when settings are changed
    //
    Connections {
        target: app
        onShowBoardMarginsChanged: board.redraw()
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

            /* Clear canvas */
            ctx.clearRect (0, 0, canvas.width + 10, canvas.height + 10)

            /* Obtain constants */
            var boardSize = Board.boardSize
            cellSize = grid.width / boardSize

            /* Abort drawing if cell width is invalid */
            if (cellSize <= 0)
                return;

            /* Set line style */
            ctx.lineCap = "round"
            ctx.lineJoin = "round"
            ctx.strokeStyle = "#fff"
            ctx.lineWidth = board.lineWidth

            /* Draw columns */
            for (var x = 1; x < boardSize; ++x) {
                ctx.beginPath()
                ctx.moveTo (cellSize * x, 0)
                ctx.lineTo (cellSize * x, canvas.height)
                ctx.stroke()
            }

            /* Draw rows */
            for (var y = 1; y < boardSize; ++y) {
                ctx.beginPath()
                ctx.moveTo (0, cellSize * y)
                ctx.lineTo (canvas.width, cellSize * y)
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

                /* Draw the line */
                ctx.beginPath()
                ctx.moveTo (_wl_xA, _wl_yA)
                ctx.lineTo (fx, fy)
                ctx.stroke()
            }

            /* Draw margins */
            if (app.showBoardMargins) {
                var rR = cellSize / 4
                var rX = lineWidth / 2
                var rY = lineWidth / 2
                var rL = canvas.width - lineWidth

                ctx.beginPath()
                ctx.moveTo (rX + rR, rY)
                ctx.lineTo (rX + rL - rR, rY)
                ctx.quadraticCurveTo (rX + rL, rY, rX + rL, rY + rR)
                ctx.lineTo (rX + rL, rY + rL - rR)
                ctx.quadraticCurveTo (rX + rL, rY + rL, rX + rL - rR, rY + rL)
                ctx.lineTo (rX + rR, rY + rL)
                ctx.quadraticCurveTo (rX, rY + rL, rX, rY + rL - rR)
                ctx.lineTo (rX, rY + rR)
                ctx.quadraticCurveTo (rX, rY, rX + rR, rY)
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

    //
    // Fool-proof for avoiding user input
    //
    MouseArea {
        anchors.fill: parent
        enabled: !clickableFields
    }
}
