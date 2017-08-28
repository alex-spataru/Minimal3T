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
import QtMultimedia 5.0

Item {
    property int track: -1
    property bool enableMusic: true
    property bool enableSoundEffects: true

    function playSoundEffect (effect) {
        if (enableSoundEffects && app.visible) {
            var source = "qrc:/sounds/" + effect
            var qmlSourceCode = "import QtQuick 2.0;" +
                    "import QtMultimedia 5.0;" +
                    "SoundEffect {" +
                    "   source: \"" + source + "\";" +
                    "   Component.onCompleted: play(); " +
                    "   onPlayingChanged: if (!playing) destroy (100); }"
            Qt.createQmlObject (qmlSourceCode, app, "SoundEffects")
        }
    }

    function playMusic() {
        if (enableMusic && app.active)
            player.play()
        else
            player.stop()
    }

    function pause() {
        player.pause()
    }

    function updateTrack() {
        if (track === -1)
            track = Math.random() * soundtracks.count

        if (track < soundtracks.count - 1)
            ++track
        else
            track = 0

        player.source = "qrc:/music/" + soundtracks.get (track).source

        if (enableMusic)
            player.play()
    }

    Connections {
        target: Qt.application
        onStateChanged: {
            if (Qt.application.state === Qt.ApplicationActive)
                playMusic()
            else
                pause()
        }
    }

    ListModel {
        id: soundtracks
        ListElement { source: "Scifi.ogg" }
        ListElement { source: "Relaxing.ogg" }
    }

    Audio {
        id: player
        onStopped: updateTrack()
        Component.onCompleted: updateTrack()
    }
}
