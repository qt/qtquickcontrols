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

.pragma library

var daysInAWeek = 7;

// Not the number of weeks per month, but the number of weeks that are
// shown on a typical calendar.
var weeksOnACalendarMonth = 6;

/*!
    The amount of days to populate the calendar with.
*/
var daysOnACalendarMonth = daysInAWeek * weeksOnACalendarMonth

var msPerDay = 86400000;

// Can't create year 1 directly...
var minimumCalendarDate = new Date(-1, 0, 1);
minimumCalendarDate.setFullYear(minimumCalendarDate.getFullYear() + 2);
var maximumCalendarDate = new Date(275759, 9, 25);

function daysInMonth(date) {
    // Passing 0 as the day will give us the previous month, which will be
    // date.getMonth() since we added 1 to it.
    return new Date(date.getFullYear(), date.getMonth() + 1, 0).getDate();
}

function dayNameFromDayOfWeek(locale, dayOfWeekFormat, dayOfWeek) {
    return locale.dayName(dayOfWeek, dayOfWeekFormat);
}

/*!
    Clears \a model, then populates it with dates (role: "date")
    that you'd see on a calendar for the given \a date.

    \a model - A ListModel. Should have the following property:
        locale - A JavaScript Locale object.
    \a date - The date that the calendar month is based on (only the year
              and month are relevant)
*/
function populateDatesOnACalendarMonth(model, date) {
    if (model.count < daysOnACalendarMonth) {
        var dummyDate = new Date(1970, 0, 1, 0, 0, 0, 0);
        while (model.count < daysOnACalendarMonth) {
            // We only want to fill the model once, to avoid having to actually
            // repopulate it. Instead, we just set properties.
            model.append({ date: dummyDate });
        }
    }

    // Ideally we'd display the 1st of the month as the first
    // day in the calendar, but typically it's not the first day of
    // the week, so we need to display some days before it.

    // The actual first (1st) day of the month.
    // Avoid issue where years like "1" can't be created using (years, months, days)
    // constructor by just using the milliseconds constructor.
    var firstDayOfMonthDate = new Date(date);
    firstDayOfMonthDate.setDate(1);
    // The first day to display, if not the 1st of the month, will be
    // before the first day of the month.
    var difference = Math.abs(firstDayOfMonthDate.getDay() - model.locale.firstDayOfWeek);
    // The first day before the 1st that is equal to this locale's firstDayOfWeek.
    var firstDateToDisplay = new Date(firstDayOfMonthDate);

    if (difference != 0) {
        firstDateToDisplay.setDate(firstDateToDisplay.getDate() - difference);

        for (var i = 1; i <= difference; ++i) {
            var earlierDate = new Date(firstDayOfMonthDate);
            earlierDate.setDate(earlierDate.getDate() - i);

            // Reverse through it since we're iterating back through time.
            model.set(difference - i, { date: earlierDate });
        }
    }
    // Else, the first day of the month is also the first day of the week;
    // it can be the first day in the calendar.

    i = difference;
    for (var d = firstDayOfMonthDate.getDate(); d <= daysInMonth(date); ++d, ++i) {
        var tmpDate = new Date(date);
        tmpDate.setDate(d);
        model.set(i, { date: tmpDate });
    }

    // Fill up the calendar with days from the next month.
    var firstDayOfNextMonth = new Date(firstDayOfMonthDate);
    firstDayOfNextMonth.setMonth(firstDayOfNextMonth.getMonth() + 1);
    var daysToFill = daysOnACalendarMonth - i;
    for (var offset = 0; offset < daysToFill; ++offset) {
        var nextMonthDate = new Date(firstDayOfNextMonth);
        nextMonthDate.setDate(nextMonthDate.getDate() + offset);

        model.set(i + offset, { date: nextMonthDate });
    }
}

/*!
    Returns a copy of \a date with its month set to \a month, keeping the same
    day if possible. Does not modify \a date.
*/
function setMonth(date, month) {
    var oldDay = date.getDate();
    var newDate = new Date(date);
    // Set the day first, because setting the month could cause it to skip ahead
    // a month if the day is larger than the latest day in that month.
    newDate.setDate(1);
    newDate.setMonth(month);
    // We'd like to have the previous day still selected when we change
    // months, but it might not be possible, so use the smallest of the two.
    newDate.setDate(Math.min(oldDay, daysInMonth(newDate)));
    return newDate;
}
