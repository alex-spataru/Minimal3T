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

import "../Components"

Item {
    opacity: 0
    visible: opacity > 0
    enabled: opacity > 0
    anchors.verticalCenterOffset: app.height

    property alias contentData: _data.data
    Behavior on opacity { NumberAnimation{} }
    Behavior on anchors.verticalCenterOffset { NumberAnimation{} }

    function open() {
        opacity = 1
        anchors.verticalCenterOffset = 0
    }

    function hide() {
        opacity = 0
        anchors.verticalCenterOffset = app.height
    }

    Item {
        opacity: 0.90
        width: 2 * app.width
        height: 2 * app.height
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -1/2 * toolbar.height

        Rectangle {
            color: "#000"
            anchors.fill: parent
        }

        MouseArea {
            anchors.fill: parent
        }
    }

    ColumnLayout {
        anchors.centerIn: parent

        Item {
            id: _data
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Item {
            Layout.fillWidth: true
            visible: app.adsEnabled
            height: app.bannerHeight
        }
    }
}
