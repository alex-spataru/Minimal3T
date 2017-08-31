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

#include <qdebug.h>
#include <stdlib.h>

//------------------------------------------------------------------------------
// WARNING: Ugly code ahead, feel free to improve it
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Define utility functions
//------------------------------------------------------------------------------

static inline bool checkRows (Board&);
static inline bool checkColumns (Board&);
static inline bool checkLtrDiagonals (Board&);
static inline bool checkRtlDiagonals (Board&);
static inline bool checkWinners (Board&, QVector<int>);

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
    bool won = false;
    won |= checkRows (board);
    won |= checkColumns (board);
    won |= checkLtrDiagonals (board);
    won |= checkRtlDiagonals (board);

    if (won)
        board.state = kGameWon;

    else if (!won && AvailableFields (board).count() == 0)
        board.state = kDraw;

    else
        board.state = kGameInProgress;
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
 * De-allocates each row of the given \a matrix
 */
void DeleteMatrix (const Board& board, BoardPlayer** matrix) {
    if (matrix) {
        for (int i = 0; i < board.size; ++i) {
            free (matrix [i]);
            matrix [i] = Q_NULLPTR;
        }

        free (matrix);
    }
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
 * Returns the field ID of the given column and row
 */
int FieldAt (const Board& board, const int row, const int col) {
    return row * board.size + col;
}

/**
 * Generates a square matrix containing the field owners of the given board
 */
BoardPlayer** BoardMatrix (const Board& board) {
    int size = BoardSize (board);
    BoardPlayer** matrix = (BoardPlayer**) calloc (size, sizeof (BoardPlayer*));

    for (int i = 0; i < size; ++i) {
        matrix [i] = (BoardPlayer*) calloc (size, sizeof (BoardPlayer));
        for (int j = 0; j < size; ++j)
            matrix [i][j] = board.fields.at (FieldAt (board, i, j));
    }

    return matrix;
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

static bool checkRows (Board& board) {
    int limit = board.size - board.fieldsToAllign;
    for (int row = 0; row < board.size; ++row) {
        for (int col = 0; col <= limit; ++col) {
            QVector<int> fields;
            for (int field = 0; field < board.fieldsToAllign; ++field)
                fields.append (FieldAt (board, row, col + field));

            if (checkWinners (board, fields))
                return true;
        }
    }

    return false;
}

static bool checkColumns (Board& board) {
    int limit = board.size - board.fieldsToAllign;

    for (int col = 0; col < board.size; ++col) {
        for (int row = 0; row <= limit; ++row) {
            QVector<int> fields;
            for (int field = 0; field < board.fieldsToAllign; ++field)
                fields.append (FieldAt (board, row + field, col));

            if (checkWinners (board, fields))
                return true;
        }
    }

    return false;
}

static bool checkLtrDiagonals (Board& board) {
    int limit = board.size - board.fieldsToAllign;

    for (int row = 0; row <= limit; ++row) {
        for (int col = 0; col <= limit; ++col) {
            QVector<int> fields;
            int field = FieldAt (board, row, col);

            for (int diag = 0; diag < board.fieldsToAllign; ++diag)
                fields.append (field + (diag * (board.size + 1)));

            if (checkWinners (board, fields))
                return true;
        }
    }

    return false;
}

static bool checkRtlDiagonals (Board& board) {
    int maxRow = board.size - board.fieldsToAllign;
    int maxCol = board.size - maxRow - 1;

    for (int row = 0; row <= maxRow; ++row) {
        for (int col = board.size - 1; col >= maxCol; --col) {
            QVector<int> fields;
            int field = FieldAt (board, row, col);

            for (int diag = 0; diag < board.fieldsToAllign; ++diag)
                fields.append (field + (diag * (board.size - 1)));

            if (checkWinners (board, fields))
                return true;
        }
    }

    return false;
}

static bool checkWinners (Board& board, QVector<int> line) {
    Q_ASSERT (board.fieldsToAllign == line.count());
    BoardPlayer player = board.fields.at (line.at (0));

    if (player != kUndefined) {
        foreach (int field, line) {
            BoardPlayer owner = board.fields.at (field);
            if (owner != player)
                return false;
        }

        board.winner = player;
        board.allignedFields = line;
        return true;
    }

    return false;
}
