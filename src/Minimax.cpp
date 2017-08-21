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

//------------------------------------------------------------------------------
// WARNING: Ugly code ahead, feel free to improve it
//------------------------------------------------------------------------------

#include "Minimax.h"
#include "ComputerPlayer.h"

#include <random>

/**
 * Returns the base score for the minimax function
 */
static inline int BaseScore (const Board& board) {
    return board.fields.count() + 1;
}

/**
 * Returns a random number between \a min and \a max
 */
static inline int RANDOM (const int min, const int max) {
    std::random_device device;
    std::mt19937 engine (device());
    std::uniform_int_distribution<int> distribution (min , max);
    return distribution (engine);
}

/**
 * Initializes the internal variables of the class
 */
Minimax::Minimax (QObject* parent) : QObject (parent) {
    m_decision = -1;
    m_cache = Q_NULLPTR;
    m_cpuPlayer = Q_NULLPTR;
}

/**
 * Returns the field selected by the AI. If the AI has not made a decision yet,
 * then the decision shall be set to -1
 */
int Minimax::decision() const {
    return m_decision;
}

/**
 * Returns \c true if the AI has already made a decision
 */
bool Minimax::decisionTaken() const {
    return decision() != -1;
}

/**
 * Returns a pointer to the computer player assigned to this class.
 * The minimax code needs some information from the computer player,
 * such as its assigned game board, player ID and opponent ID.
 */
