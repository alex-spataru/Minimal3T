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

import "../Components"

Overlay {
    id: overlay

    contentData: ColumnLayout {
        id: layout
        spacing: app.spacing
        anchors.centerIn: parent

        Image {
            id: img
            source: "qrc:/images/logo.png"
            sourceSize: Qt.size (app.iconSize, app.iconSize)
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item {
            Layout.preferredHeight: app.spacing
        }

        Label {
            font.bold: true
            Layout.fillWidth: true
            font.pixelSize: app.largeLabel
            font.capitalization: Font.AllUppercase
            horizontalAlignment: Label.AlignHCenter
            text: qsTr ("%1 %2").arg (AppName).arg (Version)
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            opacity: 0.75
            Layout.fillWidth: true
            horizontalAlignment: Label.AlignHCenter
            onLinkActivated: Qt.openUrlExternally (link)
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr ("Developed by %1").arg ("<a href='https://github.com/alex-spataru/'>Alex Spataru</a>")
        }

        Label {
            opacity: 0.75
            Layout.fillWidth: true
            horizontalAlignment: Label.AlignHCenter
            onLinkActivated: Qt.openUrlExternally (link)
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr ("Music by %1").arg ("<a href='https://www.s-cheremisinov.com/'>Sergey Cheremisinov</a>")
        }

        Item {
            Layout.fillHeight: true
            Layout.minimumHeight: 2 * app.spacing
        }

        Button {
            text: qsTr ("Rate")
            Layout.fillWidth: true
            onClicked: app.openWebsite()
            Material.theme: Material.Light
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            Layout.fillWidth: true
            text: qsTr ("GitHub Project")
            Material.theme: Material.Light
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: Qt.openUrlExternally ("https://github.com/alex-spataru/SuperTac")
        }

        Button {
            Layout.fillWidth: true
            Material.theme: Material.Light
            text: qsTr ("Contact Developer")
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: Qt.openUrlExternally ("mailto:alex_spataru@outlook.com")
        }

        Item {
            Layout.fillHeight: true
            Layout.minimumHeight: 2 * app.spacing
        }

        Button {
            flat: true
            Layout.preferredWidth: app.paneWidth
            anchors.horizontalCenter: parent.horizontalCentercd

            RowLayout {
                spacing: app.spacing
                anchors.centerIn: parent

                SvgImage {
                    fillMode: Image.Pad
                    source: "qrc:/images/settings/back.svg"
                    verticalAlignment: Image.AlignVCenter
                    horizontalAlignment: Image.AlignHCenter
                    anchors.verticalCenter: parent.verticalCenter
                }

                Label {
                    text: qsTr ("Back")
                    font.capitalization: Font.AllUppercase
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            onClicked: {
                overlay.hide()
                app.playSoundEffect ("click.wav")
            }
        }
    }
}
