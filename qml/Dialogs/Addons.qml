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
    modal: true
    title: qsTr ("Addons")
    width: implicitWidth * 1.2
    standardButtons: Dialog.Close
    parent: ApplicationWindow.overlay

    //
    // Main layout
    //
    ColumnLayout {
        id: layout
        spacing: app.spacing
        anchors.fill: parent
        anchors.centerIn: parent

        //
        // Pledge label
        //
        Label {
            font.pixelSize: 13
            Layout.preferredWidth: app.paneWidth * 0.75
            wrapMode: Label.WrapAtWordBoundaryOrAnywhere
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr ("%1 is open-source software, you can support it " +
                        "by purchasing one or more of the available addons!").arg (AppName)
        }

        //
        // Spacer
        //
        Item {
            Layout.fillHeight: true
            Layout.preferredHeight: 2 * app.spacing
        }

        //
        // Available items for purchase
        //
        RowLayout {
            spacing: app.spacing
            Layout.fillWidth: true
            Layout.fillHeight: true
            anchors.horizontalCenter: parent.horizontalCenter

            PurchaseItem {
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: qsTr ("Remove Ads")
                icon: "qrc:/images/monetization.svg"
            }

            PurchaseItem {
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: qsTr ("Donation")
                buttonText: qsTr ("Donate")
                icon: "qrc:/images/donate.svg"
            }
        }
    }
}