ComputerPlayer* Minimax::cpuPlayer() const {
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
void Minimax::makeAiMove() {
    /* Get a list of available moves */
    QVector<int> moves = getSmartMoves (QmlBoard::getInstance()->board());

    /* For some reason, the AI could not figure out at least one smart move */
    if (moves.isEmpty()) {
        QList<int> available = QmlBoard::getInstance()->availableFields();
        setDecision (available.at (RANDOM (0, available.count() - 1)));
    }

    /* Select the best move from the list */
    else if (RANDOM (1, 10) > cpuPlayer()->randomness())
        setDecision (moves.last());

    /* Randomly select one of the available moves */
    else
        setDecision (moves.at (RANDOM (0, moves.count() - 1)));
}

/**
 * Registers a pointer in which we shall write all the search trees generated
 * by the minimax algorythm
 */
void Minimax::setCache (MinimaxCache* cache) {
    Q_ASSERT (cache);
    m_cache = cache;
}

/**
 * Changes the computer player assigned to this class
 */
void Minimax::setComputerPlayer (ComputerPlayer* player) {
    Q_ASSERT (player);
    m_cpuPlayer = player;
}

/**
 * Notifies the rest of the program that the AI has selected a field
 */
void Minimax::setDecision (const int decision) {
    if (!decisionTaken()) {
        m_decision = decision;
        emit aiFinished (decision);
        emit finished();
    }
}

/**
 * Uses the minimax algorithm to obtain a list with the best moves that the
 * AI can make. The moves are ordered from the worst move to best move.
 */
QVector<int> Minimax::getSmartMoves (const Board& board) {
    /* Check conditions */
    Q_ASSERT (cpuPlayer());
    Q_ASSERT (m_cache != Q_NULLPTR);

    /* Initialize variables */
    QVector<int> moves;
    QVector<int> scores;
    QVector<int> bestMoves;
    int maxScore = INT_MIN;

    /* Calculate minimax moves */
    QVector<int> fields = considerableFields (board, 0);
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
            m_cache->append (qMakePair<int, QVector<BoardPlayer>> (score,
                             copy.fields));
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

    /* Return the best moves available */
    return bestMoves;
}

/**
 * Returns a vector with all the unused corners in the given \a board
 */
QVector<int> Minimax::availableCorners (const Board& board) {
    QVector<int> fields;
    QVector<int> corners = {
        0,
        BoardSize (board) - 1,
        board.fields.count() - 1,
        board.fields.count() - BoardSize (board),
    };

    foreach (int corner, corners)
        if (board.fields.at (corner) == kUndefined)
            fields.append (corner);

    return fields;
}

/**
 * Returns a list with the central field and its surrounding fields
 */
QVector<int> Minimax::availableCentralFields (const Board& board) {
    QVector<int> fields;

    int center = board.fields.count() / 2;
    QVector<int> centralFields = {
        center,
        center - 1,
        center + 1,
        center - BoardSize (board),
        center + BoardSize (board)
    };

    foreach (int centralField, centralFields)
        if (board.fields.at (centralField) == kUndefined)
            fields.append (centralField);

    return fields;
}

/**
 * Executes the Minimax algorithm in order to find the most optimal move that
 * can be choosen by the AI player
 */
int Minimax::minimax (Board& board, const int depth, int alpha, int beta) {
    /* AI already made a decision, break recursive loop */
    if (decisionTaken())
        return 0;

    /* Get available fields */
    QVector<int> fields = considerableFields (board, depth);

    /* Somebody wins, calculate score */
    if (board.state == kGameWon) {
        if (board.winner == cpuPlayer()->player())
            return BaseScore (board) - depth;

        return -BaseScore (board) + depth;
    }

    /* Meh, no one wins */
    else if (board.state == kDraw || fields.isEmpty())
        return 0;

    /* Initialize variables depending on current player */
    int isMax = board.turn == cpuPlayer()->player();
    int best = isMax ? INT_MIN : INT_MAX;

    /* Do a deep-search in order to find the best move */
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
 *   - Consider all fields that surround already-owned fields
 *   - If there are no available fields near enemy marks, consider corners
 *   - If there are no available fields near enemy marks, and no corners,
 *     consider the central field and its surrounding fields
 */
QVector<int> Minimax::considerableFields (const Board& board, const int depth) {
    QVector<int> fields;

    if (BoardSize (board) <= 3)
        fields = AvailableFields (board);

    else {
        if (depth <= board.fieldsToAllign) {
            fields.append (nearbyFields (board, cpuPlayer()->player(), depth));
            fields.append (nearbyFields (board, cpuPlayer()->opponent(), depth));
        }

        if (fields.count() == 0)
            fields.append (availableCorners (board));

        if (fields.count() == 0)
            fields.append (availableCentralFields (board));
    }

    return fields;
}

/**
 * Returns a vector with all the fields that are near the fields marked by
 * the given \a player
 *
 * This can be used to block opponent moves, or increase the chances of
 * the AI player to win.
 *
 * \note If this function detects a win-or-loose sitation, then it will
 *       automatically select the field in question and stop the MM process
 */
QVector<int> Minimax::nearbyFields (const Board& board, const BoardPlayer player,
                                    const int depth) {
    QVector<int> fields;

    /* Scan for fields owned by the given player */
    for (int i = 0; i < board.fields.count(); ++i) {
        if (board.fields.at (i) == player) {
            /* Get a list of fields surrounding the player field */
            QVector<int> possibleSurroundingFields = {
                i - 1,
                i + 1,
                i - BoardSize (board),
                i + BoardSize (board),
                i + BoardSize (board) + 1,
                i - BoardSize (board) - 1,
            };

            /* Eliminate the fields that are outside the board */
            QVector<int> surroundingFields;
            foreach (int field, possibleSurroundingFields)
                if (field < board.fields.count() && field >= 0)
                    surroundingFields.append (field);

            /* Get the nearby fields that are available */
            for (int i = 0; i < surroundingFields.count(); ++i) {
                int field = surroundingFields.at (i);
                if (board.fields.at (field) == kUndefined)
                    fields.append (field);
            }
        }
    }

    /* Probe each each field to see if we can win (or loose) the game */
    if (depth == 0) {
        foreach (int field, fields) {
            Board copy = board;
            SelectField (copy, field);
            if (copy.winner == player)
                setDecision (field);
        }
    }

    /* Return the fields that are near the fields marked by the given player */
    return fields;
}
