/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components API Conformance Test Suite.
**
** No Commercial Usage
** This file contains pre-release code and may not be distributed.
** You may use this file in accordance with the terms and conditions contained
** in the Technology Preview License Agreement accompanying this package.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
****************************************************************************/

import QtQuick 1.0
import QtQuickTest 1.0

ComponentTestCase {
    name: "ButtonColumn"

    SpecButtonColumn {
        id: testSubject
    }

    function test_checkedButton() {}
    function test_exclusive() {
        var message =
            "The first button is checked by default when the object is created.";
        compare(obj.checkedButton, obj.children[0], message);

        var message =
            "Only the checkdButton should be checked when exclusive is true.";
        compare(obj.children[0].checked, true, message);
        compare(obj.children[1].checked, false, message);
        compare(obj.children[2].checked, false, message);

        var message =
            "Checking other button should unset the current checked button and " +
            "update checkedButton property.";
        obj.children[2].checked = true;
        compare(obj.checkedButton, obj.children[2], message);
        compare(obj.children[0].checked, false, message);
        compare(obj.children[1].checked, false, message);
        compare(obj.children[2].checked, true, message);

        var message =
            "Checking exclusive to false should allow multiple selections.";
        obj.exclusive = false;
        obj.children[1].checked = true;
        compare(obj.children[0].checked, false, message);
        compare(obj.children[1].checked, true, message);
        compare(obj.children[2].checked, true, message);

        var message =
            "Changing back exclusive to true, the last checked item should remain checked."
        obj.exclusive = true;
        compare(obj.checkedButton, obj.children[1], message);
        compare(obj.children[0].checked, false, message);
        compare(obj.children[1].checked, true, message);
        compare(obj.children[2].checked, false, message);

        var message =
            "Changing exclusive from false to true when no item is selected, should" +
            "select the first item.";
        obj.exclusive = false;
        obj.children[1].checked = false;
        compare(obj.checkedButton, undefined, message);
        compare(obj.children[0].checked, false, message);
        compare(obj.children[1].checked, false, message);
        compare(obj.children[2].checked, false, message);
        obj.exclusive = true;
        compare(obj.checkedButton, obj.children[0], message);
        compare(obj.children[0].checked, true, message);
        compare(obj.children[1].checked, false, message);
        compare(obj.children[2].checked, false, message);
    }
}
