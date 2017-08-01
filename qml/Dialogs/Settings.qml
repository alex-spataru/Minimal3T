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

import Qt.labs.settings 1.0

Dialog {
    id: preferences

    //
    // Center window on application
    //
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2

    //
    // Window settings
    //
    modal: true
    title: qsTr ("Settings")
    standardButtons: Dialog.Ok
    parent: ApplicationWindow.overlay
    width: Math.min (app.width * 0.9, layout.implicitWidth * 1.4)

    //
    // Options (which are read by main.qml to configure app behavior)
    //
    property var appColor: Material.LightBlue
    property alias enableMusic: music.checked
    property alias autoStartGames: autoStartGames.checked
    property alias enableSoundEffects: soundEffects.checked

    //
    // Sound effects
    //
    onAccepted: app.playSoundEffect ("click.wav")
    onAppColorChanged: app.playSoundEffect ("click.wav")
    onEnableMusicChanged: app.playSoundEffect ("click.wav")
    onEnableSoundEffectsChanged: app.playSoundEffect ("click.wav")

    //
    // Save settings between app runs
    //
    Settings {
        category: "Preferences"
        property alias color: preferences.appColor
        property alias musicEnabled: preferences.enableMusic
        property alias autoStartNewGames: preferences.autoStartGames
        property alias effectsEnabled: preferences.enableSoundEffects
    }

    //
    // Main layout
    //
    ColumnLayout {
        id: layout
        spacing: app.spacing
        anchors.fill: parent
        anchors.centerIn: parent

        //
        // Music checkbox
        //
        Switch {
            id: music
            checked: true
            text: qsTr ("Music")
        }

        //
        // Sound effects checkBox
        //
        Switch {
            checked: true
            id: soundEffects
            text: qsTr ("Sound effects")
        }

        //
        // Auto start new games
        //
        Switch {
            checked: false
            id: autoStartGames
            text: qsTr ("Start new games without asking")
        }

        //
        // Game options
        //
        Button {
            Layout.fillWidth: true
            text: qsTr ("Game Options")
            Material.theme: Material.Light
        }
    }
}
