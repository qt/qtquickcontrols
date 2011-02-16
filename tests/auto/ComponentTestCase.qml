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

import "ComponentTestCase.js" as Util

TestCase {
    property Item obj

    visible: true
    when: windowShown

    function init() {
        obj = testSubject.basic.createObject(this);
    }

    function cleanup() {
        obj.destroy();
    }

    function test_check_for_missing()
    {
        var apiSkeleton = testSubject.api.createObject(null);

        for (var prop in apiSkeleton) {
            if (prop.match(".+Changed$") || prop == "objectName")
                continue;

            if (typeof this["test_" + prop] != "function") {
                var type = (typeof apiSkeleton[prop] == "function" ? "function" : "property");
                warn("No functional test for " + type + ": "  + prop);
            }
        }

        apiSkeleton.destroy();
    }

    function benchmark_create_destroy() {
        var bechmarkObj = testSubject.basic.createObject(null);
        bechmarkObj.destroy();
    }

    function test_api_sanity() {
        Util.check_api(testSubject);
    }

    function test_defaults_sanity() {
        Util.check_defaults(testSubject);
    }
}
