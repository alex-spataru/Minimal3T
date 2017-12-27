SOURCES += $$PWD/shareutils.cpp
HEADERS += $$PWD/shareutils.h

INCLUDEPATH += $$PWD

ios {
    OBJECTIVE_SOURCES += $$PWD/ios/iosshareutils.mm
    HEADERS += $$PWD/ios/iosshareutils.h

    Q_ENABLE_BITCODE.name = ENABLE_BITCODE
    Q_ENABLE_BITCODE.value = NO
    QMAKE_MAC_XCODE_SETTINGS += Q_ENABLE_BITCODE
}

android {
    QT += androidextras
    SOURCES += $$PWD/android/androidshareutils.cpp
    HEADERS += $$PWD/android/androidshareutils.h
}
