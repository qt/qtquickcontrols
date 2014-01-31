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
import QtQuick.Controls.Styles 1.1

CalendarStyle {
    id: calendarStyle

    background: Rectangle {
        color: __syspal.base
    }

    navigationBar: Item {
        height: 40

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

            onClicked: control.selectPreviousMonth()
        }
        Label {
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

            onClicked: control.selectNextMonth()
        }
    }

    dateDelegate: Rectangle {
        id: dayDelegate
        color: styleData.date !== undefined && styleData.selected ? __syspal.highlight : __syspal.base

        Label {
            SystemPalette {
                id: pal
                colorGroup: styleData.date.getMonth() === control.selectedDate.getMonth()
                    ? SystemPalette.Active : SystemPalette.Disabled
            }
            id: dayDelegateText
            text: styleData.date.getDate()
            anchors.centerIn: parent
            color: styleData.selected ? pal.highlightedText : pal.text
        }
    }

    weekdayDelegate: Rectangle {
        color: __syspal.base
        Label {
            text: control.locale.dayName(styleData.dayOfWeek, control.dayOfWeekFormat)
            anchors.centerIn: parent
        }
    }
}
