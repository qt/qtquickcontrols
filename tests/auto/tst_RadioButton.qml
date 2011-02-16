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
    name: "RadioButton"

    SpecRadioButton {
        id: testSubject
    }

    SignalSpy {
        id: spy
        signalName: "clicked"
    }

    function test_clicked() {
        spy.target = obj;

        var message =
            "Clicking on the RadioButton must emit the signal clicked().";
        mouseClick(obj, obj.width / 2, obj.height / 2);
        mouseClick(obj, obj.width / 2, obj.height / 2);
        mouseClick(obj, obj.width / 2, obj.height / 2);
        compare(spy.count, 3, message);
    }

    function test_checked() {
        var message =
            "Clicking on the RadioButton should change the checked value.";
        mouseClick(obj, obj.width / 2, obj.height / 2);
        compare(obj.checked, true, message);
        mouseClick(obj, obj.width / 2, obj.height / 2);
        compare(obj.checked, false, message);
    }

    function test_pressed() {
        var message =
            "Pressing and releasing the mouse must change pressed property.";
        mousePress(obj, obj.width / 2, obj.height / 2);
        compare(obj.pressed, true, message);
        mouseRelease(obj, obj.width / 2, obj.height / 2);
        compare(obj.pressed, false, message);
    }
}
