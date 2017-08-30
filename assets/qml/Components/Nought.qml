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
    height: width

    //
    // If set to true, the circle shall not be drawn at start
    //
    property bool hidden: false

    //
    // Line properties
    //
    property real lineWidth: 1
    property string lineColor: "#fff"

    //
    // Used to draw the circle, do not change them please
    //
    property real angle: hidden ? 0 : 2 * Math.PI

    //
    // Redraw the canvas when the perimeter is changed
    //
    onAngleChanged: canvas.requestPaint()

    //
    // Set the angle to draw a complete circle
    //
    function show() {
        angleBehavior.enabled = true
        angle = 2 * Math.PI
    }

    //
    // Reset the lines
    //
    function hide() {
        angleBehavior.enabled = false
        angle = 0
    }

    //
    // Slowly draw the circle
    //
    Behavior on angle {
        id: angleBehavior
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
        smooth: true
        anchors.fill: parent
        anchors.centerIn: parent
        anchors.margins: -2 * item.lineWidth
        anchors.verticalCenterOffset: -2 * item.lineWidth
        anchors.horizontalCenterOffset: -2 * item.lineWidth

        renderStrategy: Canvas.Threaded
        renderTarget: Canvas.FramebufferObject

        onPaint: {
            /* Get context */
            var ctx = canvas.getContext ("2d")

            /* Reset and fill with transparent background */
            ctx.reset()
            ctx.fillStyle = "transparent"

            /* Set line properties */
            ctx.lineWidth = item.lineWidth;
            ctx.strokeStyle = item.lineColor;

            /* Calcualte center and radius */
            var radius = item.width / 2
            var centerX = canvas.width / 2
            var centerY = canvas.height / 2

            /* Draw circle */
            if (radius > 0) {
                ctx.beginPath()
                ctx.arc (centerX, centerY, radius, 0, angle)
                ctx.stroke()
            }
        }
    }
}
