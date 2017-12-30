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
    property bool enableMusic: true
    property bool enableSoundEffects: true
    property alias musicFile: musicPlayer.source

    //
    // Song list
    //
    readonly property var songs: [
        "qrc:/sounds/music/relax.ogg",
        "qrc:/sounds/music/legends.ogg"
    ]

    //
    // Play or pause the music when the program changes the enableMusic
    // property
    //
    onEnableMusicChanged: playMusic()
    Component.onCompleted: playMusic()

    //
    // Executes a 'switch' to play the given file, if the switch defaults, then
    // the sound effect shall be played dinamically
    //
    function playSoundEffect (file) {
        function dynamicSoundEffect (file) {
            var qmlSourceCode = "import QtQuick 2.0;" +
                    "import QtMultimedia 5.0;" +
                    "SoundEffect {" +
                    "   source: \"" + file + "\";" +
                    "   Component.onCompleted: play(); " +
                    "   onPlayingChanged: if (!playing) destroy (100); }"
            Qt.createQmlObject (qmlSourceCode, app, "SoundEffects")
        }

        if (!enableSoundEffects || !app.visible)
            return

        switch(file) {
        case "win": win.play(); break;
        case "loose": loose.play(); break;
        case "click": click.play(); break;
        case "notes/a": noteA.play(); break;
        case "notes/b": noteB.play(); break;
        case "notes/c": noteC.play(); break;
        case "notes/d": noteD.play(); break;
        case "notes/e": noteE.play(); break;
        case "notes/f": noteF.play(); break;
        case "notes/g": noteG.play(); break;
        case "game-start": gameStart.play(); break;
        default: dynamicSoundEffect(file); break;
        }
    }

    //
    // Stops or plays the music based on the settings and app visibility
    //
    function playMusic() {
        if (enableMusic && app.active)
            musicPlayer.play()
        else
            musicPlayer.stop()
    }

    //
    // Randomly selects one of the background songs
    //
    function setMusicSource() {
        var track = Math.random() * (songs.length - 1)
        musicFile = songs [Math.round (track)]
    }

    //
    // Stop the background music when the application is not visible
    //
    Connections {
        target: Qt.application
        onStateChanged: {
            if (Qt.application.state === Qt.ApplicationActive)
                playMusic()
            else
                musicPlayer.pause()
        }
    }

    //
    // Background music player
    //
    Audio {
        id: musicPlayer
        autoLoad: true
        audioRole: Audio.GameRole
        onStopped: setMusicSource()
        Component.onCompleted: setMusicSource()
    }

    //
    // SoundEffect Army
    //
    Item {
        SoundEffect {
            id: click
            source: "qrc:/sounds/effects/click.wav"
        }

        SoundEffect {
            id: win
            source: "qrc:/sounds/effects/win.wav"
        }

        SoundEffect {
            id: loose
            source: "qrc:/sounds/effects/loose.wav"
        }

        SoundEffect {
            id: gameStart
            source: "qrc:/sounds/effects/game_start.wav"
        }

        SoundEffect {
            id: noteA
            source: "qrc:/sounds/notes/a.wav"
        }

        SoundEffect {
            id: noteB
            source: "qrc:/sounds/notes/b.wav"
        }

        SoundEffect {
            id: noteC
            source: "qrc:/sounds/notes/c.wav"
        }

        SoundEffect {
            id: noteD
            source: "qrc:/sounds/notes/d.wav"
        }

        SoundEffect {
            id: noteE
            source: "qrc:/sounds/notes/e.wav"
        }

        SoundEffect {
            id: noteF
            source: "qrc:/sounds/notes/f.wav"
        }

        SoundEffect {
            id: noteG
            source: "qrc:/sounds/notes/g.wav"
        }
    }
}
