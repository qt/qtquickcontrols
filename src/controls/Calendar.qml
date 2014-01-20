/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
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

import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Controls.Private 1.0

/*!
    \qmltype Calendar
    \inqmlmodule QtQuick.Controls
    \since QtQuick.Controls 1.1
    \ingroup controls
    \brief Provides a way to select dates from a calendar

    Calendar allows selection of dates from a grid of days, similar to a typical
    calendar. The selected date can be set through \l selectedDate, or with the
    mouse and directional arrow keys. The current month displayed can be changed
    by clicking the previous and next month buttons, or by navigating with the
    directional keys.

    A minimum and maximum date can be set through \l minimumDate and
    \l maximumDate. The earliest minimum date that can be set is 1 January, 1
    AD. The latest maximum date that can be set is 25 October, 275759 AD.

    Localization is supported through the \l locale property. The selected date
    is displayed according to \l locale, and it can be accessed through the
    \l selectedDateText property.

    \note Due to the fact that the cell sizes are calculated based on the
    available space within the control, gaps can be seen between the bottom and
    right edges when assigning certain sizes to the Calendar.
*/

Control {
    id: calendar

    implicitWidth: 250
    implicitHeight: 250

    /*!
        \qmlproperty date Calendar::date

        The date that can be set by the user.

        This property is subject to the following validation:

        \list
            \li If selectedDate is outside the range of \l minimumDate and
                \l maximumDate, it will be clamped to be within that range.

            \li If selectedDate is equal to \c undefined or some other invalid
                value, it will not be changed.

            \li If there are hours, minutes, seconds or milliseconds set, they
                will be removed.
        \endlist

        \sa isValidDate()
    */
    property alias selectedDate: rangedDate.date

    /*!
        \qmlproperty date Calendar::minimumDate

        The earliest date that this calendar will accept.

        By default, this property is set to the earliest minimum date
        (1 January, 1 AD).
    */
    property alias minimumDate: rangedDate.minimumDate

    /*!
        \qmlproperty date Calendar::maximumDate

        The latest date that this calendar will accept.

        By default, this property is set to the latest maximum date
        (25 October, 275759 AD).
    */
    property alias maximumDate: rangedDate.maximumDate

    RangedDate {
        id: rangedDate
        date: new Date()
        minimumDate: DateUtils.minimumCalendarDate
        maximumDate: DateUtils.maximumCalendarDate
    }

    /*!
        This property determines the visibility of the grid.

        The default value is \c true.
    */
    property bool gridVisible: true

    /*!
        \qmlproperty enum Calendar::dayOfWeekFormat

        The format in which the days of the week (in the header) are displayed.

        \c Locale.ShortFormat is the default and recommended format, as
        \c Locale.NarrowFormat may not be fully supported by each locale (see
        qml-qtquick2-locale.html#locale-string-format-types) and
        \c Locale.LongFormat may not fit within the header cells.
    */
    property int dayOfWeekFormat: Locale.ShortFormat

    /*!
        The locale that this calendar should use to display itself.

        Affects how dates and day names are localised, as well as which
        day is considered the first in a week.

        The default locale is \c Qt.locale().
    */
    property var locale: Qt.locale()

    /*!
        The selected date converted to a string using \l locale.
    */
    property string selectedDateText: locale.standaloneMonthName(selectedDate.getMonth())
        + selectedDate.toLocaleDateString(locale, " yyyy")

    /*!
        \internal

        This property holds the model that will be used by the Calendar to
        populate the dates available to the user.
    */
    property CalendarModel __model: CalendarModel {
        locale: calendar.locale
    }

    /*!
        \qmlsignal Calendar::doubleClicked(date selectedDate)

        This signal is emitted when a date within the current month displayed
        by the calendar is double clicked. For example, dates outside the valid
        range do not emit this signal when clicked. Dates belonging to the
        previous or next month can not be double clicked.

        The argument is the \a date that was double clicked.
    */
    signal doubleClicked(date selectedDate)

    /*!
        \qmlsignal Calendar::escapePressed()

        This signal is emitted when escape is pressed while the view has focus.
        When Calendar is used as a popup, this signal can be handled to close
        the calendar.
    */
    signal escapePressed

    style: Qt.createComponent(Settings.style + "/CalendarStyle.qml", calendar)

    Keys.forwardTo: [view]

    /*!
        Returns true if \a date is not \c undefined and not less than
        \l minimumDate nor greater than \l maximumDate.
    */
    function isValidDate(date) {
        // We rely on the fact that an invalid QDate will be converted to a Date
        // whose year is -4713, which is always an invalid date since our
        // earliest minimum date is the year 1.
        return date !== undefined && date.getTime() >= calendar.minimumDate.getTime()
            && date.getTime() <= calendar.maximumDate.getTime();
    }

    /*!
        Selects the month before the current month in \l selectedDate.
    */
    function previousMonth() {
        calendar.selectedDate = DateUtils.setMonth(calendar.selectedDate, calendar.selectedDate.getMonth() - 1);
    }

    /*!
        Selects the month after the current month in \l selectedDate.
    */
    function nextMonth() {
        calendar.selectedDate = DateUtils.setMonth(calendar.selectedDate, calendar.selectedDate.getMonth() + 1);
    }

    Item {
        /*
            This is here instead of CalendarStyle, because the interactive
            stuff shouldn't be in the style, and because the various components
            of the calendar need to be anchored around the grid.
        */
        id: panel

        anchors.fill: parent

        property alias navigationBarItem: navigationBarLoader.item

        Loader {
            id: backgroundLoader
            anchors.fill: parent
            sourceComponent: __style.background
        }

        Loader {
            id: navigationBarLoader
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            sourceComponent: __style.navigationBar
        }

        Item {
            id: viewContainer
            anchors.top: navigationBarLoader.bottom
            width: view.cellWidth * DateUtils.daysInAWeek
            height: view.cellHeight * (view.weeksToShow + 1)

            Repeater {
                id: verticalGridLineRepeater
                model: DateUtils.daysInAWeek + 1
                delegate: Rectangle {
                    x: view.cellWidth * index
                    y: 0
                    width: __style.gridLineWidth
                    height: view.cellHeight * (verticalGridLineRepeater.count - 1) + __style.gridLineWidth
                    color: __style.gridColor
                    visible: calendar.gridVisible
                }
            }

            Repeater {
                id: horizontalGridLineRepeater
                model: view.weeksToShow + 2
                delegate: Rectangle {
                    x: 0
                    y: view.cellHeight * index
                    width: view.cellWidth * (horizontalGridLineRepeater.count - 1) + __style.gridLineWidth
                    height: __style.gridLineWidth
                    color: __style.gridColor
                    visible: calendar.gridVisible
                }
            }

            GridView {
                id: view
                /*
                    The cells will be as big as possible without causing them to spill over into the next row.
                    When gridVisible is true, we make the cells bigger to account for the grid lines.
                */
                cellWidth: Math.floor((calendar.width - (calendar.gridVisible ? __style.gridLineWidth : 0)) / DateUtils.daysInAWeek)
                cellHeight: Math.floor((calendar.height - (calendar.gridVisible ? __style.gridLineWidth : 0)
                    - navigationBarLoader.height) / (weeksToShow + 1))
                currentIndex: -1
                x: calendar.gridVisible ? __style.gridLineWidth : 0
                y: calendar.gridVisible ? __style.gridLineWidth : 0
                width: parent.width
                height: parent.height

                // TODO: fix the reason behind + 1 stopping the flickableness..
                // might have something to do with the header

                model: calendar.__model

                boundsBehavior: Flickable.StopAtBounds
                KeyNavigation.tab: panel.navigationBarItem

                readonly property int weeksToShow: 6

                Keys.onLeftPressed: {
                    if (currentIndex != 0) {
                        // Be lazy and let the view determine which index we're moving
                        // to, then we can calculate the date from that.
                        moveCurrentIndexLeft();
                        // This will cause the index to be set again (to the same value).
                        calendar.selectedDate = model.dateAt(currentIndex);
                    } else {
                        // We're at the left edge of the calendar on the first row;
                        // this day is the first of the week and the month, so
                        // moving left should go to the last day of the previous month,
                        // rather than do nothing (which is what GridView does when
                        // keyNavigationWraps is false).
                        var newDate = new Date(calendar.selectedDate);
                        newDate.setDate(newDate.getDate() - 1);
                        calendar.selectedDate = newDate;
                    }
                }

                Keys.onUpPressed: {
                    moveCurrentIndexUp();
                    calendar.selectedDate = model.dateAt(currentIndex);
                }

                Keys.onDownPressed: {
                    moveCurrentIndexDown();
                    calendar.selectedDate = model.dateAt(currentIndex);
                }

                Keys.onRightPressed: {
                    moveCurrentIndexRight();
                    calendar.selectedDate = model.dateAt(currentIndex);
                }

                Keys.onEscapePressed: {
                    calendar.escapePressed();
                }

                Component.onCompleted: {
                    dateChanged();

                    if (visible) {
                        forceActiveFocus();
                    }
                }

                Connections {
                    target: calendar
                    onSelectedDateChanged: view.dateChanged()
                }

                function dateChanged() {
                    if (model !== undefined && model.locale !== undefined) {
                        __model.selectedDate = calendar.selectedDate;
                        currentIndex = __model.indexAt(calendar.selectedDate);
                    }
                }

                delegate: Loader {
                    id: delegateLoader
                    width: view.cellWidth - (calendar.gridVisible ? __style.gridLineWidth : 0)
                    height: view.cellHeight - (calendar.gridVisible ? __style.gridLineWidth : 0)
                    sourceComponent: __style.dateDelegate

                    readonly property int __index: index
                    readonly property var __model: model

                    property QtObject styleData: QtObject {
                        readonly property alias index: delegateLoader.__index
                        readonly property alias model: delegateLoader.__model
                        readonly property bool selected: delegateLoader.GridView.isCurrentItem
                        readonly property date date: model.date
                    }

                    MouseArea {
                        anchors.fill: parent

                        function setDateIfValid(date) {
                            if (calendar.isValidDate(date)) {
                                calendar.selectedDate = date;
                            }
                        }

                        onClicked: {
                            setDateIfValid(date)
                        }

                        onDoubleClicked: {
                            if (date.getTime() === calendar.selectedDate.getTime()) {
                                // Only accept double clicks if the first click does not
                                // change the month displayed. This is because double-
                                // clicking on a date in the next month will first cause
                                // a single click which will change the month and the
                                // the release will be triggered on the same index but a
                                // different date (the date in the next month).
                                calendar.doubleClicked(date);
                            }
                        }
                    }
                }

                header: Loader {
                    width: view.width
                    height: view.cellHeight

                    sourceComponent: Row {
                        spacing: (calendar.gridVisible ? __style.gridLineWidth : 0)
                        Repeater {
                            id: repeater
                            model: CalendarHeaderModel {
                                locale: calendar.locale
                            }
                            Loader {
                                id: dayOfWeekDelegateLoader
                                sourceComponent: __style.weekdayDelegate
                                width: view.cellWidth - (calendar.gridVisible ? __style.gridLineWidth : 0)
                                height: view.cellHeight - (calendar.gridVisible ? __style.gridLineWidth : 0)

                                readonly property var __dayOfWeek: dayOfWeek

                                property QtObject styleData: QtObject {
                                    readonly property alias dayOfWeek: dayOfWeekDelegateLoader.__dayOfWeek
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
