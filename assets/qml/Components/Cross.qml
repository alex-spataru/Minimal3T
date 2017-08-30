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
    property string lineColor: "#fff"
    property real lineWidth: DevicePixelRatio

    //
    // Used to draw the cross, do not change them please
    //
    property real _lineA: hidden ? 0 : item.width
    property real _lineB: hidden ? 0 : item.width

    //
    // Redraw the canvas when the line values are changed
    //
    on_LineAChanged: canvasA.requestPaint()
    on_LineBChanged: canvasB.requestPaint()

    //
    // Draw the first line, when the animation of the first line finishes,
    // then the second line shall be drawn
    //
    function show() {
        _lineB = 0
        startDrawing.start()
    }

    //
    // Reset the lines
    //
    function hide() {
        _lineA = 0
        _lineB = 0
    }

    //
    // Slowly draw the first line, when finished, draw the second line
    //
    NumberAnimation on _lineA {
        from: 0
        duration: 175
        to: item.width
        id: startDrawing
        onStopped: _lineB = _lineA
    }

    //
    // Slowly draw the second line
    //
    Behavior on _lineB { NumberAnimation { duration: 175 } }

    //
    // First line canvas
    //
    Canvas {
        id: canvasA
        anchors.fill: parent
        anchors.centerIn: parent
        onPaint: {
            /* Get context */
            var ctx = getContext("2d")

            /* Reset and fill with transparent background */
            ctx.reset()
            ctx.fillStyle = "transparent"

            /* Set line properties */
            ctx.lineCap = 'round'
            ctx.lineWidth = item.lineWidth
            ctx.strokeStyle = item.lineColor

            /* Begin line at (width, 0) */
            ctx.beginPath()
            ctx.moveTo (canvasA.width, 0)

            /* Set end point of line */
            ctx.lineTo (canvasA.width - _lineA, _lineA)
            ctx.closePath()

            /* Draw line */
            ctx.stroke()
        }
    }

    //
    // Second line canvas
    //
    Canvas {
        id: canvasB
        anchors.fill: parent
        anchors.centerIn: parent
        onPaint: {
            /* Get context */
            var ctx = getContext("2d")

            /* Reset and fill with transparent background */
            ctx.reset()
            ctx.fillStyle = "transparent"

            /* Set line properties */
            ctx.lineWidth = item.lineWidth;
            ctx.strokeStyle = item.lineColor;

            /* Begin line at (0, 0) */
            ctx.beginPath()
            ctx.moveTo (0, 0)

            /* Set end point of line */
            ctx.lineTo (_lineB, _lineB)
            ctx.closePath()

            /* Draw line */
            ctx.stroke()
        }
    }
}
