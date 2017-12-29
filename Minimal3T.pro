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
TARGET = minimal3t

CONFIG += qtc_runnable
CONFIG += resources_big

QT += xml
QT += svg
QT += core
QT += quick
QT += multimedia
QT += quickcontrols2

QTPLUGIN += qsvg

DEFINES += QTADMOB_QML

#-------------------------------------------------------------------------------
# Translations
#-------------------------------------------------------------------------------

TRANSLATIONS += \
    $$PWD/assets/translations/en.ts \
    $$PWD/assets/translations/es.ts \
    $$PWD/assets/translations/fr.ts \
    $$PWD/assets/translations/ch.ts \
    $$PWD/assets/translations/ru.ts \
    $$PWD/assets/translations/it.ts

#-------------------------------------------------------------------------------
# Include libraries
#-------------------------------------------------------------------------------

include ($$PWD/lib/QtAdMob/QtAdMob.pri)
include ($$PWD/lib/ShareUtils-QML/ShareUtils-QML.pri)

#-------------------------------------------------------------------------------
# Import source code, QML and resources
#-------------------------------------------------------------------------------

HEADERS += \
    $$PWD/src/Board.h \
    $$PWD/src/Minimax.h \
    $$PWD/src/ComputerPlayer.h \
    $$PWD/src/QmlBoard.h \
    $$PWD/src/Translator.h \
    $$PWD/src/UiGradients.h

SOURCES += \
    $$PWD/src/main.cpp \
    $$PWD/src/Board.cpp \
    $$PWD/src/Minimax.cpp \
    $$PWD/src/ComputerPlayer.cpp \
    $$PWD/src/QmlBoard.cpp \
    $$PWD/src/Translator.cpp \
    $$PWD/src/UiGradients.cpp

OTHER_FILES += \
    $$PWD/assets/qml/*.qml \
    $$PWD/assets/qml/Pages/*.qml \
    $$PWD/assets/qml/Dialogs/*.qml \
    $$PWD/assets/qml/Components/*.qml

RESOURCES += \
    $$PWD/assets/qml/qml.qrc \
    $$PWD/assets/fonts/fonts.qrc \
    $$PWD/assets/images/images.qrc \
    $$PWD/assets/sounds/sounds.qrc \
    $$PWD/assets/translations/translations.qrc \
    $$PWD/assets/gradients/gradients.qrc

#-------------------------------------------------------------------------------
# Deploy configurations
#-------------------------------------------------------------------------------

linux:!android {
    target.path = /usr/bin
    icon.path = /usr/share/pixmaps
    desktop.path = /usr/share/applications
    icon.files += $$PWD/deploy/linux/minimal3t.png
    desktop.files += $$PWD/deploy/linux/minimal3t.desktop

    INSTALLS += target desktop icon
}

android {
    android:DEFINES += ENABLE_REAL_ADS
    #android:DEFINES += PREMIUM

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/deploy/android
    android:DISTFILES += \
        $$PWD/deploy/android/AndroidManifest.xml \
        $$PWD/deploy/android/build.gradle \
}

DISTFILES += \
    deploy/android/AndroidManifest.xml \
    deploy/android/gradle/wrapper/gradle-wrapper.jar \
    deploy/android/gradlew \
    deploy/android/res/values/libs.xml \
    deploy/android/build.gradle \
    deploy/android/gradle/wrapper/gradle-wrapper.properties \
    deploy/android/gradlew.bat
