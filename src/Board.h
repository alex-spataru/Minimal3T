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

#ifndef _BOARD_H
#define _BOARD_H

#ifdef QT_QML_LIB
#include <QtQml>
#endif

#include <QObject>

class Board : public QObject {
    Q_OBJECT

#ifdef QT_QML_LIB
    Q_PROPERTY (bool gameWon
                READ gameWon
                NOTIFY gameStateChanged)
    Q_PROPERTY (bool gameDraw
                READ gameDraw
                NOTIFY gameStateChanged)
    Q_PROPERTY (bool gameInProgress
                READ gameInProgress
                NOTIFY gameStateChanged)
    Q_PROPERTY (int numFields
                READ numFields
                NOTIFY boardSizeChanged)
    Q_PROPERTY (int boardSize
                READ boardSize
                WRITE setBoardSize
                NOTIFY boardSizeChanged)
    Q_PROPERTY (int fieldsToAllign
                READ fieldsToAllign
                WRITE setFieldsToAllign
                NOTIFY fieldsToAllignChanged)
    Q_PROPERTY (GameState gameState
                READ gameState
                NOTIFY gameStateChanged)
    Q_PROPERTY (Player winner
                READ winner
                NOTIFY winnerChanged)
    Q_PROPERTY (Player currentPlayer
                READ currentPlayer
                WRITE setCurrentPlayer
                NOTIFY turnChanged)
#endif

public:
    enum Player {
        Undefined      = 0x00,
        Player1        = 0x01,
        Player2        = 0x02,
    };
    Q_ENUMS (Player)

    enum GameState {
        Draw           = 0x00,
        GameEnded      = 0x01,
        GameInProgress = 0x02,
    };
    Q_ENUMS (GameState)

signals:
    void boardReset();
    void turnChanged();
    void winnerChanged();
    void boardSizeChanged();
    void gameStateChanged();
    void fieldsToAllignChanged();
    void fieldStateChanged (const int fieldId, const Player state);

public:
    Board (QObject* parent = Q_NULLPTR);
    Board (Board& other);

    static void DeclareQML()
    {
#ifdef QT_QML_LIB
        qmlRegisterType<Board> ("Board", 1, 0, "TicTacToe");
#endif
    }

    static Player OpponentOf (const Player player) {
        if (player == Player1)
            return Player2;

        else if (player == Player2)
            return Player1;

        return Undefined;
    }

    int numFields() const;
    int boardSize() const;
    int fieldsToAllign() const;

    inline bool gameDraw() const { return gameState() == Draw; }
    inline bool gameWon() const { return gameState() == GameEnded; }
    inline bool gameInProgress() const { return gameState() == GameInProgress; }

    Player winner() const;
    Player currentPlayer() const;
    GameState gameState() const;

    Q_INVOKABLE QList<Player> fields() const;
    Q_INVOKABLE QList<int> allignedFields() const;
    Q_INVOKABLE QList<int> availableFields() const;
    Q_INVOKABLE Player fieldOwner (const int) const;

public slots:
    void resetBoard();
    void updateGameState();
    void selectField (const int);
    void setBoardSize (const int);
    void setFieldsToAllign (const int);
    void setCurrentPlayer (const Player);
    void changeAllFields (const QList<Player>);
    void changeFieldOwner (const int, const Player);

private slots:
    void setWinner (const Player);
    void changeGameState (const GameState);

private:
    bool checkRows (Player**);
    bool checkColumns (Player**);
    bool checkLtrDiagonals (Player**);
    bool checkRtlDiagonals (Player**);
    bool checkWinners (const QList<int>, const QList<int>);
    void checkAllignedFields (QList<int>&, QList<int>&, const int, const int);

private:
    Player m_player;
    Player m_winner;
    int m_fieldsToAllign;
    GameState m_gameState;
    QList<Player> m_fields;
    QList<int> m_allignedFields;
};

#endif
