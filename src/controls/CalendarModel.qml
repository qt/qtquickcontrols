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
import QtQuick.Controls.Private 1.0

/*!
    \qmltype CalendarModel
    \inqmlmodule QtQuick.Controls
    \since QtQuick.Controls 1.1
    \ingroup controls
    \brief A model that represents days in and surrounding a certain month

    The CalendarModel model provides a list of the days in and surrounding the
    month in which a given date lies.

    The only role provided by the model is \a date, a JavaScript \l Date object.

    \sa Calendar, CalendarHeaderModel
 */

ListModel {
    id: root

    /*!
        The month that the calendar is currently displaying -
        regardless of whether the selected date is in the previous or
        next month.

        The month is zero-based, as it refers to the calendar's
        \l {Calendar::selectedDate}{selectedDate}, which is a JavaScript
        \l Date object.
    */
    property int month: 0

    /*!
        The first date that is visible on the calendar.
    */
    property date firstVisibleDate
    /*!
        The last date that is visible on the calendar.
    */
    property date lastVisibleDate

    /*!
        The locale that this model should be based on.
        This affects, for example, the first day of the week, and consequently
        the order in which dates are populated in the model.
    */
    property var locale: Qt.locale()

    /*!
        Populates the calendar with days from the month in \a date.
    */
    function populateFromDate(date) {
        month = date.getMonth();

        DateUtils.populateDatesOnACalendarMonth(root, date);

        firstVisibleDate = root.get(0).date;
        lastVisibleDate = root.get(root.count - 1).date;
    }

    /*!
        Returns the index of \a date into the view, or \c -1 if \a date is
        outside the range of visible dates.
    */
    function indexFromDate(date) {
        if (count == 0 || date.getTime() < firstVisibleDate.getTime()
            || date.getTime() > lastVisibleDate.getTime()) {
            return -1;
        }

        // The index of the selected date will be the days from the
        // previous month that we had to display before it, plus the
        // day of the selected date itself.
        var daysDifference = (date.getTime() - firstVisibleDate.getTime()) / DateUtils.msPerDay;
        return Math.abs(daysDifference);
    }
}
