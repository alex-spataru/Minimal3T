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
    // Used to draw the cross, do not change them please
    //
    property real lineA: hidden ? 0 : item.width
    property real lineB: hidden ? 0 : item.width

    //
    // Redraw the canvas when the line values are changed
    //
    onLineAChanged: canvas.requestPaint()
    onLineBChanged: canvas.requestPaint()

    //
    // Draw the first line, when the animation of the first line finishes,
    // then the second line shall be drawn
    //
    function show() {
        lineABehavior.enabled = true
        lineBBehavior.enabled = true

        lineB = 0
        lineA = canvas.width
    }

    //
    // Reset the lines
    //
    function hide() {
        lineABehavior.enabled = false
        lineBBehavior.enabled = false

        lineA = 0
        lineB = 0
    }

    //
    // Draw the first line, when finished, draw the second line
    //
    Behavior on lineA {
        id: lineABehavior
        enabled: false

        NumberAnimation {
            duration: app.pieceAnimation
            onRunningChanged: {
                if (!running && lineA === canvas.width)
                    lineB = lineA
            }
        }
    }

    //
    // Slowly draw the second line
    //
    Behavior on lineB {
        id: lineBBehavior
        enabled: false

        NumberAnimation {
            duration: app.pieceAnimation
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

            /* Get context and clear canvas */
            ctx.lineCap = 'round'
            ctx.lineWidth = item.lineWidth
            ctx.strokeStyle = item.lineColor

            /* Clear canvas */
            ctx.clearRect (0, 0, canvas.width + 2, canvas.height + 2)

            /* Draw line A */
            if (lineA > 0 && canvas.width > 0) {
                ctx.beginPath()
                ctx.moveTo (canvas.width, 0)
                ctx.lineTo (canvas.width - lineA, lineA)
                ctx.closePath()
                ctx.stroke()
            }

            /* Draw line B */
            if (lineB > 0 && canvas.width > 0) {
                ctx.beginPath()
                ctx.moveTo (0, 0)
                ctx.lineTo (lineB, lineB)
                ctx.closePath()
                ctx.stroke()
            }

            /* Save ctx */
            ctx.save()
        }
    }
}
