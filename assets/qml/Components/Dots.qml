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
import QtQuick.Controls 2.0

Row {
    property int maxDots: 3
    property bool mirror: false
    property int highlightedDots: 0
    property bool invertedText: false
    property int dots: Math.max (3, highlightedDots - 1)

    spacing: app.spacing * 2
    LayoutMirroring.enabled: mirror
    Layout.alignment: Qt.AlignHCenter

    Label {
        rotation: invertedText ? 180 : 0
        visible: highlightedDots > maxDots
        text: "+ " + (highlightedDots - maxDots)
        opacity: highlightedDots > maxDots ? 1 : 0
        Layout.alignment: Qt.AlignVCenter

        Behavior on opacity { NumberAnimation{} }
    }

    Repeater {
        model: Math.min (dots, maxDots)

        delegate: Rectangle {
            width: 12
            height: 12
            color: "#fff"
            radius: width / 2
            Behavior on opacity { NumberAnimation{} }
            opacity: highlightedDots > index ? 1 : 0.4
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
