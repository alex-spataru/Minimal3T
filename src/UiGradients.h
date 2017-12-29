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

/*
 * IMPORTANT NOTE:
 * The nice, awe inspiring and XXI century-looking gradient colors come from:
 *      https://uigradients.com/
 */

#ifndef _UIGRADIENTS_H
#define _UIGRADIENTS_H

#include <QtQml>
#include <QColor>
#include <QObject>
#include <QJsonArray>
#include <QStringList>
#include <QJsonDocument>

class UiGradients : public QObject
{
    Q_OBJECT

#ifdef QT_QML_LIB
    Q_PROPERTY (int time
                READ time
                WRITE setTime
                NOTIFY timeChanged)
    Q_PROPERTY (QString name
                READ name
                NOTIFY colorsChanged)
    Q_PROPERTY (QStringList colors
                READ colors
                NOTIFY colorsChanged)
    Q_PROPERTY (int colorCount
                READ colorCount
                NOTIFY colorsChanged)
#endif

signals:
    void timeChanged();
    void colorsChanged();

public:
    UiGradients();

    static void DeclareQML()
    {
#ifdef QT_QML_LIB
        qmlRegisterType<UiGradients> ("UiGradients", 1, 0, "UiGradients");
#endif
    }

    int time() const;
    QString name() const;
    int colorCount() const;
    QStringList colors() const;

public slots:
    void setTime (const int time);

private slots:
    void updateColors();

private:
    int m_time;
    QString m_name;
    QStringList m_colors;
    QJsonArray m_gradients;
};

#endif
