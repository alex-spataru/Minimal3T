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

#include <QList>
#include <math.h>

/**
 * Initializes the game board with a 3x3 field
 */
Board::Board (QObject *parent) : QObject (parent) {
    setBoardSize (3);
    setFieldsToAllign (boardSize());
}

/**
 * Define the operations needed when using the copy constructor
 */
Board::Board (Board &other) : QObject (Q_NULLPTR) {
    m_winner = other.winner();
    m_fields = other.fields();
    m_player = other.currentPlayer();
    m_gameState = other.gameState();
    m_fieldsToAllign = other.fieldsToAllign();
    m_allignedFields = other.allignedFields();

    moveToThread (other.thread());
    setObjectName (other.objectName());
}

/**
 * Returns the number of fields operated by the game board
 */
int Board::numFields() const {
    return fields().count();
}

/**
 * Returns the number of fields on each side of the board
 */
int Board::boardSize() const {
    return sqrt (numFields());
}

/**
 * Returns the current winner, possible return values are:
 *   - \c Player1,
 *   - \c Player2,
 *   - \c InvalidPlayer
 */
Board::Player Board::winner() const {
    return m_winner;
}

/**
 * Returns the player (1 or 2) that should make a move in order for
 * the game to continue
 */
Board::Player Board::currentPlayer() const {
    return m_player;
}

/**
 * Returns the number of fields that must be alligned in a line
 * in order for a player to win a game
 */
int Board::fieldsToAllign() const {
    return m_fieldsToAllign;
}

/**
 * Returns the current state of the game, which can be only one of the
 * following options:
 *   - \c GameInProgress
 *   - \c GameEnd
 *   - \c Draw
 */
Board::GameState Board::gameState() const {
    return m_gameState;
}

/**
 * Returns a list with all the field states of the board
 */
QList<Board::Player> Board::fields() const {
    return m_fields;
}

/**
 * Returns a list with the alligned fields.
 * This can be used to highlight the line formed by one of the players
 * when the game ends.
 */
QList<int> Board::allignedFields() const {
    return m_allignedFields;
}

/**
 * Returns a list with all the unused fields in the board.
 * This function is used by the AI to know which fields can be taken into
 * consideration when calculating the most optimal move
 */
QList<int> Board::availableFields() const {
    QList<int> list;

    for (int i = 0; i < numFields(); ++i)
        if (fields().at (i) == Undefined)
            list.append (i);

    return list;
}

/**
 * Returns the state of the given field, the state can be seen as 'who' is
 * the owner of the field.
 *
 * This function will return one of the following options:
 *   - \c Invalid
 *   - \c Player1
 *   - \c Player2
 */
Board::Player Board::fieldOwner (const int fieldNumber) const {
    Q_ASSERT (fieldNumber >= 0);
    Q_ASSERT (fieldNumber < numFields());

    return fields().at (fieldNumber);
}

/**
 * Resets all the field owners to \c Player::Invalid and prepares the
 * board for a new tic-tac-toe game
 */
void Board::resetBoard() {
    setWinner (Undefined);
    setCurrentPlayer (Board::Player1);
    changeGameState (GameInProgress);

    for (int i = 0; i < numFields(); ++i)
        changeFieldOwner (i, Undefined);

    updateGameState();
    emit boardReset();
}

/**
 * Checks whenever one of the players drew a line (and thus won) or if there
 * are no more possible moves on the board (thus reaching a draw).
 *
 * This function is called after any of the players makes a move.
 */
void Board::updateGameState() {
    /* Create and populate the field matrix */
    Player** matrix = (Player**) calloc (boardSize(), sizeof (Player*));
    for (int i = 0; i < boardSize(); ++i) {
        matrix [i] = (Player*) calloc (boardSize(), sizeof (Player));
        for (int j = 0; j < boardSize(); ++j)
            matrix [i][j] = fields().at (i * boardSize() + j);
    }

    /* Check the board for alligned fields */
    bool won = false;
    won |= checkRows (matrix);
    won |= checkColumns (matrix);
    won |= checkLtrDiagonals (matrix);
    won |= checkRtlDiagonals (matrix);

    /* Check if the game is a draw */
    if (!won && availableFields().count() == 0)
        changeGameState (Draw);

    /* Delete the temporal matrix */
    free (matrix);
}

/**
 * Assigns the given \a field as 'property' of the current player in turn
 * \note this function will not change the field state if the given \a
 * field is already used by one of the players
 */
void Board::selectField (const int field) {
    Q_ASSERT (field >= 0);
    Q_ASSERT (field < numFields());

    if (fieldOwner (field) == Undefined) {
        changeFieldOwner (field, currentPlayer());
        setCurrentPlayer (Board::OpponentOf (currentPlayer()));
    }
}

/**
 * Changes the board size (where size is n in a nxn board)
 * Note that the game will be reset during this operation
 */
void Board::setBoardSize (const int size) {
    Q_ASSERT (size > 0);

    m_fields.clear();
    for (int i = 0; i < size * size; ++i)
        m_fields.append (Undefined);

    resetBoard();
    emit boardSizeChanged();
}

/**
 * Changes the number of fields that any of the players must
 * allign in a line in order to win
 *
 * \note The given value must be at least 3
 * \note The given value must not be greater than the board size
 */
