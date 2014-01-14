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
import QtTest 1.0

Item {
    id: container
    width: 300
    height: 300

    TestCase {
        id: testcase
        name: "Tests_Calendar"
        when: windowShown
        readonly property int cellWidth: calendar !== undefined ? calendar.width / DateUtils.daysInAWeek : 0
        readonly property int cellHeight: calendar !== undefined ? calendar.height / 7 - navigationBarHeight : 0
        readonly property int navigationBarHeight: 40
        readonly property int firstDateCellX: cellWidth / 2
        readonly property int firstDateCellY: cellHeight / 2 + navigationBarHeight + cellHeight
        readonly property int previousMonthButtonX: navigationBarHeight / 2
        readonly property int previousMonthButtonY: navigationBarHeight / 2
        readonly property int nextMonthButtonX: calendar ? calendar.width - navigationBarHeight / 2 : 0
        readonly property int nextMonthButtonY: navigationBarHeight / 2

        property var calendar

        SignalSpy {
            id: signalSpy
        }

        function init() {
            calendar = Qt.createQmlObject("import QtQuick.Controls 1.1; " +
                " Calendar { }", container, "");
            calendar.width = 200;
            calendar.height = 200;
        }

        function cleanup() {
            signalSpy.clear();
        }

        function toPixelsX(cellPosX) {
            return firstDateCellX + cellPosX * cellWidth;
        }

        function toPixelsY(cellPosY) {
            return firstDateCellY + cellPosY * cellHeight;
        }

        function test_defaultConstructed() {
            calendar.minimumDate = new Date(1, 0, 1);
            calendar.maximumDate = new Date(4000, 0, 1);

            compare(calendar.minimumDate, new Date(1, 0, 1));
            compare(calendar.maximumDate, new Date(4000, 0, 1));
            compare(calendar.selectedDate, new Date(new Date().setHours(0, 0, 0, 0)));
            compare(calendar.navigationBarVisible, true);
            compare(calendar.dayOfWeekFormat, Locale.ShortFormat);
            compare(calendar.locale, Qt.locale());
            compare(calendar.selectedDateText,
                calendar.locale.standaloneMonthName(calendar.selectedDate.getMonth())
                    + calendar.selectedDate.toLocaleDateString(calendar.locale, " yyyy"));
        }

        function test_setAfterConstructed() {
            calendar.minimumDate = new Date(1900, 0, 1);
            calendar.maximumDate = new Date(1999, 11, 31);
            calendar.selectedDate = new Date(1980, 0, 1);
            calendar.navigationBarVisible = false;
            calendar.dayOfWeekFormat = Locale.NarrowFormat;
            calendar.locale = Qt.locale("de_DE");

            compare(calendar.minimumDate, new Date(1900, 0, 1));
            compare(calendar.maximumDate, new Date(1999, 11, 31));
            compare(calendar.selectedDate, new Date(1980, 0, 1));
            compare(calendar.navigationBarVisible, false);
            compare(calendar.locale, Qt.locale("de_DE"));
            compare(calendar.selectedDateText,
                calendar.locale.standaloneMonthName(calendar.selectedDate.getMonth())
                    + calendar.selectedDate.toLocaleDateString(calendar.locale, " yyyy"));
        }

        function test_selectedDate() {
            calendar.minimumDate = new Date(2012, 0, 1);
            calendar.maximumDate = new Date(2013, 0, 1);

            // Equal to minimumDate date.
            calendar.selectedDate = new Date(calendar.minimumDate);
            compare(calendar.selectedDate, calendar.minimumDate);

            // Outside minimum date.
            calendar.selectedDate.setDate(calendar.selectedDate.getDate() - 1);
            compare(calendar.selectedDate, calendar.minimumDate);

            // Equal to maximum date.
            calendar.selectedDate = new Date(calendar.maximumDate);
            compare(calendar.selectedDate, calendar.maximumDate);

            // Outside maximumDate date.
            calendar.selectedDate.setDate(calendar.selectedDate.getDate() - 1);
            compare(calendar.selectedDate, calendar.maximumDate);

            // Should not change.
            calendar.selectedDate = undefined;
            compare(calendar.selectedDate, calendar.maximumDate);
        }

        // Should be able to use the full JS date range.
        function test_minMaxJsDateRange() {
            calendar.minimumDate = DateUtils.minimumCalendarDate;
            calendar.maximumDate = DateUtils.maximumCalendarDate;

            calendar.selectedDate = DateUtils.minimumCalendarDate;
            compare(calendar.selectedDate, DateUtils.minimumCalendarDate);

            calendar.selectedDate = DateUtils.maximumCalendarDate;
            compare(calendar.selectedDate, DateUtils.maximumCalendarDate);
        }

        function test_minMaxUndefined() {

            var expected = new Date(calendar.minimumDate);
            calendar.minimumDate = undefined;
            compare(calendar.minimumDate, expected);

            expected = new Date(calendar.maximumDate);
            calendar.maximumDate = undefined;
            compare(calendar.maximumDate, expected);
        }

        function test_localisation() {
            calendar.selectedDate = new Date(2013, 0, 1);

            var locales = [Qt.locale().name, "en_AU", "en_GB", "en_US", "de_DE", "nb_NO",
                "pl_PL", "zh_CN", "fr_FR", "it_IT", "pt_BR", "ru_RU", "es_ES"];

            for (var i = 0; i < locales.length; ++i) {
                calendar.locale = Qt.locale(locales[i]);
                compare(calendar.selectedDateText,
                    calendar.locale.standaloneMonthName(calendar.selectedDate.getMonth())
                        + calendar.selectedDate.toLocaleDateString(calendar.locale, " yyyy"));
            }
        }

        function test_keyNavigation() {
            calendar.forceActiveFocus();
            calendar.selectedDate = new Date(2013, 0, 1);
            // Set this to a certain locale, because days will be in different
            // places depending on the system locale of the host machine.
            calendar.locale = Qt.locale("en_GB");

            /*         January 2013                    December 2012
                 M   T   W   T   F   S   S        M   T   W   T   F   S   S
                31  [1]  2   3   4   5   6       26  27  28  29  30   1   2
                 7   8   9  10  11  12  13        3   4   5   6   7   8   9
                14  15  16  17  18  19  20  ==>  10  11  12  13  14  15  16
                21  22  23  24  25  26  27       17  18  19  20  21  22  23
                28  29  30  31   1   2   3       24  25  26  27  28  29  30
                 4   5   6   7   8   9  10      [31]  1   2   3   4   5   6 */
            keyPress(Qt.Key_Left);
            compare(calendar.selectedDate, new Date(2012, 11, 31),
                "Selecting a day from the previous month should select that date.");

            /*        December 2012                    December 2012
                 M   T   W   T   F   S   S        M   T   W   T   F   S   S
                26  27  28  29  30   1   2       26  27  28  29  30   1   2
                 3   4   5   6   7   8   9        3   4   5   6   7   8   9
                10  11  12  13  14  15  16  ==>  10  11  12  13  14  15  16
                17  18  19  20  21  22  23       17  18  19  20  21  22  23
                24  25  26  27  28  29  30       24  25  26  27  28  29 [30]
               [31]  1   2   3   4   5   6       31   1   2   3   4   5   6 */
            keyPress(Qt.Key_Left);
            compare(calendar.selectedDate, new Date(2012, 11, 30),
                "Pressing the left key on the left edge should select the date "
                + "1 row above on the right edge.");

            /*        December 2012                    December 2012
                 M   T   W   T   F   S   S        M   T   W   T   F   S   S
                26  27  28  29  30   1   2       26  27  28  29  30   1   2
                 3   4   5   6   7   8   9        3   4   5   6   7   8   9
                10  11  12  13  14  15  16  ==>  10  11  12  13  14  15  16
                17  18  19  20  21  22  23       17  18  19  20  21  22  23
                24  25  26  27  28  29 [30]      24  25  26  27  28  29  30
                31   1   2   3   4   5   6      [31]  1   2   3   4   5   6 */
            keyPress(Qt.Key_Right);
            compare(calendar.selectedDate, new Date(2012, 11, 31),
                "Pressing the right key on the right edge should select the date "
                + "1 row below on the left edge.");

            /*          April 2013                        March 2013
                 M   T   W   T   F   S   S        M   T   W   T   F   S   S
                [1]  2   3   4   5   6   7       25  26  27  28   1   2   3
                 8   9  10  11  12  13  14        4   5   6   7   8   9  10
                15  16  17  18  19  20  21  ==>  11  12  13  14  15  16  17
                22  23  24  25  26  27  28       18  19  20  21  22  23  24
                29  30  31   1   2   3   4       25  26  27  28  29  30 [31]
                 5   6   7   8   9  10  11        1   2   3   4   5   6   7 */
            calendar.selectedDate = new Date(2013, 3, 1);
            keyPress(Qt.Key_Left);
            compare(calendar.selectedDate, new Date(2013, 2, 31),
                "Pressing the left key on the left edge of the first row should "
                + "select the last date of the previous month.");
        }

        function test_previousMonth() {
            calendar.selectedDate = new Date(2013, 0, 1);
            compare(calendar.selectedDate, new Date(2013, 0, 1));

            calendar.previousMonth();
            compare(calendar.selectedDate, new Date(2012, 11, 1));
        }

        function test_previousMonthWithMouse() {
            calendar.selectedDate = new Date(2013, 1, 28);
            compare(calendar.selectedDate, new Date(2013, 1, 28));

            mouseClick(calendar, previousMonthButtonX, previousMonthButtonY, Qt.LeftButton);
            compare(calendar.selectedDate, new Date(2013, 0, 28));

            mouseClick(calendar, previousMonthButtonX, previousMonthButtonY, Qt.LeftButton);
            compare(calendar.selectedDate, new Date(2012, 11, 28));
        }

        function test_nextMonth() {
            calendar.selectedDate = new Date(2013, 0, 31);
            compare(calendar.selectedDate, new Date(2013, 0, 31));

            calendar.nextMonth();
            compare(calendar.selectedDate, new Date(2013, 1, 28));

            calendar.nextMonth();
            compare(calendar.selectedDate, new Date(2013, 2, 28));
        }

        function test_nextMonthWithMouse() {
            calendar.selectedDate = new Date(2013, 0, 31);
            compare(calendar.selectedDate, new Date(2013, 0, 31));

            waitForRendering(calendar)

            mouseClick(calendar, nextMonthButtonX, nextMonthButtonY, Qt.LeftButton);
            compare(calendar.selectedDate, new Date(2013, 1, 28));

            mouseClick(calendar, nextMonthButtonX, nextMonthButtonY, Qt.LeftButton);
            compare(calendar.selectedDate, new Date(2013, 2, 28));
        }

        function test_selectDateWithMouse() {
            var startDate = new Date(2013, 0, 1);
            calendar.selectedDate = startDate;
            calendar.locale = Qt.locale("en_US");
            compare(calendar.selectedDate, startDate);

            // Clicking on header items should do nothing.
            mouseClick(calendar, 0, navigationBarHeight, Qt.LeftButton);
            compare(calendar.selectedDate, startDate);

            var firstVisibleDate = new Date(2012, 11, 30);
            for (var week = 0; week < DateUtils.weeksOnACalendarMonth; ++week) {
                for (var day = 0; day < DateUtils.daysInAWeek; ++day) {
                    var expectedDate = new Date(firstVisibleDate);
                    expectedDate.setDate(expectedDate.getDate() + (week * DateUtils.daysInAWeek + day));

                    mouseClick(calendar, toPixelsX(day), toPixelsY(week), Qt.LeftButton);
                    expectFail("", "TODO: Mouse click seems to go to cell above (header). Works manually.");
                    compare(calendar.selectedDate, expectedDate);

                    if (expectedDate.getMonth() != startDate.getMonth()) {
                        // A different month is being displayed as a result of the click;
                        // change back to the original month so our results are correct.
                        calendar.selectedDate = startDate;
                        compare(calendar.selectedDate, startDate);
                    }
                }
            }
        }

        function test_selectInvalidDateWithMouse() {
            var startDate = new Date(2013, 0, 1);
            calendar.minimumDate = new Date(2013, 0, 1);
            calendar.selectedDate = new Date(startDate);
            calendar.maximumDate = new Date(2013, 1, 5);
            calendar.locale = Qt.locale("no_NO");

            /*         January 2013
                 M   T   W   T   F   S   S
               [31]  1   2   3   4   5   6
                 7   8   9  10  11  12  13
                14  15  16  17  18  19  20
                21  22  23  24  25  26  27
                28  29  30  31   1   2   3
                 4   5   6   7   8   9  10 */
            mouseClick(calendar, toPixelsX(0), toPixelsY(0), Qt.LeftButton);
            compare(calendar.selectedDate, startDate);

            /*         January 2013                        December 2012
                 M   T   W   T   F   S   S            M   T   W   T   F   S   S
                31   1   2   3   4   5   6           31   1   2   3   4   5   6
                 7   8   9  10  11  12  13            7   8   9  10  11  12  13
                14  15  16  17  18  19  20  through  14  15  16  17  18  19  20
                21  22  23  24  25  26  27     to    21  22  23  24  25  26  27
                28  29  30  31   1   2   3           28  29  30  31   1   2   3
                 4   5  [6]  7   8   9  10            4   5   6   7   8   9 [10] */
            for (var x = 2; x < 7; ++x) {
                mouseClick(calendar, toPixelsX(x), toPixelsY(5), Qt.LeftButton);
                compare(calendar.selectedDate, startDate);
            }
        }

        function test_escapePressed() {
            signalSpy.signalName = "escapePressed";
            signalSpy.target = calendar;
            keyPress(Qt.Key_Escape);
            compare(signalSpy.count, 1);
        }
    }
}
