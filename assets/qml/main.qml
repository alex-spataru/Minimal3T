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
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Universal 2.0

import Board 1.0
import Qt.labs.settings 1.0

import "Pages" as Pages
import "Components"

ApplicationWindow {
    id: app

    //
    // Constants
    //
    readonly property int spacing: 8
    readonly property int pieceAnimation: 250
    readonly property int largeLabel: xLargeLabel * 2/3
    readonly property int mediumLabel: xLargeLabel * 1/2
    readonly property int iconSize: Math.min (128, height / 5)
    readonly property int paneWidth: Math.min (width * 0.9, 512)
    readonly property int xLargeLabel: Math.min (font.pixelSize * 2.5,
                                                 Math.max (height / 14,
                                                           font.pixelSize * 2))

    //
    // Aliases
    //
    property alias randomMelodies: ui.randomMelodies
    property alias showBoardMargins: ui.showAllBorders
    property alias backgroundGradient: ui.backgroundGradient
    property alias enableWinLoseSounds: ui.enableWinLoseSounds

    //
    // Theme options
    //
    readonly property string fieldColor: "#ffffff"
    readonly property string accentColor: "#d93344"
    readonly property string primaryColor: "#5486d1"
    readonly property string paneBackground: "#25232e"
    readonly property string backgroundColor: "#1f1c23"

    //
    // Return a specific 'website' link for each platform
    //
    readonly property string website: {
        if (Qt.platform.os === "android")
            return "market://details?id=org.alexspataru.supertac"

        return "https://alex-spataru.github.io/Minimal3T"
    }

    //
    // Function aliases
    //
    function playSoundEffect (effect) { audioPlayer.playSoundEffect (effect) }

    //
    // Returns true if we should display a nought for the given player
    //
    function useNought (player) {
        if (player === TicTacToe.Player1)
            return ui.useNought

        return !ui.useNought
    }

    //
    // Prompts the user to buy the ad-free version of the app
    //
    function removeAds() {
        function premiumAppLink() {
            if (Qt.platform.os === "android")
                return "market://details?id=org.alexspataru.supertacpremium"

            return "https://alex-spataru.github.io/Minimal3T/"
        }

        Qt.openUrlExternally (premiumAppLink())
    }

    //
    // Starts a new game
    //
    function startNewGame() {
        Board.resetBoard()
        Board.currentPlayer = ui.humanFirst ? TicTacToe.Player1 :
                                              TicTacToe.Player2
    }

    //
    // Opens the rate app link in Google Play
    //
    function openWebsite() {
        Qt.openUrlExternally (app.website)
    }

    //
    // Load fonts
    //
    FontLoader { source: "qrc:/fonts/Raleway-Light.ttf" }
    FontLoader { source: "qrc:/fonts/Raleway-ExtraLight.ttf" }
    FontLoader { id: regular; source: "qrc:/fonts/Raleway-Regular.ttf" }

    //
    // Window options
    //
    width: 320
    height: 533
    visible: true
    title: qsTr ("Minimal3T") + Translator.dummy

    //
    // Material theme options
    //
    Material.theme: Material.Dark
    Material.accent: accentColor
    Material.primary: primaryColor
    Material.background: backgroundColor

    //
    // Universal theme options
    //
    Universal.theme: Universal.Dark
    Universal.accent: accentColor

    //
    // Configure font
    //
    font.family: regular.name
    font.pixelSize: Math.min (Math.max (14, app.height / 34), 22)

    //
    // Background rectangle
    //
    color: "#000"
    background: ColorRectangle {
        anchors.fill: parent
    }

    //
    // Close overlays or decrease stack depth before closing the application
    // This allows the Android user to use the back button to navigate the UI
    //
    onClosing: close.accepted = ui.checkStackDepth()

    //
    // Show window on launch
    //
    Component.onCompleted: {
        if (Qt.platform === "android")
            showMaximized()
        else
            showNormal()
    }

    //
    // Save window geometry
    //
    Settings {
        category: "Window"
        property alias wX: app.x
        property alias wY: app.y
        property alias wWidth: app.width
        property alias wHeight: app.height
    }

    //
    // UI elements
    //
    UI {
        id: ui
        anchors.fill: parent
    }

    //
    // Rate page
    //
    Pages.Rate {
        id: ratePage
        anchors.centerIn: parent
    }

    //
    // Audio player
    //
    AudioPlayer {
        id: audioPlayer
        enableMusic: ui.enableMusic
        enableSoundEffects: ui.enableSoundEffects
    }
}
