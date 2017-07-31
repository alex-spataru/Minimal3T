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

#include "ComputerPlayer.h"

/**
 * Initializes the internal variables of the class
 */
ComputerPlayer::ComputerPlayer() {
    m_randomness = 0;
    m_board = Q_NULLPTR;
    m_player = Board::Undefined;
}

/**
 * Returns the probability (from 0 to 10) that the AI will make a random choice
 */
int ComputerPlayer::randomness() const {
    return m_randomness;
}

/**
 * Returns the game board used by the computer player to "play" the Tic Tac Toe
 * game against another opponent
 */
Board* ComputerPlayer::board() {
    return m_board;
}

/**
 * Returns the ID of the computer player
 */
Board::Player ComputerPlayer::player() const {
    return m_player;
}

/**
 * Returns the ID of the other player in the game (which can be a human or
 * another computer player)
 */
Board::Player ComputerPlayer::opponent() const {
    return Board::OpponentOf (player());
}

/**
 * Finds the most optimal move based on the current behavior flags and random-
 * ness index of the computer player
 */
void ComputerPlayer::makeMove() {
    /* Create new thread and minimax object */
    QThread* thread = new QThread;
    Minimax* minmax = new Minimax;

    /* Configure minimax object and start thread */
    minmax->moveToThread (thread);
    minmax->setComputerPlayer (this);
    thread->start (QThread::HighestPriority);

    /* Configure signals/slots */
    connect (minmax, SIGNAL (finished()), thread, SLOT (quit()));
    connect (thread, SIGNAL (started()), minmax,  SLOT (makeAiMove()));
    connect (thread, SIGNAL (finished()), thread, SLOT (deleteLater()));
    connect (minmax, SIGNAL (finished()), minmax, SLOT (deleteLater()));
    connect (minmax, SIGNAL (decisionTaken (int)), board(), SLOT (selectField (int)));
}

/**
 * Changes the game \a board used by the computer player to, well, play...
 */
void ComputerPlayer::setBoard (Board* board) {
    Q_ASSERT (board);

    m_board = board;
    emit boardChanged();
}

/**
 * Changes the \a randomness index, which represents the probability (from 0 to 10)
 * that the AI player will make a random move instead of a "smart" move
 */
void ComputerPlayer::setRandomness (const int randomness) {
    m_randomness = randomness;
    emit randomnessChanged();
}

/**
 * Changes the player ID of the computer player.
 * \note The opponent ID will be changed automatically when the player ID is
 *       changed
 */
void ComputerPlayer::setPlayer (const Board::Player player) {
    m_player = player;
    emit playerChanged();
}
