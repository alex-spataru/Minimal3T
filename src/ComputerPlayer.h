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

#ifdef QT_QML_LIB
#include <QtQml>
#endif

class ComputerPlayer : public QObject {
    Q_OBJECT

#ifdef QT_QML_LIB
    Q_PROPERTY (Board::Player player
                READ player
                WRITE setPlayer
                NOTIFY playerChanged)
    Q_PROPERTY (Board::Player opponent
                READ opponent
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

    Board* board();
    Board::Player player() const;
    Board::Player opponent() const;

public slots:
    void makeMove();
    void setBoard (Board* board);
    void setRandomness (const int randomness);
    void setPlayer (const Board::Player player);

private:
    Board* m_board;
    int m_randomness;
    MinimaxCache m_cache;
    Board::Player m_player;
};

#endif
