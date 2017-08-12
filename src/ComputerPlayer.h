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

#define MAX_CACHE_LEN 65535

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
    void randomnessChanged();

public:
    ComputerPlayer();
    int randomness() const;
    BoardPlayer player() const;
    BoardPlayer opponent() const;

    inline MinimaxCache cache() const
    {
        return m_cache;
    }

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
    void setRandomness (const int randomness);
    void setPlayer (const QmlBoard::Player player);

private:
    int m_randomness;
    MinimaxCache m_cache;
    BoardPlayer m_player;
};

#endif
