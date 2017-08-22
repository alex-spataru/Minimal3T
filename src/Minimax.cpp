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
 * Used to stop the minimax search in larger boards in order to avoid loosing
 * too much time simulating inprobable sitations
 */
int Minimax::maximumDepth (const Board& board) const {
    return board.size + board.fieldsToAllign;
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
    /* Init. variables */
    int move = INT_MIN;
    int score = INT_MIN;
    int maxScore = INT_MIN;

    /* Initialize board objects */
    Board copy;
    Board board = QmlBoard::getInstance()->board();

    /* Get a list of strategic fields */
    QVector<int> desirableFields = considerableFields (board, 0);

    /* Selecet each field on a secondary board and see what happens */
    foreach (int field, desirableFields) {
        copy = board;
        SelectField (copy, field);

        /* By selecting the field, we win or we loose, break the loop */
        if (copy.state == kGameWon) {
            move = field;
            break;
        }

        /* We cannot predict what happens, so we simulate a game */
        else {
            score = minimax (copy, 0, INT_MIN, INT_MAX);
            if (maxScore < score && RANDOM (0, 10) > cpuPlayer()->randomness()) {
                move = field;
                maxScore = score;
            }
        }
    }

    /* For some reason, the AI could not come up with a decision */
    if (move == -1)
        move = desirableFields.at (RANDOM (0, desirableFields.count() - 1));

    /* Select the choosen field on the 'real' board */
    setDecision (move);
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

    if (BoardSize (board) > 3) {
        if (depth < 2) {
            fields.append (nearbyFields (board, cpuPlayer()->player()));
            fields.append (nearbyFields (board, cpuPlayer()->opponent()));
        }

        if (fields.count() == 0)
            fields.append (availableCorners (board));

        if (fields.count() == 0)
            fields.append (availableCentralFields (board));
    }

    return fields.count() > 0 ? fields : AvailableFields (board);
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
 * Returns a vector with all the fields that are near the fields marked by
 * the given \a player
 *
 * This can be used to block opponent moves, or increase the chances of
 * the AI player to win.
 *
 * \note If this function detects a win-or-loose sitation, then it will
 *       automatically select the field in question and stop the MM process
 */
QVector<int> Minimax::nearbyFields (const Board& board, const BoardPlayer player) {
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

    /* Return the fields that are near the fields marked by the given player */
    return fields;
}

/**
 * Executes the Minimax algorithm in order to find the most optimal move that
 * can be choosen by the AI player
 */
int Minimax::minimax (Board& board, int depth, int alpha, int beta) {
    /* AI already made a decision, break recursive loop */
    if (decisionTaken() || depth >= maximumDepth (board))
        return 0;

    /* Get strategic fields */
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
    int score = 0;
    int isMax = board.turn == cpuPlayer()->player();
    int best = isMax ? INT_MIN : INT_MAX;

    /* Do a deep-search in order to find the best move */
    Board copy;
    for (int i = 0; i < fields.count(); ++i) {
        copy = board;
        SelectField (copy, fields.at (i));
        score = minimax (copy, depth + 1, alpha, beta);

        /* Get score for maximizing player */
        if (isMax) {
            best = qMax (best, score);
            alpha = qMax (best, alpha);

            if (beta <= alpha)
                return alpha;
        }

        /* Get score for minimizing player */
        else {
            best = qMin (best, score);
            beta = qMin (best, beta);

            if (beta <= alpha)
                return beta;
        }
    }

    /* Return the best score for the current player */
    return best;
}
