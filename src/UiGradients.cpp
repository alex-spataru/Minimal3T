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

#include "UiGradients.h"
#define MAX_COLORS 2

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
 * Opens the gradients database, if the application fails
 * to read the database file, then it shall write a warning
 * to the console and quit
 */
UiGradients::UiGradients() : m_time (10000)
{
    /* Open and gradients.json */
    QFile db (":/gradients/gradients.json");
    if (db.open (QFile::ReadOnly)) {
        QByteArray data = db.readAll();
        m_gradients = QJsonDocument::fromJson (data).array();
        db.close();
    }

    /* Error opening the file, let's see the world burn */
    else {
        qWarning() << "Cannot open gradients database!";
        qApp->quit();
    }

    /* Start gradient "generating" loop */
    updateColors();
}

/**
 * Returns the interval (in milliseconds) in which the colors
 * of the gradient are updated
 */
int UiGradients::time() const
{
    return m_time;
}

/**
 * Returns the name of the current gradient set
 */
QString UiGradients::name() const
{
    return m_name;
}

/**
 * Returns the number of colors that generate the current gradient
 */
int UiGradients::colorCount() const
{
    return colors().count();
}

/**
 * Returns a list with all the colors to generate a nice-looking gradient
 */
QStringList UiGradients::colors() const
{
    return m_colors;
}

/**
 * Changes the interval in which the gradient colors are updated
 */
void UiGradients::setTime (const int time)
{
    m_time = abs (time);
    emit timeChanged();
}

/**
 * Selects a random gradient from the gradient database
 */
void UiGradients::updateColors()
{
    /* Generate random gradient index */
    int index = RANDOM (0, m_gradients.count() - 1);

    /* Get color list */
    QJsonObject obj = m_gradients.at (index).toObject();
    QJsonValue value = obj.value ("colors");
    QVariantList list = value.toArray().toVariantList();

    /* Get gradient name */
    m_name = obj.value ("name").toString();

    /* Update colors (and ensure that they are not to dark or too bright) */
    m_colors.clear();
    for (int i = 0; i < qMin (list.count(), MAX_COLORS); ++i) {
        QColor color (list.at (i).toString());
        color.setHsl (color.hslHue(), 128, 156, 255);
        m_colors.append (color.name());
    }

    /* Schedule another update and notify the QML interface */
    QTimer::singleShot (m_time, this, SLOT (updateColors()));
    emit colorsChanged();
}
