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

import QtMultimedia 5.0
import com.dreamdev.QtAdMobBanner 1.0
import com.dreamdev.QtAdMobInterstitial 1.0

import "Pages" as Pages
import "Dialogs" as Dialogs

ApplicationWindow {
    id: app

    //
    // Custom properties
    //
    readonly property int spacing: 8
    property alias caption: _title.text

    //
    // Set game symbols
    //
    readonly property string p1Symbol: "X"
    readonly property string p2Symbol: "O"
    readonly property alias symbolFont: _loader.name

    //
    // Theme options
    //
    readonly property string borderColor: "#2f2e34"
    readonly property string primaryColor: "#5486d1"
    readonly property string secondaryColor: "#d93344"
    readonly property string paneBackground: "#25232e"
    readonly property string backgroundColor: "#1f1c23"

    //
    // Pane properties
    //
    readonly property int paneElevation: 6
    readonly property int paneWidth: Math.min (_stack.width - 2 * spacing, 520)
    readonly property int paneHeight: Math.min (_stack.height - 2 * spacing, 520)

    //
    // Generates a dynamic SoundEffect item to play the given audio file
    //
    function playSoundEffect (effect) {
        if (_settings.enableSoundEffects && app.visible) {
            var source = "qrc:/sounds/" + effect
            var qmlSourceCode = "import QtQuick 2.0;" +
                    "import QtMultimedia 5.0;" +
                    "SoundEffect {" +
                    "   source: \"" + source + "\";" +
                    "   volume: 0.40; " +
                    "   Component.onCompleted: play(); " +
                    "   onPlayingChanged: if (!playing) destroy (100); }"
            Qt.createQmlObject (qmlSourceCode, app, "SoundEffects")
        }
    }

    //
    // Displays the interstitial ad (if its loaded)
    //
    function showInterstitialAd() {
        if (_interstitial.isLoaded)
            _interstitial.visible = true
    }

    //
    // Window options
    //
    width: 340
    height: 520
    visible: true
    title: AppName

    //
    // Theme options
    //
    Material.theme: Material.Dark
    Material.primary: primaryColor
    Material.accent: secondaryColor
    Material.background: backgroundColor

    //
    // Re-position the banner ad when window size is changed
    //
    onWidthChanged: _banner.locateBanner()
    onHeightChanged: _banner.locateBanner()

    //
    // Pause audio when window is not visible (very important on Android!)
    //
    onVisibleChanged: {
        if (app.active)
            _player.playMusic()
        else
            _player.pause()
    }

    //
    // React on back key
    //
    onClosing: {
        if (Qt.platform.os == "android") {
            if (_stack.depth > 1) {
                _stack.pop()
                playSoundEffect ("click.wav")
                close.accepted = false
            }

            else
                close.accepted = true
        }
    }

    //
    // Load the font used to display the cross/nough symbols
    //
    FontLoader {
        id: _loader
        source: "qrc:/fonts/UbuntuMono-R.ttf"
    }

    //
    // Soundtrack list
    //
    ListModel {
        id: model
        property int track: -1

        ListElement {
            artist: "Sam Kuzel"
            title: "William Alone"
            source: "SamKuzel-WilliamAlone.ogg"
        }

        ListElement {
            artist: "HolFix"
            title: "Mistery"
            source: "HolFix-Mistery.ogg"
        }
    }

    //
    // Music player
    //
    Audio {
        id: _player

        function playMusic() {
            if (_settings.enableMusic && app.active)
                play()
            else
                stop()
        }

        function updateTrack() {
            if (model.track == -1)
                model.track = Math.random() * model.count

            if (model.track < model.count - 1)
                ++model.track
            else
                model.track = 0

            source = "qrc:/music/" + model.get (model.track).source

            if (_settings.enableMusic)
                play()
        }

        volume: 0.8
        onStopped: updateTrack()
        Component.onCompleted: updateTrack()
    }

    //
    // Toolbar and navigation controls
    //
    header: ToolBar {
        Material.background: app.paneBackground

        contentItem: RowLayout {
            Behavior on spacing { NumberAnimation{} }
            spacing: _stack.depth > 1 ? app.spacing / 2 : app.spacing * 3/2

            ToolButton {
                opacity: enabled ? 1 : 0
                enabled: _stack.depth > 1
                Layout.preferredWidth: enabled ? implicitWidth : 0

                onClicked: {
                    _stack.pop()
                    playSoundEffect ("click.wav")
                }

                contentItem: Image {
                    fillMode: Image.Pad
                    source: "qrc:/images/back.svg"
                    verticalAlignment: Image.AlignVCenter
                    horizontalAlignment: Image.AlignHCenter
                }

                Behavior on opacity { NumberAnimation{} }
                Behavior on Layout.preferredWidth { NumberAnimation{} }
            }

            Label {
                id: _title
                font.bold: true
                font.pixelSize: 18
            }

            Item {
                Layout.fillWidth: true
            }

            ToolButton {
                contentItem: Image {
                    fillMode: Image.Pad
                    source: "qrc:/images/more.svg"
                    verticalAlignment: Image.AlignVCenter
                    horizontalAlignment: Image.AlignHCenter
                }
            }
        }
    }

    //
    // Application content
    //
    StackView {
        id: _stack
        initialItem: _mainMenu

        anchors {
            fill: parent
            margins: app.spacing
            bottomMargin: _bannerContainer.height > 0 ? _bannerContainer.height + 2 * app.spacing :
                                                        app.spacing
        }

        //
        // Main menu
        //
        Pages.MainMenu {
            id: _mainMenu
            visible: false
            onExitClicked: app.close()
            onAboutClicked: _about.open()
            onSettingsClicked: _settings.open()

            onSinglePlayerClicked: {
                _gameOpt.showAiControls = true
                _stack.push (_gameOpt)
            }

            onMultiPlayerClicked: {
                _gameOpt.showAiControls = false
                _stack.push (_gameOpt)
            }

            onVisibleChanged: {
                if (visible)
                    caption = qsTr ("Welcome")
            }
        }

        //
        // Game options
        //
        Pages.GameOptions {
            id: _gameOpt
            visible: false
            onStartGameClicked: {
                Board.resetBoard()
                _stack.push (_board)
            }

            onVisibleChanged: {
                if (visible)
                    caption = qsTr ("Configure Game")
            }
        }

        //
        // Game Board
        //
        Pages.BoardPage {
            id: _board
            visible: false
            enabled: visible
            enableAiVsHuman: _gameOpt.showAiControls
            startNewGamesAutomatically: _settings.autoStartGames

            onVisibleChanged: {
                resetScores()
                Board.resetBoard()

                if (visible)
                    caption = qsTr ("Match")
            }
        }
    }

    //
    // Banner container
    //
    Item {
        id: _bannerContainer

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: app.spacing
        }
    }

    //
    // Banner add
    //
    AdMobBanner {
        id: _banner

        function locateBanner() {
            var w = _banner.width / DevicePixelRatio
            var h = _banner.height / DevicePixelRatio

            _bannerContainer.height = h
            x = (app.width - w) / 2
            y = (_bannerContainer.y + h + 2 * app.spacing) * 2
        }

        onLoaded: locateBanner()

        Component.onCompleted: {
            _banner.unitId = BannerId
            _banner.size = AdMobBanner.SmartBanner
            _banner.visible = true
            locateBanner()
        }
    }

    //
    // Interstitial ad
    //
    AdMobInterstitial {
        id: _interstitial
        onClosed: _interstitial.unitId = InterstitialId
        Component.onCompleted: _interstitial.unitId = InterstitialId
    }

    //
    // Settings dialog
    //
    Dialogs.Settings {
        id: _settings
        onEnableMusicChanged: _player.playMusic()
    }

    //
    // About dialog
    //
    Dialogs.About {
        id: _about
    }
}
