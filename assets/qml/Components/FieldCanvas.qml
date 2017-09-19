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
    // If set to true, the piece shall not be drawn at start
    //
    property bool hidden: false

    //
    // Set field type
    //
    property bool isNought: false
    readonly property bool isCross: !isNought

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
    // Used to draw the circle, do not change
    //
    property real _angle: hidden ? 0 : 2 * Math.PI

    //
    // Redraw the canvas when the angle is changed
    //
    on_AngleChanged: canvas.requestPaint()

    //
    // Redraw the canvas when the line values are changed
    //
    on_DiagAChanged: canvas.requestPaint()
    on_DiagBChanged: canvas.requestPaint()

    //
    // Draws the piece
    //
    function show() {
        if (isCross) {
            _dABehavior.enabled = true
            _dBBehavior.enabled = true

            _diagB = 0
            _diagA = canvas.width
        }

        else if (isNought) {
            _anBehavior.enabled = true
            _angle = 2 * Math.PI
        }
    }

    //
    // Reset the lines
    //
    function hide() {
        _anBehavior.enabled = false
        _dABehavior.enabled = false
        _dBBehavior.enabled = false

        _angle = 0
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
    // Use an animation when drawing the circle
    //
    Behavior on _angle {
        id: _anBehavior
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
        contextType: "2d"
        anchors.fill: parent
        anchors.centerIn: parent
        renderStrategy: Canvas.Threaded
        anchors.verticalCenterOffset: anchors.margins
        anchors.horizontalCenterOffset: anchors.margins
        anchors.margins: (isNought ? -2 : 1) * item.lineWidth

        onPaint: {
            /* Get context */
            var ctx = getContext (contextType)

            /* Set line style */
            ctx.lineCap = "round"
            ctx.lineWidth = item.lineWidth
            ctx.strokeStyle = item.lineColor

            /* Clear canvas */
            ctx.clearRect (0, 0, canvas.width + 2, canvas.height + 2)

            /* Draw cross */
            if (isCross) {
                if (_diagA > 0 && canvas.width > 0) {
                    ctx.beginPath()
                    ctx.moveTo (canvas.width, 0)
                    ctx.lineTo (canvas.width - _diagA, _diagA)
                    ctx.stroke()
                }

                if (_diagB > 0 && canvas.width > 0) {
                    ctx.beginPath()
                    ctx.moveTo (0, 0)
                    ctx.lineTo (_diagB, _diagB)
                    ctx.stroke()
                }
            }

            /* Draw circle */
            else if (isNought) {
                var radius = item.width / 2
                var centerX = canvas.width / 2
                var centerY = canvas.height / 2

                if (radius > 0) {
                    ctx.beginPath()
                    ctx.arc (centerX, centerY, radius, 0, _angle)
                    ctx.stroke()
                }
            }
        }
    }
}
