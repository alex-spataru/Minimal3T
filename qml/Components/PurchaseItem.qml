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
import QtQuick.Controls.Material 2.0

ColumnLayout {
    property string price
    property alias text: label.text
    property alias icon: image.source
    property string buttonText: qsTr ("Purchase")

    signal purchase

    onTextChanged: updateCaption()
    onPriceChanged: updateCaption()

    opacity: enabled ? 1 : 0.4
    Layout.preferredWidth: image.sourceSize.width * 2

    function updateCaption() {
        button.text = buttonText
        if (price.length > 0)
            button.text += " (" + price + ")"
    }

    Image {
        id: image
        sourceSize: Qt.size (48, 48)
        source: "qrc:/images/monetization.svg"
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Label {
        id: label
        font.bold: true
        font.pixelSize: 18
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Button {
        id: button
        onClicked: purchase()
        enabled: parent.enabled
        Material.theme: Material.Light
        Layout.preferredWidth: image.sourceSize.width * 2
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
