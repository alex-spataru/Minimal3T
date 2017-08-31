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

Item {
    id: item

    //
    // If set to true, the lines shall not be drawn at start
    //
    property bool hidden: false

    //
    // Line properties
    //
    property real lineWidth: 1
    property string lineColor: "#fff"

    //
    // Used to draw the cross, do not change them
    //
    property real _diagA: hidden ? 0 : item.width
    property real _diagB: hidden ? 0 : item.width

    //
    // Redraw the canvas when the line values are changed
    //
    on_DiagAChanged: canvas.requestPaint()
    on_DiagBChanged: canvas.requestPaint()

    //
    // Draw the first line, when the animation of the first line finishes,
    // then the second line shall be drawn
    //
    function show() {
        _dABehavior.enabled = true
        _dBBehavior.enabled = true

        _diagB = 0
        _diagA = canvas.width
    }

    //
    // Reset the lines
    //
    function hide() {
        _dABehavior.enabled = false
        _dBBehavior.enabled = false

        _diagA = 0
        _diagB = 0
    }

    //
    // Draw the first line, when finished, draw the second line
    //
    Behavior on _diagA {
        id: _dABehavior
        enabled: false

        NumberAnimation {
            duration: app.pieceAnimation / 2
            onRunningChanged: {
                if (!running && _diagA > 0)
                    _diagB = _diagA
            }
        }
    }

    //
    // Draw the second line
    //
    Behavior on _diagB {
        id: _dBBehavior
        enabled: false

        NumberAnimation {
            duration: app.pieceAnimation / 2
        }
    }

    //
    // Canvas
    //
    Canvas {
        id: canvas
        contextType: "2d"
        anchors.centerIn: parent
        width: parent.width * 0.95
        height: parent.height * 0.95
        renderStrategy: Canvas.Threaded

        onPaint: {
            /* Get context */
            var ctx = getContext (contextType)

            /* Set line style */
            ctx.lineCap = 'round'
            ctx.lineWidth = item.lineWidth
            ctx.strokeStyle = item.lineColor

            /* Clear canvas */
            ctx.clearRect (0, 0, canvas.width + 2, canvas.height + 2)

            /* Draw line A */
            if (_diagA > 0 && canvas.width > 0) {
                ctx.beginPath()
                ctx.moveTo (canvas.width, 0)
                ctx.lineTo (canvas.width - _diagA, _diagA)
                ctx.closePath()
                ctx.stroke()
            }

            /* Draw line B */
            if (_diagB > 0 && canvas.width > 0) {
                ctx.beginPath()
                ctx.moveTo (0, 0)
                ctx.lineTo (_diagB, _diagB)
                ctx.closePath()
                ctx.stroke()
            }

            /* Save ctx */
            ctx.save()
        }
    }
}
