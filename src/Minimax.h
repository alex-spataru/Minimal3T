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
#include <QObject>

class ComputerPlayer;

class Minimax : public QObject
{
    Q_OBJECT

signals:
    void finished();
    void aiFinished (const int);

public:
    explicit Minimax();

    int decision() const;
    bool decisionTaken() const;
    ComputerPlayer* cpuPlayer() const;

    int maximumDepth (const Board& board);

public slots:
    void makeAiMove();
    void setComputerPlayer (ComputerPlayer* player);

private slots:
    void selectRandomField();
    void setDecision (const int decision);

private:
    int minimax (Board& board, int depth, int alpha, int beta);

    QVector<int> availableCorners (const Board& board);
    QVector<int> availableCentralFields (const Board& board);
    QVector<int> considerableFields (const Board& board, const int depth);
    QVector<int> nearbyFields (const Board& board, const BoardPlayer player);

private:
    int m_decision;
    ComputerPlayer* m_cpuPlayer;
};

#endif
