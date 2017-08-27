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
QmlBoard::QmlBoard() {
    setBoardSize (3);
    setFieldsToAllign (3);
    setCurrentPlayer (Player1);
}

/**
 * Returns the only instance of the class.
 */
QmlBoard* QmlBoard::getInstance() {
    static QmlBoard instance;
    return &instance;
}

/**
 * Returns the number of fields of the board.
 * \note The number of fields is not the same as the board size. The board
 *       size should always be the square root of the number of fields
 */
int QmlBoard::numFields() const {
    return board().fields.count();
}

/**
 * Returns the number of fields that the board has on every side. In other
 * words, the board size is the square root of the total number of fields of
 * the board.
 */
int QmlBoard::boardSize() const {
    return board().size;
}

/**
 * Returns the number of fields/pieces that each player must allign in a line
 * in order to win the game
 */
int QmlBoard::fieldsToAllign() const {
    return board().fieldsToAllign;
}

/**
 * Returns \c true if any of the players have won the game
 */
bool QmlBoard::gameWon() const {
    return gameState() == GameEnded;
}

/**
 * Returns \c true if the game has reached a state in which none of the players
 * have won, but there are no more possible moves available
 */
bool QmlBoard::gameDraw() const {
    return gameState() == Draw;
}

/**
 * Returns \c true if none of the players have won, but the game can still be
 * played (there are empty/unused fields)
 */
bool QmlBoard::gameInProgress() const {
    return gameState() == GameInProgress;
}

/**
 * Returns the board structure used by this class
 */
Board QmlBoard::board() const {
    return m_board;
}

/**
 * Returns the winner of the game, if the game is still in progress, this
 * function shall return \c Undefined
 */
QmlBoard::Player QmlBoard::winner() const {
    return (Player) board().winner;
}

QmlBoard::GameState QmlBoard::gameState() const {
    return (GameState) board().state;
}

QmlBoard::Player QmlBoard::currentPlayer() const {
    return (Player) board().turn;
}

QList<QmlBoard::Player> QmlBoard::fields() const {
    QList<QmlBoard::Player> list;

    foreach (BoardPlayer element, board().fields)
        list.append ((Player) element);

    return list;
}

QList<int> QmlBoard::allignedFields() const {
    QList<int> list;
    QVector<int> vector = board().allignedFields;

    foreach (int element, vector)
        list.append (element);

    return list;
}

QList<int> QmlBoard::availableFields() const {
    QList<int> list;
    QVector<int> vector = AvailableFields (board());

    foreach (int element, vector)
        list.append (element);

    return list;
}

QmlBoard::Player QmlBoard::fieldOwner (const int field) const {
    Q_ASSERT (field < numFields());
    return (Player) board().fields.at (field);
}

void QmlBoard::resetBoard() {
    ResetBoard (m_board);

    for (int i = 0; i < numFields(); ++i)
        changeOwner (i, Undefined);

    emit boardReset();
    emit winnerChanged();
    emit gameStateChanged();
}

void QmlBoard::updateGameState() {
    UpdateGameState (m_board);

    emit winnerChanged();
    emit gameStateChanged();
}

void QmlBoard::selectField (const int field) {
    Q_ASSERT (field < numFields());

    if (m_board.fields.at (field) == kUndefined) {
        SelectField (m_board, field);
        emit turnChanged();
        emit fieldStateChanged (field, fieldOwner (field));
        updateGameState();
    }
}

void QmlBoard::setBoardSize (const int size) {
    ResizeBoard (m_board, size);

    emit boardReset();
    emit turnChanged();
    emit boardSizeChanged();
    emit gameStateChanged();
}

void QmlBoard::setFieldsToAllign (const int fields) {
    Q_ASSERT (fields <= boardSize());
    Q_ASSERT (fields >= 3);

    m_board.fieldsToAllign = fields;
    emit fieldsToAllignChanged();
}

void QmlBoard::setCurrentPlayer (const Player player) {
    m_board.turn = (BoardPlayer) player;
    emit turnChanged();
}

void QmlBoard::changeOwner (const int field, const Player owner) {
    Q_ASSERT (field < numFields());
    ChangeOwner (m_board, field, (BoardPlayer) owner);
    emit fieldStateChanged (field, owner);
}
