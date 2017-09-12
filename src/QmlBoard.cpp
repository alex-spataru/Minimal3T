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

#include "QmlBoard.h"

/**
 * Inititalizes the board to a 3x3 game with 3 fields to allign
 */
QmlBoard::QmlBoard()
{
    setBoardSize (3);
    setFieldsToAllign (3);
    setCurrentPlayer (Player1);
}

/**
 * Returns the only instance of the class.
 */
QmlBoard* QmlBoard::getInstance()
{
    static QmlBoard instance;
    return &instance;
}

/**
 * Returns the number of fields of the board.
 * \note The number of fields is not the same as the board size. The board
 *       size should always be the square root of the number of fields
 */
int QmlBoard::numFields() const
{
    return board().fields.count();
}

/**
 * Returns the number of fields that the board has on every side. In other
 * words, the board size is the square root of the total number of fields of
 * the board.
 */
int QmlBoard::boardSize() const
{
    return board().size;
}

/**
 * Returns the number of fields/pieces that each player must allign in a line
 * in order to win the game
 */
int QmlBoard::fieldsToAllign() const
{
    return board().fieldsToAllign;
}

/**
 * Returns \c true if any of the players have won the game
 */
bool QmlBoard::gameWon() const
{
    return gameState() == GameWon;
}

/**
 * Returns \c true if the game has reached a state in which none of the players
 * have won, but there are no more possible moves available
 */
bool QmlBoard::gameDraw() const
{
    return gameState() == Draw;
}

/**
 * Returns \c true if none of the players have won, but the game can still be
 * played (there are empty/unused fields)
 */
bool QmlBoard::gameInProgress() const
{
    return gameState() == GameInProgress;
}

/**
 * Returns the board structure used by this class
 */
Board QmlBoard::board() const
{
    return m_board;
}

/**
 * Returns the winner of the game, if the game is still in progress, this
 * function shall return \c Undefined
 */
QmlBoard::Player QmlBoard::winner() const
{
    return (Player) board().winner;
}

/**
 * Returns the game state of the board. Possible return values are:
 *   - \c GameWon
 *   - \c GameDraw
 *   - \c GameInProgress
 */
QmlBoard::GameState QmlBoard::gameState() const
{
    return (GameState) board().state;
}

/**
 * Returns the player that should make a move in order to continue the game
 */
QmlBoard::Player QmlBoard::currentPlayer() const
{
    return (Player) board().turn;
}

/**
 * Returns a list with all the field states of the board
 */
QList<QmlBoard::Player> QmlBoard::fields() const
{
    QList<Player> fields;

    foreach (BoardPlayer field, board().fields)
        fields.append ((Player) field);

    return fields;
}

/**
 * Returns a list with all the fields that one of the players alligned in
 * order to win the game
 */
QList<int> QmlBoard::allignedFields() const
{
    return board().allignedFields.toList();
}

/**
 * Returns a list with all the unused fields on the game board
 */
QList<int> QmlBoard::availableFields() const
{
    return AvailableFields (board()).toList();
}

/**
 * Returns the current owner/user of the given field. Possible return values
 * are:
 *   - \c Player1
 *   - \c Player2
 *   - \c Undefined
 */
QmlBoard::Player QmlBoard::fieldOwner (const int field) const
{
    Q_ASSERT (field < numFields());
    return (Player) board().fields.at (field);
}

/**
 * Clears all the field owners and resets the turns
 */
void QmlBoard::resetBoard()
{
    ResetBoard (m_board);

    for (int i = 0; i < numFields(); ++i)
        fieldStateChanged (i, Undefined);

    emit boardReset();
    emit winnerChanged();
    emit gameStateChanged();
}

/**
 * Executes several algorithms on the board in order to find the new game
 * state, which can be:
 *   - \c GameWon
 *   - \c GameDraw
 *   - \c GameInProgress
 */
void QmlBoard::updateGameState()
{
    UpdateGameState (m_board);

    emit winnerChanged();
    emit gameStateChanged();
}

/**
 * Changes the owner of the given \a field to the current player.
 * \note This function shall only change the owner of the given \a field
 *       if the \a field is unused
 */
void QmlBoard::selectField (const int field)
{
    Q_ASSERT (field < numFields());

    if (m_board.fields.at (field) == kUndefined) {
        SelectField (m_board, field);
        emit fieldStateChanged (field, fieldOwner (field));

        emit turnChanged();
        emit winnerChanged();
        emit gameStateChanged();
    }
}

/**
 * Updates the board \a size and resets the game
 */
void QmlBoard::setBoardSize (const int size)
{
    ResizeBoard (m_board, qMax (qMin (size, 10), 3));

    emit boardReset();
    emit turnChanged();
    emit boardSizeChanged();
    emit gameStateChanged();
}

/**
 * Changes the number of \a fields that a player needs to allign in order
 * to win the game
 */
void QmlBoard::setFieldsToAllign (const int fields)
{
    m_board.fieldsToAllign = qMax (qMin (fields, boardSize()), 3);
    emit fieldsToAllignChanged();
}

/**
 * Changes the current \a player in turn
 */
void QmlBoard::setCurrentPlayer (const Player player)
{
    m_board.turn = (BoardPlayer) player;
    emit turnChanged();
}

/**
 * Changes the \a owner of the given \a field
 * \note Unlike the \c selectField() function, this function shall overwrite
 *       the field owner without taking into consideration the current owner
 *       of the \a field
 */
void QmlBoard::changeOwner (const int field, const Player owner)
{
    Q_ASSERT (field < numFields());
    ChangeOwner (m_board, field, (BoardPlayer) owner);
    emit fieldStateChanged (field, owner);
}
