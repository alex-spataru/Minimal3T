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

#include "Minimax.h"
#include "ComputerPlayer.h"

#include <random>

/**
 * Returns the base score for the minimax function
 */
static inline int BaseScore (const Board& board)
{
    return board.fields.count() + 1;
}

/**
 * Returns a random number between \a min and \a max
 */
static inline int RANDOM (const int min, const int max)
{
    std::random_device device;
    std::mt19937 engine (device());
    std::uniform_int_distribution<int> distribution (min , max);
    return distribution (engine);
}

/**
 * Initializes the internal variables of the class
 */
Minimax::Minimax (QObject* parent) : QObject (parent)
{
    m_cache = Q_NULLPTR;
    m_cpuPlayer = Q_NULLPTR;
}

/**
 * Returns a pointer to the computer player assigned to this class.
 * The minimax code needs some information from the computer player,
 * such as its assigned game board, player ID and opponent ID.
 */
ComputerPlayer* Minimax::cpuPlayer() const
{
    return m_cpuPlayer;
}

/**
 * This function shall decide whenever the AI player should do a random move
 * or a "smart" move.
 *|
 * If the function decides that it should make a "smart" move, then it starts
 * another recursive MM cycle to obtain the most optimal AI move.
 *
 * \note This function shall automatically mark the choosen field in the game
 *       board used by the computer player
 */
void Minimax::makeAiMove()
{
    QTime time;
    time.start();

    Q_ASSERT (cpuPlayer());

    /* Ensure that cache is set */
    if (!m_cache) {
        qWarning() << Q_FUNC_INFO << "Cache is not set, aborting";
        return;
    }

    /* Initialize variables */
    QList<int> moves;
    QList<int> scores;
    QList<int> bestMoves;
    int maxScore = INT_MIN;
    int choosenMove = INT_MIN;
    Board board = QmlBoard::getInstance()->board();

    /* Its not the AI's turn, abort */
    if (board.turn != cpuPlayer()->player())
        return;

    /* Get the fields that are worth considering */
    QVector<int> fields = considerableFields (board, 0);

    /* Calculate minimax moves */
    foreach (int field, fields) {
        Board copy = board;
        int score = INT_MIN;
        SelectField (copy, field);

        /* Check if cache already contains search tree */
        for (int i = 0; i < m_cache->count(); ++i) {
            if (m_cache->at (i).second == copy.fields) {
                score = m_cache->at (i).first;
                break;
            }
        }

        /* Cache does not contain search field, do it */
        if (score == INT_MIN) {
            score = minimax (copy, 0, INT_MIN, INT_MAX);
            m_cache->append (qMakePair<int, QVector<BoardPlayer>> (score, copy.fields));
        }

        /* Append scores */
        moves.append (field);
        scores.append (score);
    }


    /* Get the best moves */
    for (int i = 0; i < scores.count(); ++i) {
        if (scores.at (i) >= maxScore) {
            maxScore = scores.at (i);
            bestMoves.append (moves.at (i));
        }
    }

    /* Select best move (best moves are stored at the end of the list) */
    if (RANDOM (1, 10) > cpuPlayer()->randomness())
        choosenMove = bestMoves.last();

    /* Select random option from best moves */
    else
        choosenMove = bestMoves.at (RANDOM (0, bestMoves.count() - 1));

    /* Good riddance */
    emit decisionTaken (choosenMove);
    emit finished();
}

/**
 * Registers a pointer in which we shall write all the search trees generated
 * by the minimax algorythm
 */
void Minimax::setCache (MinimaxCache* cache)
{
    Q_ASSERT (cache);
    m_cache = cache;
}

/**
 * Changes the computer player assigned to this class
 */
void Minimax::setComputerPlayer (ComputerPlayer* player)
{
    Q_ASSERT (player);
    m_cpuPlayer = player;
}

/**
 * Executes the Minimax algorithm in order to find the most optimal move that
 * can be choosen by the AI player
 */
int Minimax::minimax (Board& board, const int depth, int alpha, int beta)
{
    /* Meh, no one wins */
    if (board.state == kDraw)
        return 0;

    /* Somebody wins, calculate score */
    else if (board.state == kGameWon) {
        if (board.winner == cpuPlayer()->player())
            return BaseScore (board) - depth;

        return -BaseScore (board) + depth;
    }

    /* Initialize variables depending on current player */
    int isMax = board.turn == cpuPlayer()->player();
    int best = isMax ? INT_MIN : INT_MAX;

    /* Do a deep-search in order to find the best move */
    QVector<int> fields = considerableFields (board, depth);
    for (int i = 0; i < fields.count(); ++i) {
        Board copy = board;
        SelectField (copy, fields.at (i));
        int mm = minimax (copy, depth + 1, alpha, beta);

        /* Get score for maximizing player */
        if (isMax) {
            best = qMax (best, mm);
            alpha = qMax (best, alpha);

            if (beta <= alpha)
                return alpha;
        }

        /* Get score for minimizing player */
        else {
            best = qMin (best, mm);
            beta = qMin (best, beta);

            if (beta <= alpha)
                return beta;
        }
    }

    /* Return the best score for the current player */
    return best;
}

/**
 * Creates a vector with the fields that are worth for the AI to consider when
 * making a decision.
 *
 * The list is generated according to the following rules:
 *   - Consider all fields that surround a field marked by the enemy
 *   - If there are no available fields near enemy marks, consider corners
 *   - If there are no available fields near enemy marks, and no corners,
 *     consider the central field and its surrounding fields
 */
QVector<int> Minimax::considerableFields (const Board& board, const int depth)
{
    /* Initialize a vector in which we will write all the worthwile fields */
    QVector<int> considerableFields;

    /* Append all the available fields near the opponent marks */
    if (depth < AvailableFields (board).count() / 2) {
        for (int i = 0; i < board.fields.count(); ++i) {
            if (board.fields.at (i) == cpuPlayer()->opponent()) {
                QVector<int> surroundingFields = {
                    i - 1,
                    i + 1,
                    i - BoardSize (board),
                    i + BoardSize (board),
                    i + BoardSize (board) + 1,
                    i - BoardSize (board) - 1,
                };

                foreach (int field, surroundingFields) {
                    if (field < board.fields.count() && field >= 0) {
                        if (board.fields.at (field) == kUndefined)
                            considerableFields.append (field);
                    }
                }
            }
        }
    }

    /* Consider corners if there aren't fields near enemy marks */
    if (considerableFields.count() == 0) {
        /* Calculate corner IDs */
        QVector<int> corners = {
            0,
            BoardSize (board) - 1,
            board.fields.count() - 1,
            board.fields.count() - BoardSize (board),
        };

        /* Check which corners are available */
        foreach (int corner, corners)
            if (board.fields.at (corner) == kUndefined)
                considerableFields.append (corner);
    }

    /* Consider central fields if there are no corners available */
    if (considerableFields.count() == 0) {
        int center = board.fields.count() / 2;

        /* Create a list with central field and its surroundign fields */
        QVector<int> centralFields = {
            center,
            center - 1,
            center + 1,
            center - BoardSize (board),
            center + BoardSize (board)
        };

        /* Check which central fields are available */
        foreach (int centralField, centralFields)
            if (board.fields.at (centralField) == kUndefined)
                considerableFields.append (centralField);
    }

    /* Return the obtained fields */
    return considerableFields;
}
