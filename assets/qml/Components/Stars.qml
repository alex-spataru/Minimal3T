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

//
// Based on the work found at: https://codepen.io/easymac/pen/EJHDj?page=1&
//
Canvas {
    id: canvas

    property var stars: []
    property var density: 5
    property var verticalSpeed: 0
    property var horizontalSpeed: 0

    onWidthChanged: makeStars (density)
    onHeightChanged: makeStars (density)
    Component.onCompleted: makeStars (density)

    Timer {
        repeat: true
        interval: 20
        Component.onCompleted: start()
        onTriggered: {
            canvas.updateStars()
            canvas.requestPaint()
        }
    }

    MouseArea {
        id: mouse
        hoverEnabled: true
        anchors.fill: parent
    }

    function makeStars (density) {
        var sortable = []
        var randomX, randomY, randomZ
        var totalStars = Math.floor (canvas.width / 72) * Math.floor (canvas.height / 72) * density

        for (var i = 0; i < totalStars; ++i) {
            randomX = Math.random() * (canvas.width - 1) + 1;
            randomY = Math.random() * (canvas.height - 1) + 1;
            randomZ = Math.random() * 5;
            stars[i] = [randomX, randomY, randomZ];
            sortable.push (randomZ);
        }

        sortable.sort()

        for (var x in stars) {
            stars [x][2] = sortable [x]
        }
    }

    function updateStars() {
        for (var i in stars) {
            stars[i][0] += horizontalSpeed * stars[i][2] / 10;
            stars[i][1] += verticalSpeed * stars[i][2] / 10;

            if (stars[i][0] >= canvas.width) {
                stars[i][0] = -5;
            }
            if (stars[i][1] >= canvas.height) {
                stars[i][1] = -5;
            }
            if (stars[i][0] < -6) {
                stars[i][0] = canvas.width;
            }
            if (stars[i][1] < -6) {
                stars[i][1] = canvas.height;
            }
        }
    }

    onPaint: {
        var context = canvas.getContext ("2d")
        context.clearRect (0, 0, canvas.width, canvas.height)
        context.fillStyle = "#FF0000"

        for (var i in stars) {
            context.fillStyle = "#fff"
            context.fillRect (stars [i][0], stars [i][1], stars [i][2], stars [i][2])
        }

        updateStars()
    }
}
