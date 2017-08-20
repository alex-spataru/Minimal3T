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

#ifndef _BOARD_H
#define _BOARD_H

#include <QVector>

enum BoardPlayer {
    kUndefined      = 0x00,
    kPlayer1        = 0x01,
    kPlayer2        = 0x02,
};

enum BoardState {
    kDraw           = 0x00,
    kGameWon        = 0x01,
    kGameInProgress = 0x02,
};

typedef struct {
    BoardState state;
    BoardPlayer turn;
    BoardPlayer winner;
    int fieldsToAllign;
    QVector<int> allignedFields;
    QVector<BoardPlayer> fields;
} Board;

extern void ResetBoard (Board& board);
extern void UpdateGameState (Board& board);
extern void ResizeBoard (Board& board, const int size);
extern void SelectField (Board& board, const int field);
extern void ChangeOwner (Board& board, const int field, const BoardPlayer owner);

extern int BoardSize (const Board& board);
extern QVector<int> AvailableFields (const Board& board);
extern BoardPlayer OpponentOf (const BoardPlayer player);

#endif
