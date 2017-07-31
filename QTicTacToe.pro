#
# Copyright (c) 2017 Alex Spataru <alex_spataru@outlook.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

#-------------------------------------------------------------------------------
# Make options
#-------------------------------------------------------------------------------

UI_DIR = uic
MOC_DIR = moc
RCC_DIR = qrc
OBJECTS_DIR = obj

#-------------------------------------------------------------------------------
# Qt configuration
#-------------------------------------------------------------------------------

TEMPLATE = app
TARGET = QTicTacToe

CONFIG += qtc_runnable
CONFIG += resources_big

QT += svg
QT += core
QT += quick
QT += purchasing
QT += multimedia
QT += quickcontrols2

#-------------------------------------------------------------------------------
# Custom defines
#-------------------------------------------------------------------------------

DEFINES += QTADMOB_QML

# Uncomment ONLY when producing production-ready apps
# DEFINES += ENABLE_REAL_ADS

#-------------------------------------------------------------------------------
# Deploy configurations
#-------------------------------------------------------------------------------

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/deploy/android

#-------------------------------------------------------------------------------
# Include libraries
#-------------------------------------------------------------------------------

include ($$PWD/lib/QtAdMob/QtAdMob.pri)

#-------------------------------------------------------------------------------
# Import source code, QML and resources
#-------------------------------------------------------------------------------

HEADERS += \
    $$PWD/src/Board.h \
    $$PWD/src/AdInfo.h \
    $$PWD/src/Minimax.h \
    $$PWD/src/ComputerPlayer.h 

SOURCES += \
    $$PWD/src/main.cpp \
    $$PWD/src/Board.cpp \
    $$PWD/src/Minimax.cpp \
    $$PWD/src/ComputerPlayer.cpp

OTHER_FILES += \
    $$PWD/qml/*.qml \
    $$PWD/qml/Pages/*.qml \
    $$PWD/qml/Dialogs/*.qml \
    $$PWD/qml/Components/*.qml

RESOURCES += \
    $$PWD/qml/qml.qrc \
    $$PWD/fonts/fonts.qrc \
    $$PWD/music/music.qrc \
    $$PWD/images/images.qrc \
    $$PWD/sounds/sounds.qrc

DISTFILES += \
    $$PWD/deploy/android/AndroidManifest.xml \
    $$PWD/deploy/android/gradle/wrapper/gradle-wrapper.jar \
    $$PWD/deploy/android/gradlew \
    $$PWD/deploy/android/res/values/libs.xml \
    $$PWD/deploy/android/build.gradle \
    $$PWD/deploy/android/gradle/wrapper/gradle-wrapper.properties \
    $$PWD/deploy/android/gradlew.bat \
    $$PWD/lib/QtAdMob/platform/android/src/org/dreamdev/QtAdMob/QtAdMobActivity.java
