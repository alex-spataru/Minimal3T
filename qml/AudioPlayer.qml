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
import QtMultimedia 5.8

Item {
    //
    // Custom properties, no need for explanations
    //
    property bool introPlayed: false
    property bool enableMusic: true
    property bool enableSoundEffects: true

    //
    // Play or pause the music when the program changes the enableMusic
    // property
    //
    onEnableMusicChanged: playMusic()

    //
    // Ceates a temporary Audio type that plays the given file
    //
    function playSoundEffect (file) {
        if (enableSoundEffects && app.visible) {
            var qmlSourceCode = "import QtQuick 2.0;" +
                    "import QtMultimedia 5.0;" +
                    "Audio {" +
                    "   source: \"" + file + "\";" +
                    "   autoLoad: true; autoPlay: true; " +
                    "   onStopped: destroy (100); }"
            Qt.createQmlObject (qmlSourceCode, app, "SoundEffects")
        }
    }

    //
    // Stops or plays the music based on the settings and app visibility
    //
    function playMusic() {
        if (!introPlayed && enableMusic && app.active)
            intro.play()

        else if (!introPlayed)
            intro.stop()

        else if (enableMusic && app.active)
            player.play()

        else {
            player.stop()
            introPlayed = false
        }
    }

    //
    // Stop the background music when the application is not visible
    //
    Connections {
        target: Qt.application
        onStateChanged: {
            if (Qt.application.state === Qt.ApplicationActive)
                playMusic()

            else {
                intro.pause()
                player.pause()
            }
        }
    }

    //
    // Main player, used to play the background music loop
    //
    Audio {
        id: player
        autoLoad: true
        loops: Audio.Infinite
        audioRole: Audio.GameRole
        source: "qrc:/sounds/loop.ogg"
    }

    //
    // Intro player, only used to play the intro music, which is a little
    // bit different than the background loop
    //
    Audio {
        id: intro
        autoLoad: true
        audioRole: Audio.GameRole
        source: "qrc:/sounds/intro.ogg"
        onStopped: {
            introPlayed = true
            playMusic()
        }
    }
}
