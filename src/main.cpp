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

#include <QtQml>
#include <QScreen>
#include <QQuickStyle>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "shareutils.h"

#include "AdEngine.h"
#include "QmlBoard.h"
#include "Translator.h"
#include "ComputerPlayer.h"

int main (int argc, char** argv)
{
    QGuiApplication::setApplicationVersion ("1.4.0");
    QGuiApplication::setApplicationName ("SuperTac");
    QGuiApplication::setOrganizationName ("Alex Spataru");
    QGuiApplication::setAttribute (Qt::AA_EnableHighDpiScaling);

    QGuiApplication app (argc, argv);

    AdEngine adEngine;
    Translator translator;
    ComputerPlayer aiPlayer;
    aiPlayer.setPlayer (QmlBoard::Player2);

    AdEngine::DeclareQML();
    QmlBoard::DeclareQML();
    ShareUtils::DeclareQML();
    Translator::DeclareQML();
    ComputerPlayer::DeclareQML();

    qreal dpr = app.primaryScreen()->devicePixelRatio();
    adEngine.init ("99acf408592927c1eb3166ead85303ee64e25c9ad02c6acb");

    adEngine.setAdsEnabled (false);
#ifdef Q_OS_ANDROID
#ifndef DISABLE_ADS
    adEngine.setAdsEnabled (true);
#endif
#endif

    QQmlApplicationEngine engine;
    QQuickStyle::setStyle ("Universal");
    engine.rootContext()->setContextProperty ("AdEngine", &adEngine);
    engine.rootContext()->setContextProperty ("AiPlayer", &aiPlayer);
    engine.rootContext()->setContextProperty ("DevicePixelRatio", dpr);
    engine.rootContext()->setContextProperty ("Translator", &translator);
    engine.rootContext()->setContextProperty ("Board", QmlBoard::getInstance());
    engine.rootContext()->setContextProperty ("AppName", app.applicationName());
    engine.rootContext()->setContextProperty ("Company", app.organizationName());
    engine.rootContext()->setContextProperty ("Version", app.applicationVersion());
    engine.load (QUrl (QStringLiteral ("qrc:/qml/main.qml")));

    if (engine.rootObjects().isEmpty())
        return EXIT_FAILURE;

    return app.exec();
}
