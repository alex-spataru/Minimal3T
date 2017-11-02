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
 * Initializes the internal variables of the class and configures the AI
 * watchdog
 */
ComputerPlayer::ComputerPlayer() :
    m_played (false),
    m_randomness (0),
    m_player (kUndefined),
    m_offensiveMoves (false),
    m_defensiveMoves (false),
    m_preferOffensive (false)
{
    m_aiWatchdog.setInterval (2000);
    connect (&m_aiWatchdog, SIGNAL (timeout()),
             this, SLOT (selectRandomField()));
}

/**
 * Returns \c true if the AI shall directly select fields that represent an
 * immediate win situation for the AI
 */
bool ComputerPlayer::offensiveMoves() const
{
    return m_offensiveMoves;
}

/**
 * Returns \c true if the AI shall directly select fields that represent an
 * immediate loose situation for the AI
 */
bool ComputerPlayer::defensiveMoves() const
{
    return m_defensiveMoves;
}

/**
 * Returns \c true, if, given the conditions, the AI shall prefer to select
 * a winning field rather than a deffensive move
 */
bool ComputerPlayer::preferOffensive() const
{
    return m_preferOffensive;
}

/**
 * Returns the probability (from 0 to 10) that the AI will make a random choice
 */
int ComputerPlayer::randomness() const
{
    return m_randomness;
}

/**
 * Returns the ID of the computer player
 */
BoardPlayer ComputerPlayer::player() const
{
    return m_player;
}

/**
 * Returns the ID of the other player in the game (which can be a human or
 * another computer player)
 */
BoardPlayer ComputerPlayer::opponent() const
{
    return OpponentOf (player());
}

/**
 * Finds the most optimal move based on the current behavior flags and random-
 * ness index of the computer player
 */
void ComputerPlayer::makeMove()
{
    /* Reset the "played" variable */
    m_played = false;

    /* Create new thread and minimax object */
    QThread* thread = new QThread;
    Minimax* minmax = new Minimax;

    /* Configure minimax object and start thread */
    minmax->moveToThread (thread);
    minmax->setComputerPlayer (this);
    thread->start (QThread::HighPriority);

    /* Do not let the AI think to much */
    m_aiWatchdog.start();

    /* Configure signals/slots */
    connect (minmax, SIGNAL (finished()), thread, SLOT (quit()));
    connect (thread, SIGNAL (started()), minmax,  SLOT (makeAiMove()));
    connect (thread, SIGNAL (finished()), thread, SLOT (deleteLater()));
    connect (minmax, SIGNAL (finished()), minmax, SLOT (deleteLater()));
    connect (minmax, SIGNAL (finished()), &m_aiWatchdog, SLOT (stop()));
    connect (minmax, SIGNAL (aiFinished (int)), this, SLOT (selectField (int)));
}

/**
 * Changes the \a randomness index, which represents the probability (from 0 to 10)
 * that the AI player will make a random move instead of a "smart" move
 */
void ComputerPlayer::setRandomness (const int randomness)
{
    m_randomness = randomness;
    emit randomnessChanged();
}

/**
 * Enables or disables the offensive behavior of the AI based on the \a enabled
 */
void ComputerPlayer::setOffensiveMoves (const bool enabled)
{
    m_offensiveMoves = enabled;
    emit behaviorChanged();
}

/**
 * Enables or disables the defensive behavior of the AI based on the \a enabled
 */
void ComputerPlayer::setDefensiveMoves (const bool enabled)
{
    m_defensiveMoves = enabled;
    emit behaviorChanged();
}

/**
 * Changes how merciful the AI is with the player :)
 */
void ComputerPlayer::setPreferOffensive (const bool enabled)
{
    m_preferOffensive = enabled;
    emit behaviorChanged();
}

/**
 * Changes the player ID of the computer player.
 * \note The opponent ID will be changed automatically when the player ID is
 *       changed
 */
void ComputerPlayer::setPlayer (const QmlBoard::Player player)
{
    m_player = (BoardPlayer) player;
    emit playerChanged();
}

/**
 * Selects a random field from the board ONLY IF the AI has not selected
 * another field
 */
void ComputerPlayer::selectRandomField() {
    if (!m_played && QmlBoard::getInstance()->boardSize() > 3)
        selectField (Minimax::RandomField (QmlBoard::getInstance()->board()));
}

/**
 * Selects the given field on the board ONLY IF the AI has not selected another
 * field yet (which can happen when the MM function takes to long to run)
 */
void ComputerPlayer::selectField (const int field) {
    if (!m_played) {
        m_played = true;
        QmlBoard::getInstance()->selectField (field);
    }
}

