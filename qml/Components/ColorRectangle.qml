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

Rectangle {
       id: bg
       Component.onCompleted: updateColors()

       property int transitionTime: 5000
       property color horizonColor: randomColor (96)
       property color skyColor: Qt.lighter (horizonColor, 1.2)

       Behavior on skyColor { ColorAnimation {duration: bg.transitionTime} }
       Behavior on horizonColor { ColorAnimation {duration: bg.transitionTime} }

       function updateColors() {
           skyColor = Qt.lighter (horizonColor, 1.2)
           horizonColor = randomColor (96)
       }

       Timer {
           id: bgTimer
           repeat: true
           interval: bg.transitionTime
           onTriggered: bg.updateColors()
           Component.onCompleted: start()
       }

       gradient: Gradient {
           GradientStop {
               position: 0
               color: bg.skyColor
           }

           GradientStop {
               position: 1
               color: bg.horizonColor
           }
       }

       Rectangle {
           opacity: 0.2
           color: "#000000"
           anchors.fill: parent
       }
   }
