#-------------------------------------------------
#
# Project created by QtCreator 2015-11-18T22:19:10
#
#-------------------------------------------------

QT       -= gui

TARGET = Appodeal
TEMPLATE = lib

DEFINES += APPODEAL_LIBRARY

SOURCES += appodeal.cpp

HEADERS += appodeal.h\
        appodeal_global.h \
    appodealinterface.h

unix {
    target.path = /usr/lib
    INSTALLS += target
}
