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

import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Private 1.0

/*!
    \qmltype CalendarStyle
    \inqmlmodule QtQuick.Controls.Styles
    \since QtQuick.Controls.Styles 1.1
    \ingroup controlsstyling
    \brief Provides custom styling for \l Calendar

    Example:
    \qml
    Calendar {
        anchors.centerIn: parent
        gridVisible: false

        style: CalendarStyle {
            dateDelegate: Rectangle {
                readonly property bool isSelectedMonth: styleData.date.getMonth() === control.selectedDate.getMonth()

                gradient: Gradient {
                    GradientStop {
                        position: 0.00
                        color: styleData.selected ? "#111" : (isSelectedMonth ? "#444" : "#666");
                    }
                    GradientStop {
                        position: 1.00
                        color: styleData.selected ? "#444" : (isSelectedMonth ? "#111" : "#666");
                    }
                    GradientStop {
                        position: 1.00
                        color: styleData.selected ? "#777" : (isSelectedMonth ? "#111" : "#666");
                    }
                }

                Label {
                    text: styleData.date.getDate()
                    anchors.centerIn: parent
                    color: "white"
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: "#555"
                    anchors.bottom: parent.bottom
                }

                Rectangle {
                    width: 1
                    height: parent.height
                    color: "#555"
                    anchors.right: parent.right
                }
            }
        }
    }
    \endqml
*/

