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

Page {
    id: page

    //
    // Transparent background
    //
    background: Item {}

    //
    // Holds the number of games played, used to show
    // the interstital ad every three games
    //
    property int gamesPlayed: 0
    onGamesPlayedChanged: {
        if (gamesPlayed >= 2) {
            gamesPlayed = 0
            app.showInterstitialAd()
        }
    }

    //
    // Disable AI when page is not visible
    //
    enabled: visible
    onEnabledChanged: {
        if (enabled) {
            aiTimer.start()
            app.startNewGame()
        }
    }

    //
    // Decides which AI should make a move
    //
    function makeAiMove() {
        if (!page.enabled)
            return

        if (Board.gameInProgress && Board.currentPlayer === AiPlayer.player)
            AiPlayer.makeMove()
    }

    //
    // Make the computer move when the turn is changed
    //
    Connections {
        target: Board
        enabled: page.visible
        onBoardReset: makeAiMove()
        onTurnChanged: aiTimer.restart()
    }

    //
    // Waits a little before the CPU/AI makes a move
    //
    Timer {
        id: aiTimer
        interval: 320
        onTriggered: makeAiMove()
    }

    //
    // Enables or disables human interacion based on board state and game conditions
    //
    function updateClickableFields() {
        if (Board.gameInProgress && Board.currentPlayer === AiPlayer.opponent)
            board.clickableFields = true
        else
            board.clickableFields = false
    }

    //
    // Do not allow the human player to change field states when
    // the AI is thinking or when the game has ended
    //
    Connections {
        target: Board
        onBoardReset: updateClickableFields()
        onTurnChanged: updateClickableFields()
        onGameStateChanged: {
            if (!Board.gameInProgress) {
                if (Board.winner === AiPlayer.opponent)
                    app.playSoundEffect ("win.wav")
                else
                    app.playSoundEffect ("loose.wav")
            }

            updateClickableFields()
        }
    }

    //
    // Game board
    //
    GameBoard {
        id: board
        enabled: parent.visible
        anchors.centerIn: parent
    }

    //
    // Game ended magic
    //
    Item {
        id: prompt
        opacity: 0
        visible: opacity > 0
        enabled: opacity > 0
        width: 2 * app.width
        height: 2 * app.height
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -1/2 * toolbar.height

        //
        // Background rectangle
        //
        Rectangle {
            color: "#000"
            opacity: 0.85
            anchors.fill: parent
        }

        //
        // Waits for the user to process the game events
        // before showing this prompt
        // In other words, let the user know he/she fucked up
        // by him/herself
        //
        Timer {
            id: timer
            interval: 1680
            onTriggered: prompt.display()
        }

        //
        // Quick and dirty hack to display all other clickable
        // controls
        //
        MouseArea {
            anchors.fill: parent
            enabled: parent.opacity > 0
        }

        //
        // React on game events
        //
        Connections {
            target: Board
            enabled: page.visible
            onGameStateChanged: {
                if (!Board.gameInProgress)
                    timer.start()
            }
        }

        //
        // Updates the title label and displays/hides
        // the overlay
        //
        function display() {
            ++gamesPlayed
            if (Board.gameWon) {
                if (Board.winner === AiPlayer.player) {
                    logo.source = "qrc:/images/loose.svg"
                    title.text = qsTr ("You lost the game!")
                }

                else {
                    logo.source = "qrc:/images/win.svg"
                    title.text = qsTr ("You won the game!")
                }
            }

            else if (Board.gameDraw) {
                title.text = qsTr ("Game Draw")
                logo.source = "qrc:/images/draw.svg"
            }

            if (!settingsDlg.autoStartGames)
                opacity = Board.gameInProgress ? 0 : 1

            else {
                opacity = 0
                app.startNewGame()
            }
        }

        //
        // Enable the nice fading effect
        //
        Behavior on opacity { NumberAnimation{} }

        //
        // Main layout
        //
        ColumnLayout {
            spacing: app.spacing
            anchors.centerIn: parent

            Image {
                id: logo
                sourceSize: Qt.size (96, 96)
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                id: title
                font.bold: true
                font.pixelSize: 24
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                font.pixelSize: 18
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr ("Would you like to play another game?")
            }

            Item {
                Layout.fillHeight: true
                Layout.minimumHeight: 4 * app.spacing
            }

            Button {
                font.bold: true
                text: qsTr ("Yes")
                font.pixelSize: 18
                Material.theme: Material.Light
                Layout.preferredWidth: app.paneWidth
                anchors.horizontalCenter: parent.horizontalCenter

                onClicked: {
                    app.startNewGame()
                    prompt.opacity = 0
                }
            }

            Button {
                font.pixelSize: 16
                Material.theme: Material.Light
                text: qsTr ("No, go to main menu")
                Layout.preferredWidth: app.paneWidth
                anchors.horizontalCenter: parent.horizontalCenter

                onClicked: {
                    stack.pop()
                    prompt.opacity = 0
                }
            }

            Item {
                Layout.preferredWidth: app.spacing * 2
            }

            Button {
                font.pixelSize: 16
                text: qsTr ("Game Options")
                Material.theme: Material.Light
                onClicked: gameOptionsDlg.open()
                Layout.preferredWidth: app.paneWidth
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

    }
}
