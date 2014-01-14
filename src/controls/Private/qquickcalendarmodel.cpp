/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "qquickcalendarmodel_p.h"

namespace {
    static const int daysInAWeek = 7;

    /*
        Not the number of weeks per month, but the number of weeks that are
        shown on a typical calendar.
    */
    static const int weeksOnACalendarMonth = 6;

    /*
        The amount of days to populate the calendar with.
    */
    static const int daysOnACalendarMonth = daysInAWeek * weeksOnACalendarMonth;
}

/*!
    QQuickCalendarModel provides a model for the Calendar control.
    It is responsible for populating itself with dates based on the
    date that is selected in the Calendar's grid.

    The model stores a list of dates whose indices map directly to the Calendar.
    For example, the model would store the following dates when any day in
    January 2015 is selected on the Calendar:

    [30/12/2014][31/12/2014][01/01/2015]...[31/01/2015][01/02/2015]...[09/02/2015]

    The Calendar would then display the dates in the same order within a grid:

            January 2015

    [30][31][01][02][03][04][05]
    [06][07][08][09][10][11][12]
    [13][14][15][16][17][18][19]
    [20][21][22][23][24][25][26]
    [27][28][29][30][31][01][02]
    [03][04][05][06][07][08][09]
*/

QQuickCalendarModel::QQuickCalendarModel(QObject *parent) :
    QAbstractListModel(parent)
{
}

/*!
    The date that determines which dates are stored.

    We store all of the days in the month of selectedDate, as well as any days
    in the previous or following month if there is enough space.
*/
QDate QQuickCalendarModel::selectedDate() const
{
    return mSelectedDate;
}

/*!
    Sets the selected date to \a selectedDate.

    If \a selectedDate is a valid date and is different than the previously
    selected date, the selected date is changed and
    populateFromSelectedDate() called.
*/
void QQuickCalendarModel::setSelectedDate(const QDate &date)
{
    if (date != mSelectedDate && date.isValid()) {
        const QDate previousDate = mSelectedDate;
        mSelectedDate = date;
        populateFromSelectedDate(previousDate);
        emit selectedDateChanged(date);
    }
}

/*!
    The locale set on the Calendar.

    This affects which dates are stored for selectedDate(). For example, if
    the locale is en_US, the first day of the week is Sunday. Therefore, if
    selectedDate() is some day in January 2014, there will be three days
    displayed before the 1st of January:


            January 2014

    [SO][MO][TU][WE][TH][FR][SA]
    [29][30][31][01][02][03][04]
    ...

    If the locale is then changed to en_GB (with the same selectedDate()),
    there will be 2 days before the 1st of January, because Monday is the
    first day of the week for that locale:

            January 2014

    [MO][TU][WE][TH][FR][SA][SO]
    [30][31][01][02][03][04][05]
    ...
*/
QLocale QQuickCalendarModel::locale() const
{
    return mLocale;
}

/*!
    Sets the locale to \a locale.
*/
void QQuickCalendarModel::setLocale(const QLocale &locale)
{
    if (locale != mLocale) {
        mLocale = locale;
        emit localeChanged(mLocale);
    }
}

QVariant QQuickCalendarModel::data(const QModelIndex &index, int role) const
{
    if (role == DateRole) {
        return mVisibleDates.at(index.row());
    }
    return QVariant();
}

int QQuickCalendarModel::rowCount(const QModelIndex &) const
{
    return mVisibleDates.isEmpty() ? 0 : weeksOnACalendarMonth * daysInAWeek;
}

QHash<int, QByteArray> QQuickCalendarModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[DateRole] = QByteArrayLiteral("date");
    return names;
}

/*!
    Returns the date at \a index, or an invalid date if \a index is invalid.
*/
QDate QQuickCalendarModel::dateAt(int index) const
{
    return index >= 0 && index < mVisibleDates.size() ? mVisibleDates.at(index) : QDate();
}

/*!
    Returns the index for \a date, or -1 if \a date is outside of our range.
*/
int QQuickCalendarModel::indexAt(const QDate &date)
{
    if (mVisibleDates.size() == 0 || date < mFirstVisibleDate || date > mLastVisibleDate) {
        return -1;
    }

    // The index of the selected date will be the days from the
    // previous month that we had to display before it, plus the
    // day of the selected date itself.
    return qMax(qint64(0), mFirstVisibleDate.daysTo(date));
}

/*!
    Called before selectedDateChanged() is emitted.

    This function is called even when just the day has changed, in which case
    it does nothing.
*/
void QQuickCalendarModel::populateFromSelectedDate(const QDate &previousDate)
{
    // We don't need to populate if the year and month haven't changed.
    if (mSelectedDate.year() == previousDate.year() && mSelectedDate.month() == previousDate.month())
        return;

    // Since our model is of a fixed size, we fill it once and assign values each time
    // the month changes, instead of clearing and appending each time.
    bool isEmpty = mVisibleDates.isEmpty();
    if (isEmpty) {
        beginResetModel();
        mVisibleDates.fill(QDate(), daysOnACalendarMonth);
    }

    // Ideally we'd display the 1st of the month as the first
    // day in the calendar, but typically it's not the first day of
    // the week, so we need to display some days before it.

    // The actual first (1st) day of the month.
    QDate firstDayOfMonthDate(mSelectedDate.year(), mSelectedDate.month(), 1);
    // The first day to display, if not the 1st of the month, will be
    // before the first day of the month.
    int difference = ((firstDayOfMonthDate.dayOfWeek() - mLocale.firstDayOfWeek()) + 7) % 7;
    // The first day before the 1st that is equal to this locale's firstDayOfWeek.
    QDate firstDateToDisplay = firstDayOfMonthDate.addDays(-difference);
    for (int i = 0; i < daysOnACalendarMonth; ++i) {
        mVisibleDates[i] = firstDateToDisplay.addDays(i);
    }

    mFirstVisibleDate = mVisibleDates.at(0);
    mLastVisibleDate = mVisibleDates.at(mVisibleDates.size() - 1);

    if (!isEmpty) {
        emit dataChanged(index(0, 0), index(rowCount() - 1, 0));
    } else {
        endResetModel();
    }
}
