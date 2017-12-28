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

import Qt.labs.settings 1.0

import "../Components"

Overlay {
    id: page

    //
    // Properties
    //
    property bool useNought: true
    property bool humanFirst: true
    property bool enableMusic: true
    property bool randomMelodies: true
    property bool showAllBorders: false
    property bool enableSoundEffects: true
    property bool backgroundGradient: true
    property bool enableWinLooseSounds: true
    property bool reduceAiThinkingTime: false

    //
    // Updates the board and AI config bases on selected UI options
    //
    function applySettings() {
        Board.boardSize = _boardSize.value + 3
        showAllBorders = Board.boardSize > 3

        switch (_aiLevel.value) {
        case 0:
            AiPlayer.randomness = 5
            AiPlayer.offensiveMoves = true
            AiPlayer.defensiveMoves = false
            AiPlayer.preferOffensive = true
            break
        case 1:
            AiPlayer.randomness = 3
            AiPlayer.offensiveMoves = true
            AiPlayer.defensiveMoves = false
            AiPlayer.preferOffensive = true
            break
        case 2:
            AiPlayer.randomness = 2
            AiPlayer.defensiveMoves = true
            AiPlayer.offensiveMoves = true
            AiPlayer.preferOffensive = true
            break
        case 3:
            AiPlayer.randomness = 0
            AiPlayer.defensiveMoves = true
            AiPlayer.offensiveMoves = true
            AiPlayer.preferOffensive = true
            break
        }
    }

    //
    // Change the time limit for the AI to make a decision
    //
    onReduceAiThinkingTimeChanged: {
        if (reduceAiThinkingTime)
            AiPlayer.setAiTimeLimit (500)
        else
            AiPlayer.setAiTimeLimit (2000)
    }

    //
    // Load settings on generation
    //
    Component.onCompleted: applySettings()

    //
    // Save settings between app runs
    //
    Settings {
        category: "Settings"
        property alias nought: page.useNought
        property alias music: page.enableMusic
        property alias humanFirst: page.humanFirst
        property alias boardSize: _boardSize.value
        property alias aiDifficulty: _aiLevel.value
        property alias effects: page.enableSoundEffects
        property alias randomMelodies: page.randomMelodies
        property alias fieldsToAllign: _fieldsToAllign.value
        property alias enableGradient: page.backgroundGradient
        property alias winLooseSounds: page.enableWinLooseSounds
        property alias fastAndStupidAi: page.reduceAiThinkingTime
    }

    //
    // Main layout
    //
    contentData: ColumnLayout {
        id: layout
        spacing: app.spacing
        anchors.centerIn: parent

        //
        // Spacer
        //
        Item {
            Layout.fillHeight: true
            Layout.preferredHeight: app.spacing
        }

        //
        // Sound and music
        //
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.preferredWidth: app.paneWidth
            anchors.horizontalCenter: parent.horizontalCenter

            ImageButton {
                btSize: 0
                onClicked: useNought = !useNought
                font.pixelSize: app.font.pixelSize - 6
                text: qsTr ("Piece") + Translator.dummy
                source: useNought ? "qrc:/images/settings/circle.svg" :
                                    "qrc:/images/settings/cross.svg"
            }

            ImageButton {
                btSize: 0
                onClicked: humanFirst = !humanFirst
                font.pixelSize: app.font.pixelSize - 6
                text: qsTr ("First Turn") + Translator.dummy
                source: humanFirst ? "qrc:/images/settings/human.svg" :
                                     "qrc:/images/settings/ai.svg"
            }

            ImageButton {
                btSize: 0
                onClicked: enableMusic = !enableMusic
                font.pixelSize: app.font.pixelSize - 6
                text: qsTr ("Music") + Translator.dummy
                source: enableMusic ? "qrc:/images/settings/music-on.svg" :
                                      "qrc:/images/settings/music-off.svg"
            }

            ImageButton {
                btSize: 0
                font.pixelSize: app.font.pixelSize - 6
                text: qsTr ("Effects") + Translator.dummy
                onClicked: enableSoundEffects = !enableSoundEffects
                source: enableSoundEffects ? "qrc:/images/settings/volume-on.svg" :
                                             "qrc:/images/settings/volume-off.svg"
            }
        }

        //
        // Spacer
        //
        Item {
            Layout.fillHeight: true
        }

        //
        // Stack view
        //
        StackView {
            id: stack
            initialItem: firstPage
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: app.height * 0.52

            //
            // First settings page
            //
            ColumnLayout {
                id: firstPage
                visible: false
                Layout.fillWidth: true
                Layout.fillHeight: true

                Item {
                    Layout.fillHeight: true
                }

                TextSpinBox {
                    id: _boardSize
                    Layout.preferredWidth: app.paneWidth
                    title: qsTr ("Map Dimension") + Translator.dummy
                    anchors.horizontalCenter: parent.horizontalCenter
                    model: ["3x3", "4x4", "5x5", "6x6", "7x7", "8x8"]

                    onValueChanged: {
                        applySettings()
                        if (page.visible)
                            app.playSoundEffect ("click")
                    }
                }

                TextSpinBox {
                    id: _aiLevel
                    value: 1
                    Layout.preferredWidth: app.paneWidth
                    title: qsTr ("AI Level") + Translator.dummy
                    anchors.horizontalCenter: parent.horizontalCenter

                    model: [
                        qsTr ("Easy") + Translator.dummy,
                        qsTr ("Normal") + Translator.dummy,
                        qsTr ("Hard") + Translator.dummy,
                        qsTr ("Very Hard") + Translator.dummy,
                    ]

                    onValueChanged: {
                        applySettings()
                        if (page.visible)
                            app.playSoundEffect ("click")
                    }
                }

                TextSpinBox {
                    from: 3
                    id: _fieldsToAllign
                    to: Board.boardSize
                    Layout.preferredWidth: app.paneWidth
                    anchors.horizontalCenter: parent.horizontalCenter
                    title: qsTr ("Pieces to Align") + Translator.dummy
                    onValueChanged: {
                        if (value >= 3)
                            Board.fieldsToAllign = value

                        if (page.visible)
                            app.playSoundEffect ("click")
                    }
                }

                TextSpinBox {
                    value: Translator.language
                    model: Translator.availableLanguages
                    Layout.preferredWidth: app.paneWidth
                    title: qsTr ("Language") + Translator.dummy
                    anchors.horizontalCenter: parent.horizontalCenter
                    onValueChanged: {
                        if (Translator.language != value)
                            Translator.language = value
                    }
                }

                Item {
                    Layout.fillHeight: true
                }
            }

            //
            // Second settings page
            //
            ColumnLayout {
                id: secondPage
                visible: false
                Layout.fillWidth: true
                Layout.fillHeight: true

                Item {
                    Layout.preferredHeight: app.spacing * 2
                }

                Switch {
                    font.pixelSize: 13
                    checked: randomMelodies
                    onCheckedChanged: randomMelodies = checked
                    text: qsTr ("Random melody while playing")

                    anchors {
                        left: parent.left
                        right: parent.right
                        leftMargin: 3 * app.spacing
                    }
                }

                Switch {
                    font.pixelSize: 13
                    checked: reduceAiThinkingTime
                    text: qsTr ("Reduce AI thinking time")
                    onCheckedChanged: reduceAiThinkingTime = checked

                    anchors {
                        left: parent.left
                        right: parent.right
                        leftMargin: 3 * app.spacing
                    }
                }

                Switch {
                    font.pixelSize: 13
                    checked: backgroundGradient
                    text: qsTr ("Background gradient")
                    onCheckedChanged: backgroundGradient = checked

                    anchors {
                        left: parent.left
                        right: parent.right
                        leftMargin: 3 * app.spacing
                    }
                }

                Switch {
                    font.pixelSize: 13
                    checked: enableWinLooseSounds
                    text: qsTr ("Win/Loose sounds")
                    onCheckedChanged: enableWinLooseSounds = checked

                    anchors {
                        left: parent.left
                        right: parent.right
                        leftMargin: 3 * app.spacing
                    }
                }

                Item {
                    Layout.fillHeight: true
                }
            }
        }

        //
        // Spacer
        //
        Item {
            Layout.fillHeight: true
        }

        //
        // Navigation buttons
        //
        RowLayout {
            spacing: app.spacing
            Layout.fillWidth: true
            anchors.horizontalCenter: parent.horizontalCentercd

            Button {
                flat: true
                Layout.fillWidth: true

                RowLayout {
                    spacing: app.spacing
                    anchors.centerIn: parent

                    SvgImage {
                        fillMode: Image.Pad
                        source: "qrc:/images/settings/back.svg"
                        verticalAlignment: Image.AlignVCenter
                        horizontalAlignment: Image.AlignHCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Label {
                        text: qsTr ("Back") + Translator.dummy
                        font.capitalization: Font.AllUppercase
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                onClicked: {
                    if (stack.depth === 1)
                        page.hide()
                    else
                        stack.pop()

                    app.playSoundEffect ("click")
                }
            }

            Button {
                id: more
                flat: true
                Layout.fillWidth: true
                enabled: stack.depth === 1

                RowLayout {
                    spacing: app.spacing
                    anchors.centerIn: parent

                    Label {
                        text: qsTr ("More") + Translator.dummy
                        font.capitalization: Font.AllUppercase
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    SvgImage {
                        fillMode: Image.Pad
                        opacity: more.enabled ? 1 : 0.2
                        source: "qrc:/images/settings/next.svg"
                        verticalAlignment: Image.AlignVCenter
                        horizontalAlignment: Image.AlignHCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                onClicked: {
                    if (enabled) {
                        stack.push (secondPage)
                        app.playSoundEffect ("click")
                    }
                }
            }
        }

        //
        // Spacer
        //
        Item {
            Layout.fillHeight: true
            Layout.preferredHeight: app.spacing
        }
    }
}
