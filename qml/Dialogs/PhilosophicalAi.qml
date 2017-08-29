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

Popup {
    id: popup
    x: (app.width - width) / 2
    y: (app.height - height) / 2
    closePolicy: Popup.NoAutoClose

    property bool enableDialog: false

    function aiThinking() {
        if (popup.enableDialog)
            if (Board.currentPlayer === AiPlayer.player && Board.gameInProgress)
                return true

        return false
    }

    Connections {
        target: Board
        onTurnChanged: {
            if (popup.aiThinking())
                philosophicalTimer.start()
            else {
                popup.close()
                philosophicalTimer.stop()
            }
        }
    }

    Timer {
        interval: 1000
        id: philosophicalTimer
        onTriggered: {
            if (popup.aiThinking())
                popup.open()
            else
                popup.close()
        }
    }

    contentItem: RowLayout {
        spacing: app.spacing

        BusyIndicator {
            anchors.verticalCenter: parent.verticalCenter
        }

        Label {
            Layout.fillWidth: true
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr ("AI is thinking") + "..." + Translator.dummy
        }
    }
}
