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

#ifndef _COMPUTER_PLAYER_H
#define _COMPUTER_PLAYER_H

#include "Board.h"
#include "Minimax.h"
#include "QmlBoard.h"

#ifdef QT_QML_LIB
    #include <QtQml>
#endif

class ComputerPlayer : public QObject
{
    Q_OBJECT

#ifdef QT_QML_LIB
    Q_PROPERTY (QmlBoard::Player player
                READ qmlPlayer
                WRITE setPlayer
                NOTIFY playerChanged)
    Q_PROPERTY (QmlBoard::Player opponent
                READ qmlOpponent
                NOTIFY playerChanged)
    Q_PROPERTY (int randomness
                READ randomness
                WRITE setRandomness
                NOTIFY randomnessChanged)
    Q_PROPERTY (bool offensiveMoves
                READ offensiveMoves
                WRITE setOffensiveMoves
                NOTIFY behaviorChanged)
    Q_PROPERTY (bool defensiveMoves
                READ defensiveMoves
                WRITE setDefensiveMoves
                NOTIFY behaviorChanged)
    Q_PROPERTY (bool preferOffensive
                READ preferOffensive
                WRITE setPreferOffensive
                NOTIFY behaviorChanged)
#endif

public:
    static void DeclareQML()
    {
#ifdef QT_QML_LIB
        qmlRegisterType<ComputerPlayer> ("ComputerPlayer", 1, 0, "AI");
#endif
    }

signals:
    void boardChanged();
    void playerChanged();
    void behaviorChanged();
    void randomnessChanged();

public:
    ComputerPlayer();

    bool offensiveMoves() const;
    bool defensiveMoves() const;
    bool preferOffensive() const;

    int randomness() const;
    BoardPlayer player() const;
    BoardPlayer opponent() const;

    inline QmlBoard::Player qmlPlayer() const
    {
        return (QmlBoard::Player) player();
    }

    inline QmlBoard::Player qmlOpponent() const
    {
        return (QmlBoard::Player) opponent();
    }

public slots:
    void makeMove();
    void setAiTimeLimit (const int ms);
    void setRandomness (const int randomness);
    void setOffensiveMoves (const bool enabled);
    void setDefensiveMoves (const bool enabled);
    void setPreferOffensive (const bool enabled);
    void setPlayer (const QmlBoard::Player player);

private slots:
    void selectRandomField();
    void selectField (const int field);

private:
    bool m_played;
    int m_randomness;
    QTimer m_aiWatchdog;
    BoardPlayer m_player;
    bool m_offensiveMoves;
    bool m_defensiveMoves;
    bool m_preferOffensive;
};

#endif
