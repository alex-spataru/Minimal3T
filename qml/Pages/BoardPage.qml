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

import Board 1.0
import ComputerPlayer 1.0

import "../Components"

Page {
    id: page

    //
    // Custom properties
    //
    property int consecutivePlays: 0
    property bool startNewGamesAutomatically: true
    property alias enableAiVsHuman: _board.enableAiVsHuman

    //
    // Score count
    //
    property var draws: 0
    property var p1Wins: 0
    property var p2Wins: 0

    //
    // Clears the game board and starts a new game
    //
    function startNewGame() {
        if (consecutivePlays < 2)
            ++consecutivePlays

        else {
            consecutivePlays = 0
            app.showInterstitialAd()
        }

        drawDialog.close()
        gameWonDialog.close()

        Board.resetBoard()
    }

    //
    // Resets the scores to 0
    //
    function resetScores() {
        draws = 0
        p1Wins = 0
        p2Wins = 0
    }

    //
    // Returns the user to the main menu and clears score counts
    //
    function goToMainMenu() {
        resetScores()
        drawDialog.close()
        gameWonDialog.close()

        _stack.pop()
        _stack.pop()
    }

    //
    // Show dialogs and prompts when the game ends
    //
    Connections {
        target: Board
        onGameStateChanged: {
            if (!Board.gameInProgress)
                dialogTimer.start()

            if (Board.gameWon) {
                /* AI won, play loose sound */
                if (enableAiVsHuman && Board.winner === AiPlayer.player)
                    app.playSoundEffect ("loose.wav")

                /* Human won, play win sound */
                else
                    app.playSoundEffect ("win.wav")

                /* Update score counters */
                if (Board.winner === TicTacToe.Player1)
                    ++p1Wins
                else if (Board.winner === TicTacToe.Player2)
                    ++p2Wins
            }

            if (Board.gameDraw) {
                ++draws
                app.playSoundEffect ("loose.wav")
            }
        }
    }

    //
    // Waits for the user to see what happened and
    // show the dialogs (or restarts the games directly)
    //
    Timer {
        id: dialogTimer
        interval: 1680
        onTriggered: {
            if (startNewGamesAutomatically)
                startNewGame()

            else if (Board.gameWon)
                gameWonDialog.open()

            else if (Board.gameDraw)
                drawDialog.open()
        }
    }

    //
    // Game board
    //
    GameBoard {
        id: _board
        enabled: parent.visible
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -1/3 * (_scores.height)
    }

    //
    // Scores
    //
    GridLayout {
        id: _scores
        rows: 2
        columns: 3
        rowSpacing: app.spacing
        columnSpacing: 3 * app.spacing

        anchors {
            top: _board.bottom
            topMargin: 2 * app.spacing
            horizontalCenter: parent.horizontalCenter
        }

        Label {
            font.bold: true
            text: app.p1Symbol
            font.pixelSize: 32
            Layout.fillWidth: true
            color: Material.primary
            verticalAlignment: Label.AlignVCenter
            horizontalAlignment: Label.AlignHCenter
        }

        Label {
            font.bold: true
            font.pixelSize: 24
            text: qsTr ("Ties")
            Layout.fillWidth: true
            verticalAlignment: Label.AlignVCenter
            horizontalAlignment: Label.AlignHCenter
        }

        Label {
            font.bold: true
            text: app.p2Symbol
            font.pixelSize: 32
            color: Material.accent
            Layout.fillWidth: true
            verticalAlignment: Label.AlignVCenter
            horizontalAlignment: Label.AlignHCenter
        }

        Label {
            text: p1Wins
            font.pixelSize: 20
            Layout.fillWidth: true
            verticalAlignment: Label.AlignVCenter
            horizontalAlignment: Label.AlignHCenter
        }

        Label {
            text: draws
            font.pixelSize: 20
            Layout.fillWidth: true
            verticalAlignment: Label.AlignVCenter
            horizontalAlignment: Label.AlignHCenter
        }

        Label {
            text: p2Wins
            font.pixelSize: 20
            Layout.fillWidth: true
            verticalAlignment: Label.AlignVCenter
            horizontalAlignment: Label.AlignHCenter
        }
    }

    //
    // Draw message dialog
    //
    Dialog {
        id: drawDialog
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        modal: true
        title: qsTr ("It's a Draw!")
        parent: ApplicationWindow.overlay
        standardButtons: Dialog.Yes | Dialog.No

        onAccepted: startNewGame()
        onRejected: goToMainMenu()

        Column {
            spacing: app.spacing
            anchors.fill: parent

            Label {
                text: qsTr ("Would you like to play another game?")
            }
        }
    }

    //
    // Game won message dialog
    //
    Dialog {
        id: gameWonDialog
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        modal: true
        parent: ApplicationWindow.overlay
        standardButtons: Dialog.Yes | Dialog.No

        onAccepted: startNewGame()
        onRejected: goToMainMenu()

        Connections {
            target: Board
            onWinnerChanged: {
                var winner = ""

                if (Board.winner === TicTacToe.Player1)
                    winner = "1"

                else if (Board.winner === TicTacToe.Player2)
                    winner = "2"

                gameWonDialog.title = qsTr ("Player %1 won!").arg (winner)
            }
        }

        Column {
            spacing: app.spacing
            anchors.fill: parent

            Label {
                text: qsTr ("Would you like to play another game?")
            }
        }
    }

    //
    // AI thinking popup
    //
    Popup {
        id: dialog
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        modal: true
        closePolicy: Popup.NoAutoClose
        parent: ApplicationWindow.overlay

        Connections {
            target: Board
            onTurnChanged: timer.start()
        }

        Timer {
            id: timer
            interval: 2000
            onTriggered: {
                if (Board.gameInProgress && page.enabled) {
                    if (enableAiVsHuman && Board.currentPlayer === AiPlayer.player)
                        dialog.open()
                    else
                        dialog.close()
                }
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.centerIn: parent

            BusyIndicator {
                running: true
            }

            Label {
                text: qsTr ("AI is thinking") + "..."
            }
        }
    }
}
