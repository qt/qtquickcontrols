/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
**
** Contact: http://www.qt-project.org/legal
**
** Copyright (C) 2014 by David Edmundson (davidedmundson@kde.org)        *
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Private 1.0

Style {
    id: calendarStyle

    readonly property int weeksToShow: 6

    readonly property real navigationBarHeight: 40

    readonly property real cellWidth: control.width % 2 == 0
        ? control.width / DateUtils.daysInAWeek
        : Math.floor(control.width / DateUtils.daysInAWeek)

    readonly property real cellHeight: {control.height - navigationBarHeight % 2 == 0
        ? (parent.height - navigationBarHeight) / (weeksToShow + 1)
        : Math.floor((control.height - navigationBarHeight) / (weeksToShow + 1))
    }

    property Calendar control: __control

    property Component background: Rectangle {
        color: __syspal.base
    }

    property Component navigationBar: Item {
        visible: control.navigationBarVisible
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            color: __syspal.highlight
        }

        KeyNavigation.tab: previousMonth

        Button {
            id: previousMonth
            width: parent.height * 0.6
            height: width
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: (parent.height - height) / 2
            iconName: "go-previous-view"

            onClicked: control.previousMonth()
        }
        Text {
            id: dateText
            text: control.selectedDateText
            anchors.centerIn: parent
        }
        Button {
            id: nextMonth
            width: parent.height * 0.6
            height: width
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: (parent.height - height) / 2
            iconName: "go-next-view"

            onClicked: control.nextMonth()
        }
    }

    property Component dateDelegate: Rectangle {
        id: dayDelegate
        color: cellDate !== undefined && isCurrentItem ? __syspal.highlight : __syspal.base

        Text {
            SystemPalette {
                id: pal
                colorGroup: cellDate.getMonth() === control.selectedDate.getMonth() ? SystemPalette.Active : SystemPalette.Disabled
            }
            id: dayDelegateText
            text: cellDate.getDate()
            anchors.centerIn: parent
            color: isCurrentItem ? pal.highlightedText : pal.text
        }
    }

    property Component headerDelegate: Row {
        id: headerRow
        Repeater {
            id: repeater
            model: CalendarHeaderModel { locale: control.locale }
            Item {
                width: calendarStyle.cellWidth
                height: calendarStyle.cellHeight
                Rectangle {
                    color: __syspal.base
                    anchors.fill: parent
                    Text {
                        text: control.locale.dayName(dayOfWeek, control.dayOfWeekFormat)
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }

    property Component panel: Item {
        anchors.fill: parent
        implicitWidth: 250
        implicitHeight: 250

        property alias navigationBarItem: navigationBarLoader.item

        Loader {
            id: backgroundLoader
            anchors.fill: parent
            sourceComponent: background
        }

        Loader {
            id: navigationBarLoader
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: calendarStyle.navigationBarHeight
            sourceComponent: navigationBar
        }
    }
}
