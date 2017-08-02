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
    height: implicitHeight
    width: implicitWidth * 1.2
    parent: ApplicationWindow.overlay

    //
    // Opens the rate app link in Google Play
    //
    function openRate() {

    }

    //
    // Main layout
    //
    ColumnLayout {
        id: layout
        spacing: app.spacing
        Layout.fillWidth: true
        Layout.fillHeight: true
        anchors.centerIn: parent

        Label {
            font.bold: true
            font.pixelSize: 24
            Layout.fillWidth: true
            font.capitalization: Font.AllUppercase
            horizontalAlignment: Label.AlignHCenter
            text: qsTr ("%1 %2").arg (AppName).arg (Version)
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            opacity: 0.75
            font.pixelSize: 14
            Layout.fillWidth: true
            horizontalAlignment: Label.AlignHCenter
            text: qsTr ("Developed by %1").arg (Company)
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            opacity: 0.75
            font.pixelSize: 14
            Layout.fillWidth: true
            horizontalAlignment: Label.AlignHCenter
            text: qsTr ("Music by %1").arg ("Jake Chudnow")
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            text: qsTr ("Rate")
            onClicked: openRate()
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
