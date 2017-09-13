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

import Board 1.0

import "../Components"

Page {
    id: page

    //
    // Transparent background
    //
    background: Item {}

    //
    // Used to count the number of wins by each player
    //
    property int p1Wins: 0
    property int p2Wins: 0
    property int p1TotalWins: 0
    property int p2TotalWins: 0
    property string overlayTitle: ""

    //
    // Updates number of dots shown above and below the game board
    //
    function getScoreDifference() {
        while (p1Wins > 0 && p2Wins > 0) {
            --p1Wins
            --p2Wins
        }
    }

    //
    // Holds the number of games played, used to show
    // the interstital ad every x games
    //
    property int gamesPlayed: 0
    onGamesPlayedChanged: {
        if (gamesPlayed >= app.interstitialAdFreq) {
            gamesPlayed = 0
            app.showInterstitialAd()
        }
    }

    //
    // Disable AI when page is not visible
    //
    enabled: visible
    onEnabledChanged: {
        Board.resetBoard()

        if (enabled) {
            aiTimer.start()
            app.startNewGame()
        }

        else {
            p1Wins = 0
            p2Wins = 0
            p1TotalWins = 0
            p2TotalWins = 0
        }

        prompt.opacity = 0
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
    // Updates the win indicators
    //
    function updateScores() {
        board.clickableFields = Board.gameInProgress

        if (Board.gameWon) {
            if (Board.winner === TicTacToe.Player1) {
                ++p1TotalWins

                if (p2Wins > 0)
                    --p2Wins
                else
                    ++p1Wins
            }

            else if (Board.winner === TicTacToe.Player2) {
                ++p2TotalWins

                if (p1Wins > 0)
                    --p1Wins
                else
                    ++p2Wins
            }
        }

        getScoreDifference()
    }


    //
    // Make the computer move when the turn is changed
    //
    Connections {
        target: Board
        onBoardReset: makeAiMove()
        onTurnChanged: aiTimer.restart()
    }

    //
    // Waits a little before the CPU/AI makes a move
    //
    Timer {
        id: aiTimer
        interval: 520
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
    // Also, play sound effects when game is won or lost
    //
    Connections {
        target: Board
        onBoardReset: updateClickableFields()
        onTurnChanged: updateClickableFields()
        onGameStateChanged: {
            if (!page.enabled)
                return

            if (Board.gameWon) {
                if (Board.winner === AiPlayer.opponent)
                    app.playSoundEffect ("win")
                else
                    app.playSoundEffect ("loose")
            }

            if (Board.gameDraw)
                app.playSoundEffect ("loose")

            updateScores()
            updateClickableFields()
        }
    }

    //
    // Main layout
    //
    ColumnLayout {
        anchors.fill: parent
        anchors.centerIn: parent
        spacing: 2 * app.spacing
        anchors.margins: 2 * app.spacing

        Item {
            Layout.fillHeight: true
        }

        RowLayout {
            spacing: app.spacing
            Layout.fillHeight: false
            anchors.horizontalCenter: parent.horizontalCenter

            Cross {
                width: app.largeLabel * 0.75
                height: app.largeLabel * 0.75
                anchors.verticalCenter: parent.verticalCenter
            }

            Item {
                Layout.fillHeight: true
            }

            Label {
                font.pixelSize: app.largeLabel
                verticalAlignment: Label.AlignVCenter
                horizontalAlignment: Label.AlignHCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -1/6 * app.spacing
                text: app.getSymbol (TicTacToe.Player1) ? p1TotalWins : p2TotalWins
            }

            Label {
                text: " - "
                font.pixelSize: app.largeLabel
                verticalAlignment: Label.AlignVCenter
                horizontalAlignment: Label.AlignHCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -1/6 * app.spacing
            }

            Label {
                font.pixelSize: app.largeLabel
                verticalAlignment: Label.AlignVCenter
                horizontalAlignment: Label.AlignHCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -1/6 * app.spacing
                text: app.getSymbol (TicTacToe.Player2) ? p1TotalWins : p2TotalWins
            }

            Item {
                Layout.fillHeight: true
            }

            Nought {
                width: app.largeLabel * 0.75
                height: app.largeLabel * 0.75
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Dots {
            mirror: true
            highlightedDots: p1Wins
            Layout.fillHeight: false
        }

        Item {
            Layout.fillHeight: false
            Layout.preferredWidth: app.paneWidth * 0.85
            Layout.preferredHeight: app.paneWidth * 0.85
            anchors.horizontalCenter: parent.horizontalCenter

            GameBoard {
                id: board
                enabled: parent.visible
                anchors.centerIn: parent
                gridSize: parent.width - 2 * app.spacing
            }
        }

        Dots {
            highlightedDots: p2Wins
            Layout.fillHeight: false
        }

        Item {
            Layout.fillHeight: true
        }
    }

    //
    // Game ended magic
    //
    Overlay {
        id: prompt
        anchors.centerIn: parent

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
        // React on game events
        //
        Connections {
            target: Board
            onGameStateChanged: {
                if (!Board.gameInProgress && page.enabled)
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
                    logo.source = "qrc:/images/frown.svg"
                    overlayTitle = qsTr ("You lost the game!")
                }

                else {
                    logo.source = "qrc:/images/smile.svg"
                    overlayTitle = qsTr ("You won the game!")
                }
            }

            else if (Board.gameDraw) {
                logo.source = "qrc:/images/meh.svg"
                overlayTitle = qsTr ("Draw")
            }

            if (page.enabled) {
                anchors.verticalCenterOffset = 0
                opacity = Board.gameInProgress ? 0 : 1
            }

            else {
                hide()
                app.startNewGame()
            }
        }

        //
        // Main layout
        //
        contentData: ColumnLayout {
            spacing: app.spacing
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -1/2 * toolbar.height

            SvgImage {
                id: logo
                sourceSize: Qt.size (96, 96)
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                font.bold: true
                font.pixelSize: 28
                text: overlayTitle + Translator.dummy
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Item {
                Layout.fillHeight: true
                Layout.minimumHeight: 4 * app.spacing
            }

            Button {
                font.bold: true
                font.pixelSize: app.mediumLabel - 3
                Layout.preferredWidth: app.paneWidth
                anchors.horizontalCenter: parent.horizontalCenter

                text: qsTr ("New Game") + Translator.dummy

                onClicked: {
                    prompt.hide()
                    app.startNewGame()
                    app.playSoundEffect ("click")
                }
            }

            Item {
                Layout.preferredHeight: app.spacing * 2
            }

            Button {
                font.pixelSize: app.mediumLabel - 3
                Layout.preferredWidth: app.paneWidth
                text: qsTr ("Main Menu") + Translator.dummy
                anchors.horizontalCenter: parent.horizontalCenter

                onClicked: {
                    stack.pop()
                    prompt.hide()
                    app.playSoundEffect ("click")
                }
            }

            Button {
                font.pixelSize: app.mediumLabel - 3
                Layout.preferredWidth: app.paneWidth
                text: qsTr ("Settings") + Translator.dummy
                anchors.horizontalCenter: parent.horizontalCenter

                onClicked: {
                    settings.open()
                    app.playSoundEffect ("click")
                }
            }
        }
    }
}