void Board::setFieldsToAllign (const int fields) {
    Q_ASSERT (fields >= 3);
    Q_ASSERT (fields <= boardSize());

    m_fieldsToAllign = fields;
    emit fieldsToAllignChanged();
}

/**
 * Changes the player that should make a move
 */
void Board::setCurrentPlayer (const Player turn) {
    m_player = turn;
    updateGameState();
    emit turnChanged();
}

/**
 * Overwrites all the field states
 */
void Board::changeAllFields (const QList<Player> fields) {
    Q_ASSERT (fields.count() == numFields());
    m_fields = fields;
}

/**
 * Overwrites the current \a owner of the given \a field
 */
void Board::changeFieldOwner (const int field, const Board::Player owner) {
    Q_ASSERT (field >= 0);
    Q_ASSERT (field < numFields());
    m_fields.replace (field, owner);
    emit fieldStateChanged (field, owner);
}

/**
 * Changes the winner of the game and notifies the rest of the
 * application about the event.
 *
 * Possible input values are:
 *   - \c Player1
 *   - \c Player2
 *   - \c InvalidPlayer
 */
void Board::setWinner (const Player newWinner) {
    if (winner() != newWinner) {
        m_winner = newWinner;
        emit winnerChanged();
    }
}

/**
 * Updates the game state and notifies the rest of the application
 * about the event.
 *
 * Possible input values are:
 *   - \c GameEnd
 *   - \c GameDraw
 *   - \c GameInProgress
 */
void Board::changeGameState (const GameState state) {
    if (gameState() != state) {
        m_gameState = state;
        emit gameStateChanged ();
    }
}

/**
 * Verifies if any of the players has alligned the fields
 * in a row in order to form a line
 */
bool Board::checkRows (Player** matrix) {
    Q_ASSERT (matrix);

    QList<int> p1, p2;
    for (int i = 0; i < boardSize(); ++i) {
        p1.clear();
        p2.clear();

        for (int j = 0; j < boardSize(); ++j)
            checkAllignedFields (p1, p2, i, j);

        if (checkWinners (p1, p2))
            return true;
    }

    return false;
}

/**
 * Verifies if any of the players has alligned the fields
 * in a column in order to form a line
 */
bool Board::checkColumns (Player** matrix) {
    Q_ASSERT (matrix);

    QList<int> p1, p2;
    for (int i = 0; i < boardSize(); ++i) {
        p1.clear();
        p2.clear();

        for (int j = 0; j < boardSize(); ++j)
            checkAllignedFields (p1, p2, j, i);

        if (checkWinners (p1, p2))
            return true;
    }

    return false;
}

/**
 * Verifies if any of the players has alligned the fields
 * in a left-to-right diagonal in order to form a line
 */
bool Board::checkLtrDiagonals (Player** matrix) {
    Q_ASSERT (matrix);

    QList<int> p1, p2;
    for (int i = 0; i < boardSize(); ++i)
        checkAllignedFields (p1, p2, i, i);

    return checkWinners (p1, p2);
}

/**
 * Verifies if any of the players has alligned the fields
 * in a right-to-left diagonal in order to form a line
 */
bool Board::checkRtlDiagonals (Player** matrix) {
    Q_ASSERT (matrix);

    QList<int> p1, p2;
    for (int i = 0; i < boardSize(); ++i) {
        int k = boardSize() - i - 1;
        checkAllignedFields (p1, p2, i, k);
    }

    return checkWinners (p1, p2);
}

/**
 * Checks if one of the players won based on the number of fields
 * alligned by each player.
 *
 * In the case that one of the players won, the game state and
 * winner variables are updated accordingly.
 *
 * \param p1 list of fields alligned by player 1
 * \param p2 list of fields alligned by player 2
 *
 * \returns \c true when one of the players won, \c false when no one won
 */
bool Board::checkWinners (const QList<int> p1, const QList<int> p2) {
    m_allignedFields.clear();
    int p1_allignedFields = p1.count();
    int p2_allignedFields = p2.count();

    if (p1_allignedFields >= fieldsToAllign() || p2_allignedFields >= fieldsToAllign()) {
        Player winner;

        if (p1_allignedFields > p2_allignedFields) {
            winner = Player1;
            m_allignedFields = p1;
        }

        else if (p1_allignedFields < p2_allignedFields) {
            winner = Player2;
            m_allignedFields = p2;
        }

        else
            return false;

        setWinner (winner);
        changeGameState (GameEnded);

        return true;
    }

    return false;
}

/**
 * Appends the field ID of the field in (i,j) on the list of the respective
 * field's owner. Finally, the function verifies if the \a p1 and \a p2 lists
 * are long enough to form a "winning" line. If not, then the field lists are
 * cleared.
 *
 * \param p1 temp. list with the fields alligned by player 1
 * \param p2 temp. list with the fields alligned by player 2
 */
void Board::checkAllignedFields (QList<int>& p1, QList<int>& p2, const int i, const int j) {
    int field = i * boardSize() + j;

    if (fieldOwner (field) == Player1) {
        p1.append (field);
        if (p2.count() < fieldsToAllign())
            p2.clear();
    }

    else if (fieldOwner (field) == Player2) {
        p2.append (field);
        if (p1.count() < fieldsToAllign())
            p1.clear();
    }

    else {
        if (p1.count() < fieldsToAllign())
            p1.clear();
        if (p2.count() < fieldsToAllign())
            p2.clear();
    }
}
