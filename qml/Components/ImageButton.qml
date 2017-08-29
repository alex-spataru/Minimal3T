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

Item {
    id: button

    signal clicked
    property var btSize: 81
    property alias font: label.font
    property alias text: label.text
    property alias source: image.source

    Layout.fillWidth: btSize === 0
    Layout.preferredWidth: btSize > 0 ? btSize : 81
    Layout.preferredHeight: btSize > 0 ? btSize : 81

    onClicked: app.playSoundEffect ("qrc:/sounds/effects/click.wav")

    MouseArea {
        anchors.fill: parent
        onClicked: button.clicked()
    }

    ColumnLayout {
        spacing: app.spacing
        anchors.centerIn: parent

        SvgImage {
            id: image
            fillMode: Image.Pad
            verticalAlignment: Image.AlignVCenter
            horizontalAlignment: Image.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            id: label
            visible: text.length > 0
            Layout.preferredWidth: btSize
            font.pixelSize: app.font.pixelSize - 5
            horizontalAlignment: Label.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
