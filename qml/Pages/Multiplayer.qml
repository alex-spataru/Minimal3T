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
    // Transparent bacground
    //
    background: Item {}

    //
    // Holds the number of games played, used to show
    // the interstital ad every three games
    //
    property int gamesPlayed: 0
    onGamesPlayedChanged: {
        if (gamesPlayed >= 3) {
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

        if (enabled)
            app.startNewGame()

        else {
            p1Wins = 0
            p2Wins = 0
            p1TotalWins = 0
            p2TotalWins = 0
            numberOfGames = 3
        }
    }

    //
    // Used to count the number of wins by each player
    //
    property int p1Wins: 0
    property int p2Wins: 0
    property int p1TotalWins: 0
    property int p2TotalWins: 0
    property int numberOfGames: 3

    //
    // Updates number of dots shown above and below the game board
    //
    function updateNumberOfGames() {
        while (p1Wins > 0 && p2Wins > 0) {
            --p1Wins
            --p2Wins
        }

        numberOfGames = Math.max (Math.max (p1Wins, p2Wins) + 1, 3)
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

        if (!Board.gameInProgress) {
            ++gamesPlayed
            Board.resetBoard()
        }

        updateNumberOfGames()
    }

    //
    // React to game events
    //
    Connections {
        target: Board
        onBoardReset: board.clickableFields = Board.gameInProgress
        onGameStateChanged: {
            if (!page.enabled)
                return

            if (!Board.gameInProgress)
                timer.start()

            if (Board.gameWon)
                app.playSoundEffect ("win.wav")

            else if (Board.gameDraw)
                app.playSoundEffect ("loose.wav")
        }
    }

    //
    // Waits a little before starting a new game
    //
    Timer {
        id: timer
        interval: 1680
        onTriggered: updateScores()
    }

    //
    // Main layout
    //
    ColumnLayout {        
        spacing: 3 * app.spacing
        anchors.centerIn: parent

        //
        // Spacer
        //
        Item {
            Layout.preferredHeight: 0
        }

        //
        // Score indicator
        //
        RowLayout {
            spacing: app.spacing
            anchors.horizontalCenter: parent.horizontalCenter

            SvgImage {
                sourceSize: Qt.size (36, 36)
                source: app.getSymbol (TicTacToe.Player1)
                anchors.verticalCenter: parent.verticalCenter
            }

            Label {
                font.bold: true
                text: p1TotalWins
                font.pixelSize: 24
                verticalAlignment: Label.AlignVCenter
                horizontalAlignment: Label.AlignHCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            Label {
                text: " - "
                font.bold: true
                font.pixelSize: 24
                verticalAlignment: Label.AlignVCenter
                horizontalAlignment: Label.AlignHCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            Label {
                font.bold: true
                text: p2TotalWins
                font.pixelSize: 24
                verticalAlignment: Label.AlignVCenter
                horizontalAlignment: Label.AlignHCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            SvgImage {
                sourceSize: Qt.size (36, 36)
                source: app.getSymbol (TicTacToe.Player2)
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        //
        // Spacer
        //
        Item {
            Layout.preferredHeight: 0
        }

        //
        // P1 points
        //
        Row {
            spacing: app.spacing * 2
            LayoutMirroring.enabled: true
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: numberOfGames
                delegate: Rectangle {
                    width: 12
                    height: 12
                    color: "#fff"
                    radius: width / 2
                    opacity: p1Wins > index ? 1 : 0.4
                    Behavior on opacity { NumberAnimation{} }
                }
            }
        }

        //
        // Game board
        //
        GameBoard {
            id: board
            enabled: parent.visible
            anchors.horizontalCenter: parent.horizontalCenter
        }

        //
        // P2 points
        //
        Row {
            spacing: app.spacing * 2
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: numberOfGames
                delegate: Rectangle {
                    width: 12
                    height: 12
                    color: "#fff"
                    radius: width / 2
                    opacity: p2Wins > index ? 1 : 0.4
                    Behavior on opacity { NumberAnimation{} }
                }
            }
        }

        //
        // Banner spacer
        //
        Item {
            height: bannerContainer.height - parent.spacing
        }
    }
}
