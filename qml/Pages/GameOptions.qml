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

import Qt.labs.settings 1.0

import Board 1.0
import ComputerPlayer 1.0

Page {
    //
    // Custom properties
    //
    property bool showAiControls: false

    //
    // Signals
    //
    signal startGameClicked()

    //
    // Settings
    //
    Settings {
        category: "GameOptions"
        property alias aiStartsGame: _aiStartGame.checked
        property alias fieldsToAllign: _fielsToAllign.value
        property alias mapDimension: _dimension.currentIndex
        property alias aiDifficulty: _aiDifficulty.currentIndex
    }

    //
    // Changes the AI difficulty level by changing its
    // randomness index (which basically states how retard the
    // moves of the AI are)
    //
    function updateCpuDifficulty (difficulty) {
        if (difficulty === 0)
            AiPlayer.randomness = 5
        else if (difficulty === 1)
            AiPlayer.randomness = 2
        else if (difficulty === 2)
            AiPlayer.randomness = 1
        else if (difficulty === 3)
            AiPlayer.randomness = 0
    }

    //
    // Background pane
    //
    background: Pane {
        width: app.paneWidth
        height: app.paneHeight
        anchors.centerIn: parent
        Material.elevation: app.paneElevation
        Material.background: app.paneBackground

        //
        // Controls
        //
        ColumnLayout {
            spacing: app.spacing

            anchors {
                fill: parent
                centerIn: parent
                margins: app.spacing
            }

            Label {
                text: qsTr ("Map Dimension") + ":"
            }

            ComboBox {
                id: _dimension
                Layout.fillWidth: true
                model: ["3x3", "4x4", "5x5", "6x6"]
                Material.background: app.backgroundColor
                onCurrentIndexChanged: {
                    app.playSoundEffect ("click.wav")
                    Board.boardSize = currentIndex + 3
                }
            }

            Label {
                visible: showAiControls
                text: qsTr ("Computer Difficulty") + ":"
            }

            ComboBox {
                id: _aiDifficulty
                Layout.fillWidth: true
                enabled: showAiControls
                visible: showAiControls
                Material.background: app.backgroundColor

                model: [
                    qsTr ("Easy"),
                    qsTr ("Normal"),
                    qsTr ("Hard"),
                    qsTr ("Unbeatable"),
                ]

                currentIndex: 1
                onCurrentIndexChanged: {
                    updateCpuDifficulty (currentIndex)
                    app.playSoundEffect ("click.wav")
                }
            }

            Label {
                text: qsTr ("Fields to Allign") + ":"
            }

            SpinBox {
                id: _fielsToAllign
                from: 3
                value: from
                to: Board.boardSize
                Layout.fillWidth: true
                onValueChanged: {
                    Board.fieldsToAllign = value
                    app.playSoundEffect ("click.wav")
                }
            }

            Switch {
                id: _aiStartGame
                visible: showAiControls
                text: qsTr ("AI player starts game")

                onCheckedChanged: {
                    AiPlayer.player = checked ? TicTacToe.Player1 : TicTacToe.Player2
                }

                Component.onCompleted: {
                    AiPlayer.player = checked ? TicTacToe.Player1 : TicTacToe.Player2
                }
            }

            Item {
                Layout.fillHeight: true
            }

            Button {
                highlighted: true
                Layout.fillWidth: true
                text: qsTr ("Start Game")
                onClicked: {
                    updateCpuDifficulty (_aiDifficulty.currentIndex)
                    Board.boardSize = _dimension.currentIndex + 3
                    Board.fieldsToAllign = _fielsToAllign.value
                    startGameClicked()

                    app.playSoundEffect ("click.wav")
                }
            }
        }
    }
}
