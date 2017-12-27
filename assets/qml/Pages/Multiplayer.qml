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
        }
    }

    //
    // Used to count the number of wins by each player
    //
    property int p1Wins: 0
    property int p2Wins: 0

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
    // Updates the win indicators
    //
    function updateScores() {
        board.clickableFields = Board.gameInProgress

        if (Board.gameWon) {
            if (Board.winner === TicTacToe.Player1) {
                if (p2Wins > 0)
                    --p2Wins
                else
                    ++p1Wins
            }

            else if (Board.winner === TicTacToe.Player2) {
                if (p1Wins > 0)
                    --p1Wins
                else
                    ++p2Wins
            }
        }

        if (!Board.gameInProgress) {
            app.showInterstitialAd()
            Board.resetBoard()
        }

        getScoreDifference()
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
                app.playSoundEffect ("win")

            else if (Board.gameDraw)
                app.playSoundEffect ("loose")
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
        anchors.fill: parent
        anchors.centerIn: parent
        spacing: 2 * app.spacing
        anchors.margins: 2 * app.spacing

        Item {
            Layout.fillHeight: true
        }

        Dots {
            mirror: true
            invertedText: true
            highlightedDots: p1Wins
            Layout.fillHeight: false
        }

        Item {
            Layout.fillHeight: false
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.preferredWidth: board.gridSize + 2 * app.spacing
            Layout.preferredHeight: board.gridSize + 2 * app.spacing

            GameBoard {
                id: board
                enabled: parent.visible
                anchors.centerIn: parent
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
}
