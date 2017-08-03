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

#ifndef _MINIMAX_H
#define _MINIMAX_H

#include "Board.h"

class ComputerPlayer;
class Minimax : public QObject {
    Q_OBJECT

signals:
    void finished();
    void decisionTaken (const int);

public:
    Minimax (QObject* parent = 0);
    inline int evaluations() const;
    inline ComputerPlayer* cpuPlayer() const;
    inline bool reachedMaxEvals (const Board& board) const;

public slots:
    void makeAiMove();
    void setComputerPlayer (ComputerPlayer* player);

private:
    int randomMove();
    inline int minimax (Board& board, const int depth,
                        const int node, int alpha, int beta);

private:
    int m_choice;
    int m_evaluations;
    ComputerPlayer* m_cpuPlayer;
    QList<Board::Player> m_board;
};

#endif
