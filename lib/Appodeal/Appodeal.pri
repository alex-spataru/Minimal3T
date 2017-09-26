INCLUDEPATH += $$PWD

SOURCES += \
    $$PWD/jnicallbacks.cpp \
    $$PWD/usersettings.cpp \
    $$PWD/appodealunsupported.cpp \
    $$PWD/appodealandroid.cpp \
    $$PWD/signalreceiver.cpp \
    $$PWD/appodealads.cpp

HEADERS += \
    $$PWD/appodealinterface.h \
    $$PWD/interstitialcallbacks.h \
    $$PWD/bannercallbacks.h \
    $$PWD/rewardedvideocallbacks.h \
    $$PWD/usersettings.h \
    $$PWD/appodealunsupported.h \
    $$PWD/appodealandroid.h \
    $$PWD/nonskippablevideocallbacks.h \
    $$PWD/signalreceiver.h \
    $$PWD/skippablevideocallbacks.h \
    $$PWD/appodealads.h

android {
    QT += androidextras
    QT += gui-private
    DEFINES += PACKAGE_NAME=\\\"com/appodeal/test/AppodealActivity\\\"
}