Style {
    id: calendarStyle

    /*!
        The Calendar attached to this style.
    */
    property Calendar control: __control

    /*!
        The color of the grid lines.
    */
    property color gridColor: "#f0f0f0"

    /*!
        \internal

        The width of each grid line.
    */
    property real __gridLineWidth: 1

    /*!
        The background of the calendar.

        This component is typically not visible (that is, it is not able to be
        seen; the \l {Item::visible}{visible} property is still \c true) if the
        other components are fully opaque and consume as much space as possible.
    */
    property Component background: Rectangle {
        color: "#fff"
    }

    /*!
        The navigation bar of the calendar.

        Styles the bar at the top of the calendar that contains the
        next month/previous month buttons and the selected date label.
    */
    property Component navigationBar: Item {
        height: 50

        KeyNavigation.tab: previousMonth

        Button {
            id: previousMonth
            width: parent.height * 0.6
            height: width
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: (parent.height - height) / 2
            iconSource: "images/arrow-left.png"

            onClicked: control.selectPreviousMonth()
        }
        Label {
            id: dateText
            text: control.selectedDateText
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 14
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: previousMonth.right
            anchors.leftMargin: 2
            anchors.right: nextMonth.left
            anchors.rightMargin: 2
        }
        Button {
            id: nextMonth
            width: parent.height * 0.6
            height: width
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: (parent.height - height) / 2
            iconSource: "images/arrow-right.png"

            onClicked: control.selectNextMonth()
        }
    }

    /*!
        The delegate that styles each date in the calendar.

        The properties provided to each delegate are:
        \table
            \row \li readonly property date \b styleData.date \li The date this delegate represents.
            \row \li readonly property bool \b styleData.selected \li \c true if this is the selected date.
            \row \li readonly property int \b styleData.index \li The index of this delegate.
            \row \li readonly property var \b styleData.model \li The model of the view.
        \endtable
    */
    property Component dateDelegate: Rectangle {
        id: dayDelegate
        color: styleData.date !== undefined && styleData.selected ? selectedDateColor : "white"/*"transparent"*/
        readonly property color sameMonthDateTextColor: "black"
        readonly property color selectedDateColor: __syspal.highlight
        readonly property color selectedDateTextColor: "white"
        readonly property color differentMonthDateTextColor: Qt.darker("darkgrey", 1.4);
        readonly property color invalidDatecolor: "#dddddd"

        Label {
            id: dayDelegateText
            text: styleData.date.getDate()
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignRight
            color: {
                var color = invalidDatecolor;
                if (control.isValidDate(styleData.date)) {
                    // Date is within the valid range.
                    color = styleData.date.getMonth() === control.selectedDate.getMonth()
                        ? sameMonthDateTextColor : differentMonthDateTextColor;

                    if (styleData.selected) {
                        color = selectedDateTextColor
                    }
                }
                color;
            }
        }
    }

    /*!
        The delegate that styles each weekday.
    */
    property Component weekdayDelegate: Rectangle {
        color: "white"
        Label {
            text: control.locale.dayName(styleData.dayOfWeek, control.dayOfWeekFormat)
            anchors.centerIn: parent
        }
    }

    /*!
        The delegate that styles each week number.
    */
    property Component weekNumberDelegate: Rectangle {
        color: "white"
        Label {
            text: styleData.weekNumber
            anchors.centerIn: parent
        }
    }

    /*! \internal */
    property Component panel: Item {
        id: panel

        implicitWidth: 200
        implicitHeight: 200

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
            sourceComponent: navigationBar
        }

        Row {
            id: weekdayHeaderRow
            spacing: (control.gridVisible ? __gridLineWidth : 0)
            anchors.top: navigationBarLoader.bottom
            anchors.left: parent.left
            anchors.leftMargin: (control.weekNumbersVisible ? weekNumbersItem.width : 0) + (control.gridVisible ? __gridLineWidth : 0)
            anchors.right: parent.right
            height: 40

            Repeater {
                id: repeater
                model: CalendarHeaderModel {
                    locale: control.locale
                }
                Loader {
                    id: dayOfWeekDelegateLoader
                    sourceComponent: weekdayDelegate
                    width: CalendarUtils.cellRectAt(index, view.columns, view.rows, view.availableWidth, view.availableHeight).width
                        - (control.gridVisible ? __gridLineWidth : 0)
                    height: weekdayHeaderRow.height

                    readonly property var __dayOfWeek: dayOfWeek

                    property QtObject styleData: QtObject {
                        readonly property alias dayOfWeek: dayOfWeekDelegateLoader.__dayOfWeek
                    }
                }
            }
        }

        Row {
            id: gridRow
            width: weekNumbersItem.width + viewContainer.width
            height: viewContainer.height
            anchors.top: weekdayHeaderRow.bottom

            Item {
                id: weekNumbersItem
                visible: control.weekNumbersVisible
                width: 30
                height: viewContainer.height

                Repeater {
                    id: weekNumberRepeater
                    model: view.weeksToShow

                    Loader {
                        id: weekNumberDelegateLoader
                        y: CalendarUtils.cellRectAt(index * view.columns, view.columns, view.rows, view.availableWidth, view.availableHeight).y
                            + (calendar.gridVisible ? __gridLineWidth : 0)
                        width: weekNumbersItem.width
                        // TODO: It seems the column doesn't reposition the items
                        // after the height recovers from being negative
//                        height: view.cellRects[index * view.columns].height
                        height: CalendarUtils.cellRectAt(index * view.columns, view.columns, view.rows, view.availableWidth, view.availableHeight).height
                            - (calendar.gridVisible ? __gridLineWidth : 0)
                        sourceComponent: weekNumberDelegate

                        readonly property int __index: index
                        property int __weekNumber: control.__model.weekNumberAt(index)

                        // Must handle this ourselves since it's not a notifiable property, but an invokable function.
                        // This will be called every time the selected date changes, but not the first time the calendar is loaded.
                        Connections {
                            target: control
                            onSelectedDateChanged: __weekNumber = control.__model.weekNumberAt(index)
                        }

                        // This handles the first time the calendar is shown.
                        Connections {
                            target: control.__model
                            onCountChanged: __weekNumber = control.__model.weekNumberAt(index)
                        }

                        property QtObject styleData: QtObject {
                            readonly property alias index: weekNumberDelegateLoader.__index
                            readonly property int weekNumber: weekNumberDelegateLoader.__weekNumber
                        }
                    }
                }
            }

            // Contains the grid lines and the grid itself.
            Item {
                id: viewContainer
                width: panel.width - (control.weekNumbersVisible ? weekNumbersItem.width : 0)
                height: panel.height - navigationBarLoader.height - weekdayHeaderRow.height

                Repeater {
                    id: verticalGridLineRepeater
                    model: view.columns + 1
                    delegate: Rectangle {
                        // The last line will be an invalid index, so we must handle it
                        x: index < view.columns
                           ? CalendarUtils.cellRectAt(index, view.columns, view.rows, view.availableWidth, view.availableHeight).x
                           : CalendarUtils.cellRectAt(view.columns - 1, view.columns, view.rows, view.availableWidth, view.availableHeight).x
                             + CalendarUtils.cellRectAt(view.columns - 1, view.columns, view.rows, view.availableWidth, view.availableHeight).width
                        y: 0
                        width: __gridLineWidth
                        height: viewContainer.height
                        color: gridColor
                        visible: control.gridVisible
                    }
                }

                Repeater {
                    id: horizontalGridLineRepeater
                    model: view.rows + 1
                    delegate: Rectangle {
                        x: 0
                        // The last line will be an invalid index, so we must handle it
                        y: index < view.columns - 1
                            ? CalendarUtils.cellRectAt(index * view.columns, view.columns, view.rows, view.availableWidth, view.availableHeight).y
                            : CalendarUtils.cellRectAt((view.rows - 1) * view.columns, view.columns, view.rows, view.availableWidth, view.availableHeight).y
                              + CalendarUtils.cellRectAt((view.rows - 1) * view.columns, view.columns, view.rows, view.availableWidth, view.availableHeight).height
                        width: viewContainer.width
                        height: __gridLineWidth
                        color: gridColor
                        visible: control.gridVisible
                    }
                }

                Connections {
                    target: control
                    onSelectedDateChanged: view.dateChanged()
                }

                Repeater {
                    id: view

                    property int currentIndex: -1

                    readonly property int weeksToShow: 6
                    readonly property int rows: weeksToShow
                    readonly property int columns: CalendarUtils.daysInAWeek

                    model: control.__model

                    Component.onCompleted: dateChanged()

                    function dateChanged() {
                        if (model !== undefined && model.locale !== undefined) {
                            model.selectedDate = control.selectedDate;
                            currentIndex = model.indexAt(control.selectedDate);
                        }
                    }

                    // The combined available width and height to be shared amongst each cell.
                    readonly property real availableWidth: (viewContainer.width - (control.gridVisible ? __gridLineWidth : 0))
                    readonly property real availableHeight: (viewContainer.height - (control.gridVisible ? __gridLineWidth : 0))

                    delegate: Loader {
                        id: delegateLoader

                        x: CalendarUtils.cellRectAt(index, view.columns, view.rows, view.availableWidth, view.availableHeight).x
                            + (control.gridVisible ? __gridLineWidth : 0)
                        y: CalendarUtils.cellRectAt(index, view.columns, view.rows, view.availableWidth, view.availableHeight).y
                            + (control.gridVisible ? __gridLineWidth : 0)
                        width: CalendarUtils.cellRectAt(index, view.columns, view.rows, view.availableWidth, view.availableHeight).width
                            - (control.gridVisible ? __gridLineWidth : 0)
                        height: CalendarUtils.cellRectAt(index, view.columns, view.rows, view.availableWidth, view.availableHeight).height
                            - (control.gridVisible ? __gridLineWidth : 0)

                        sourceComponent: dateDelegate

                        readonly property int __index: index
                        readonly property var __model: model

                        property QtObject styleData: QtObject {
                            readonly property alias index: delegateLoader.__index
                            readonly property alias model: delegateLoader.__model
                            readonly property bool selected: view.currentIndex == index
                            readonly property date date: model.date
                        }

                        MouseArea {
                            anchors.fill: parent

                            function setDateIfValid(date) {
                                if (control.isValidDate(date)) {
                                    control.selectedDate = date;
                                }
                            }

                            onClicked: {
                                setDateIfValid(date)
                            }

                            onDoubleClicked: {
                                if (date.getTime() === control.selectedDate.getTime()) {
                                    // Only accept double clicks if the first click does not
                                    // change the month displayed. This is because double-
                                    // clicking on a date in the next month will first cause
                                    // a single click which will change the month and the
                                    // the release will be triggered on the same index but a
                                    // different date (the date in the next month).
                                    control.doubleClicked(date);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
