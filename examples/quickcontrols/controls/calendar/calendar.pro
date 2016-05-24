QT += qml quick sql
TARGET = calendar

!contains(sql-drivers, sqlite): QTPLUGIN += qsqlite

include(src/src.pri)
include(../shared/shared.pri)

OTHER_FILES += qml/main.qml

RESOURCES += resources.qrc

target.path = $$[QT_INSTALL_EXAMPLES]/quickcontrols/controls/calendar
INSTALLS += target
