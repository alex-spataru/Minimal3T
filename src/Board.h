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

/**
 * Represents the possible state of:
 *   - Any field on the board
 *   - The current turn of the game
 */
enum BoardPlayer {
    kUndefined      = 0x00,
    kPlayer1        = 0x01,
    kPlayer2        = 0x02,
};

/**
 * Represents the possible states of the game
 */
enum BoardState {
    kDraw           = 0x00,
    kGameWon        = 0x01,
    kGameInProgress = 0x02,
};

/**
 * Represents a tic-tac-toe/gomoku board and all its properties, it is more
 * efficient to have all this information on a structure than on a class,
 * because it is faster to copy and manipulate a small structure rather than
 * a full-fledged QObject-based class
 */
typedef struct {
    BoardState state;
    BoardPlayer turn;
    BoardPlayer winner;
    QVector<int> allignedFields;
    QVector<BoardPlayer> fields;

    short size;
    short fieldsToAllign;
} Board;

extern void ResetBoard (Board& board);
extern void UpdateGameState (Board& board);
extern void ResizeBoard (Board& board, const int size);
extern void SelectField (Board& board, const int field);
extern void DeleteMatrix (const Board& board, BoardPlayer** matrix);
extern void ChangeOwner (Board& board, const int field, const BoardPlayer owner);

extern int BoardSize (const Board& board);
extern int FieldAt (const Board& board, const int i, const int j);

extern BoardPlayer** BoardMatrix (const Board& board);
extern QVector<int> AvailableFields (const Board& board);
extern BoardPlayer OpponentOf (const BoardPlayer player);

#endif
