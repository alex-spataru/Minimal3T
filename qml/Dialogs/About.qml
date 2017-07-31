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
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.0

import "../Components"

Dialog {
    //
    // Center dialog on application window
    //
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    //
    // Dialog options
    //
    title: ""
    modal: true
    parent: ApplicationWindow.overlay
    width: layout.implicitWidth * 1.3

    //
    // Main layout
    //
    ColumnLayout {
        id: layout
        spacing: app.spacing
        Layout.fillWidth: true
        Layout.fillHeight: true
        anchors.centerIn: parent

        Logo {
            width: 128
            height: 128
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            text: qsTr ("%1 v%2").arg (AppName).arg (Version)
            font.bold: true
            font.pixelSize: 24
            Layout.fillWidth: true
            horizontalAlignment: Label.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            font.pixelSize: 16
            Layout.fillWidth: true
            horizontalAlignment: Label.AlignHCenter
            text: qsTr ("Developed by %1").arg (Company)
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            text: qsTr ("Credits")
            Layout.fillWidth: true
            Material.theme: Material.Light
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            Layout.fillWidth: true
            text: qsTr ("Report Issues")
            Material.theme: Material.Light
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            Layout.fillWidth: true
            text: qsTr ("Contact Developer")
            Material.theme: Material.Light
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
