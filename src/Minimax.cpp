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
Minimax::Minimax() {
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
int Minimax::maximumDepth (const Board& board) {
    if (board.size > 3)
        return ceil ((pow (board.fieldsToAllign, 2) / board.size) * 2);

    return INT_MAX;
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
    int offensive = INT_MIN;
    int defensive = INT_MIN;
    int maxScore = INT_MIN;

    /* Initialize board objects */
    Board copy, aiMove, enemyMove;
    Board board = QmlBoard::getInstance()->board();

    /* Select a random field in the case that the AI is too slow */
    QTimer::singleShot (5 * 1000, this, SLOT (selectRandomField()));

    /* Get a list of strategic fields */
    QVector<int> desirableFields = considerableFields (board, 0);

    /* Probe each field and see if we find win-or-loose situations */
    foreach (int field, desirableFields) {
        aiMove = board;
        enemyMove = board;
        enemyMove.turn = cpuPlayer()->opponent();

        SelectField (aiMove, field);
        SelectField (enemyMove, field);

        /* We found a winning move */
        if (aiMove.state == kGameWon && cpuPlayer()->offensiveMoves())
            offensive = field;

        /* We found a threat */
        else if (enemyMove.state == kGameWon && cpuPlayer()->defensiveMoves())
            defensive = field;
    }

    /* Prefer offensive moves rather than deffensive moves */
    if (cpuPlayer()->preferOffensive()) {
        if (offensive != INT_MIN)
            move = offensive;
        else if (defensive != INT_MIN)
            move = defensive;
    }

    /* Prefer deffensive moves rather than offensive moves */
    else {
        if (defensive != INT_MIN)
            move = defensive;
        else if (offensive != INT_MIN)
            move = offensive;
    }

    /* Run the minimax algorithm if no win-or-loose sitations where found */
    if (move == INT_MIN) {
        foreach (int field, desirableFields) {
            copy = board;
            SelectField (copy, field);
            int score = minimax (copy, 0, INT_MIN, INT_MAX);
            if (maxScore < score && RANDOM (0, 10) >= cpuPlayer()->randomness()) {
                move = field;
                maxScore = score;
            }
        }
    }

    /* Check if, for some reason, MM could not come up with a decision */
    if (move == INT_MIN)
        selectRandomField();

    /* Select the choosen field on the 'real' board */
    else
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
 * Selects a random field from the 'strategic' field set
 */
void Minimax::selectRandomField() {
    Board board = QmlBoard::getInstance()->board();
    QVector<int> desirableFields = considerableFields (board, 0);
    setDecision (desirableFields.at (RANDOM (0, desirableFields.count() - 1)));
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
 * Executes the Minimax algorithm in order to find the most optimal move that
 * can be choosen by the AI player
 */
int Minimax::minimax (Board& board, int depth, int alpha, int beta) {
    /* AI already made a decision, break recursive loop */
    if (decisionTaken() || depth > maximumDepth (board))
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
    int isMax = board.turn == cpuPlayer()->player();
    int best = isMax ? INT_MIN : INT_MAX;

    /* Do a tree search in order to find the best move */
    Board copy;
    foreach (int field, fields) {
        copy = board;
        SelectField (copy, field);
        int score = minimax (copy, depth + 1, alpha, beta);

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
 *   - If there are no acvailable fields near enemy marks, consider corners
 *   - If there are no available fields near enemy marks, and no corners,
 *     consider the central field and its surrounding fields
 */
QVector<int> Minimax::considerableFields (const Board& board, const int depth) {
    QVector<int> fields;

    /* Scan for fields to block or complete only on very possible sitations */
    if (depth < 2) {
        fields.append (nearbyFields (board, cpuPlayer()->player()));
        fields.append (nearbyFields (board, cpuPlayer()->opponent()));
    }

    /* No fields to block or complete, try the corners */
    if (fields.count() == 0 && board.size > 4)
        fields.append (availableCorners (board));

    /* No corners, try the central fields */
    if (fields.count() == 0)
        fields.append (availableCentralFields (board));

    /* Check all fields if board is small or there are no strategic moves */
    if (fields.isEmpty() || BoardSize (board) <= 3)
        fields = AvailableFields (board);

    /* Remove duplicated fields and return result */
    return QList<int>::fromSet (fields.toList().toSet()).toVector();
}

/**
 * Returns a list with the central field and its surrounding fields
 */
QVector<int> Minimax::availableCentralFields (const Board& board) {
    QVector<int> fields;

    int center = board.size / 2;
    QVector<int> centralFields = {
        FieldAt (board, center, center - 1),
        FieldAt (board, center, center + 1),
        FieldAt (board, center - 1, center),
        FieldAt (board, center - 1, center - 1),
        FieldAt (board, center - 1, center + 1),
        FieldAt (board, center + 1, center),
        FieldAt (board, center + 1, center - 1),
        FieldAt (board, center + 1, center + 1),
    };

    foreach (int field, centralFields) {
        if (field < board.fields.count() && field >= 0) {
            if (board.fields.at (field) == kUndefined)
                fields.append (field);
        }
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
QVector<int> Minimax::nearbyFields (const Board& board, const BoardPlayer player) {
    QVector<int> fields;
    BoardPlayer** matrix = BoardMatrix (board);

    for (int i = 0; i < BoardSize (board); ++i) {
        for (int j = 0; j < BoardSize (board); ++j) {
            if (matrix [i][j] == player) {
                QVector<int> possibleSurroundingFields = {
                    FieldAt (board, i, j - 1),
                    FieldAt (board, i, j + 1),
                    FieldAt (board, i - 1, j),
                    FieldAt (board, i + 1, j),
                    FieldAt (board, i - 1, j - 1),
                    FieldAt (board, i - 1, j + 1),
                    FieldAt (board, i + 1, j - 1),
                    FieldAt (board, i + 1, j + 1),
                };

                foreach (int field, possibleSurroundingFields) {
                    if (field < board.fields.count() && field >= 0) {
                        if (board.fields.at (field) == kUndefined)
                            fields.append (field);
                    }
                }
            }
        }
    }

    DeleteMatrix (board, matrix);
    return fields;
}
