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

#include "Board.h"

#include <math.h>
#include <stdio.h>
#include <stdlib.h>

//------------------------------------------------------------------------------
// WARNING: Ugly code ahead, feel free to improve it
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Define utility functions
//------------------------------------------------------------------------------

static inline bool checkRows (Board&, BoardPlayer**);
static inline bool checkColumns (Board&, BoardPlayer**);
static inline bool checkLtrDiagonals (Board&, BoardPlayer**);
static inline bool checkRtlDiagonals (Board&, BoardPlayer**);
static inline bool checkWinners (Board&, QVector<int>, QVector<int>);
static inline void checkAllignedFields (Board&, QVector<int>&, QVector<int>&, int, int);

//------------------------------------------------------------------------------
// Implementation of public functions
//------------------------------------------------------------------------------

/**
 * Resets the winner, game state, turn and field owners from the given \a board
 */
void ResetBoard (Board& board) {
    board.turn = kPlayer1;
    board.winner = kUndefined;
    board.state = kGameInProgress;

    for (int i = 0; i < board.fields.count(); ++i)
        ChangeOwner (board, i, kUndefined);
}

/**
 * Checks the board for winning patterns from any player, then the function
 * shall update the game state according to the following rules:
 *   - If there is no winner and there are still some unused fields, then
 *     the game shall contine
 *   - If there is no winner and there are no unused fields available, then
 *     the game shall reach the \c kDraw state
 *   - If there is a winner, then the game state shall be set to \c kGameWon
 */
void UpdateGameState (Board& board) {
    int size = BoardSize (board);
    BoardPlayer** matrix = (BoardPlayer**) calloc (size, sizeof (BoardPlayer*));

    for (int i = 0; i < size; ++i) {
        matrix [i] = (BoardPlayer*) calloc (size, sizeof (BoardPlayer));
        for (int j = 0; j < size; ++j)
            matrix [i][j] = board.fields.at (i * size + j);
    }

    bool won = false;
    won |= checkRows (board, matrix);
    won |= checkColumns (board, matrix);
    won |= checkLtrDiagonals (board, matrix);
    won |= checkRtlDiagonals (board, matrix);

    if (won)
        board.state = kGameWon;

    else if (!won && AvailableFields (board).count() == 0)
        board.state = kDraw;

    else
        board.state = kGameInProgress;

    free (matrix);
}

/**
 * Resizes the given \a board to a \a size x \a size game and resets the game
 */
void ResizeBoard (Board& board, const int size) {
    Q_ASSERT (size > 0);

    board.size = size;
    board.fields.clear();
    for (int i = 0; i < size * size; ++i)
        board.fields.append (kUndefined);

    ResetBoard (board);
}

/**
 * Changes the owner of the given \a field of the \a board to the current
 * player in turn, updates the turn and updates the game state
 */
void SelectField (Board& board, const int field) {
    ChangeOwner (board, field, board.turn);
    board.turn = OpponentOf (board.turn);
    UpdateGameState (board);
}

/**
 * Changes the \a owner of the given \a field of the \a board
 */
void ChangeOwner (Board& board, const int field, const BoardPlayer owner) {
    Q_ASSERT (board.fields.count() > field);
    board.fields.replace (field, owner);
}

/**
 * Returns the size of the given \a board by calculating the square root
 * of the number of fields. For example, a 3x3 board shall contain 9 fields,
 * so the board size of a 3x3 board is 3
 */
int BoardSize (const Board& board) {
    return board.size;
}

/**
 * Returns a vector with the IDs of all the unused fields in the given \a board
 */
QVector<int> AvailableFields (const Board& board) {
    QVector<int> list;

    for (int i = 0; i < board.fields.count(); ++i)
        if (board.fields.at (i) == kUndefined)
            list.append (i);

    return list;
}

/**
 * Returns the enemy of the given \a player
 */
BoardPlayer OpponentOf (const BoardPlayer player) {
    if (player == kPlayer1)
        return kPlayer2;

    else if (player == kPlayer2)
        return kPlayer1;

    return kUndefined;
}


//------------------------------------------------------------------------------
// Implementation of utility functions
//------------------------------------------------------------------------------

static bool checkRows (Board& board, BoardPlayer** matrix) {
    Q_ASSERT (matrix);

    QVector<int> p1, p2;
    for (int i = 0; i < board.size; ++i) {
        p1.clear();
        p2.clear();

        for (int j = 0; j < board.size; ++j)
            checkAllignedFields (board, p1, p2, i, j);

        if (checkWinners (board, p1, p2))
            return true;
    }

    return false;
}

static bool checkColumns (Board& board, BoardPlayer** matrix) {
    Q_ASSERT (matrix);

    QVector<int> p1, p2;
    for (int i = 0; i < board.size; ++i) {
        p1.clear();
        p2.clear();

        for (int j = 0; j < board.size; ++j)
            checkAllignedFields (board, p1, p2, j, i);

        if (checkWinners (board, p1, p2))
            return true;
    }

    return false;
}

static bool checkLtrDiagonals (Board& board, BoardPlayer** matrix) {
    Q_ASSERT (matrix);

    QVector<int> p1, p2;
    for (int i = 0; i < board.size; ++i)
        checkAllignedFields (board, p1, p2, i, i);

    return checkWinners (board, p1, p2);
}

static bool checkRtlDiagonals (Board& board, BoardPlayer** matrix) {
    Q_ASSERT (matrix);

    QVector<int> p1, p2;
    for (int i = 0; i < board.size; ++i)
        checkAllignedFields (board, p1, p2, i, board.size - i - 1);

    return checkWinners (board, p1, p2);
}

static bool checkWinners (Board& board, QVector<int> p1, QVector<int> p2) {
    int p1_allignedFields = p1.count();
    int p2_allignedFields = p2.count();

    if (p1_allignedFields >= board.fieldsToAllign ||
            p2_allignedFields >= board.fieldsToAllign) {

        if (p1_allignedFields > p2_allignedFields) {
            board.winner = kPlayer1;
            board.allignedFields = p1;
        }

        else if (p1_allignedFields < p2_allignedFields) {
            board.winner = kPlayer2;
            board.allignedFields = p2;
        }

        else {
            board.winner = kUndefined;
            board.allignedFields.clear();
            return false;
        }

        board.state = kGameWon;
        return true;
    }

    return false;
}

static void checkAllignedFields (Board& board,
                                 QVector<int>& p1, QVector<int>& p2,
                                 int i, int j) {
    int field = i * BoardSize (board) + j;
    if (field < board.fields.count()) {
        if (board.fields.at (field) == kPlayer1) {
            if (p1.count() < board.fieldsToAllign)
                p1.append (field);
            if (p2.count() < board.fieldsToAllign)
                p2.clear();
        }

        else if (board.fields.at (field) == kPlayer2) {
            if (p2.count() < board.fieldsToAllign)
                p2.append (field);
            if (p1.count() < board.fieldsToAllign)
                p1.clear();
        }

        else {
            if (p1.count() < board.fieldsToAllign)
                p1.clear();
            if (p2.count() < board.fieldsToAllign)
                p2.clear();
        }
    }
}

