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
    property int to: 0
    property int from: 0
    property int value: 0
    property var model: [""]
    property alias title: title.text
    readonly property alias text: currentText.text
    property size iconSize: Qt.size (app.font.pixelSize * 2,
                                     app.font.pixelSize * 2)

    Connections {
        target: Translator
        onLanguageChanged: currentText.text = model [value - from]
    }

    function updateModel() {
        if (to > 0 && from > 0) {
            model = []
            for (var i = from; i <= to; ++i)
                model.push (i.toString())

            if (value > to)
                value = to
            if (value < from)
                value = from
        }

        else {
            from = 0
            to = model.length - 1
        }

        currentText.text = model [value - from]
    }

    onToChanged: updateModel()
    onFromChanged: updateModel()
    onValueChanged: currentText.text = model [value - from]

    Component.onCompleted: updateModel()
    Layout.preferredHeight: layout.implicitHeight

    ColumnLayout {
        id: layout
        anchors.centerIn: parent

        Label {
            id: title
            visible: text.length > 0
            font.pixelSize: app.largeLabel * 2/3
            anchors.horizontalCenter: parent.horizontalCenter
        }

        RowLayout {
            spacing: app.spacing
            Layout.fillWidth: true
            Layout.minimumWidth: 160

            SvgImage {
                sourceSize: iconSize
                opacity: value > from ? 1 : 0.2
                source: "qrc:/images/chevron-left.svg"
                anchors.verticalCenter: parent.verticalCenter

                Behavior on opacity { NumberAnimation{} }

                MouseArea {
                    onClicked: {
                        if (value > from)
                            --value
                    }

                    anchors.fill: parent
                    enabled: parent.opacity == 1
                }
            }

            Label {
                id: currentText
                Layout.fillWidth: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            SvgImage {
                sourceSize: iconSize
                opacity: value < to ? 1 : 0.4
                source: "qrc:/images/chevron-right.svg"
                anchors.verticalCenter: parent.verticalCenter

                Behavior on opacity { NumberAnimation{} }

                MouseArea {
                    onClicked: {
                        if (value < to)
                            ++value
                    }

                    anchors.fill: parent
                    enabled: parent.opacity == 1
                }
            }
        }
    }
}
