/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the test suite of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2
import QtTest 1.0

TestCase {
    id: testcase
    name: "Tests_Keys"
    when: windowShown
    visible: true
    width: 400
    height: 400

    function test_keys_data() {
        return [
            // note: test identical Keys behavior for TextInput and TextField
            {tag:"TextInput", control: "TextInput", properties: "text: '0'"},
            {tag:"TextField", control: "TextField", properties: "text: '0'"},

            // note: test identical Keys behavior for TextEdit and TextArea
            {tag:"TextEdit", control: "TextEdit", properties: "text: '0'"},
            {tag:"TextArea", control: "TextArea", properties: "text: '0'"},

            {tag:"SpinBox", control: "SpinBox", properties: "value: 0"},
            {tag:"ComboBox", control: "ComboBox", properties: "currentIndex: 0; model: 3; editable: true;"},
        ]
    }

    function test_keys(data) {
        var qml = qsTr("import QtQuick 2.2;\
                        import QtQuick.Controls 1.2;\
                        Item {\
                            id: window;\
                            focus: true;\
                            width: 400; height: 400;\
                            property alias control: control;\
                            property var pressedKeys: [];\
                            property var releasedKeys: [];\
                            Keys.onPressed: { var keys = pressedKeys; keys.push(event.key); pressedKeys = keys; }\
                            Keys.onReleased: { var keys = releasedKeys; keys.push(event.key); releasedKeys = keys; }\
                            %1 {\
                                id: control;\
                                property bool accept: false;
                                property var pressedKeys: [];\
                                property var releasedKeys: [];\
                                Keys.onPressed: { var keys = pressedKeys; keys.push(event.key); pressedKeys = keys; event.accepted = accept; }\
                                Keys.onReleased: { var keys = releasedKeys; keys.push(event.key); releasedKeys = keys; event.accepted = accept; }\
                                %2\
                            }
                        }").arg(data.control).arg(data.properties)

        var window = Qt.createQmlObject(qml, testcase, "")

        verify(window)
        verify(window.control)
        waitForRendering(window)

        window.forceActiveFocus()
        verify(window.activeFocus)

        // check that parent's key events don't end up in the control
        keyPress(Qt.Key_0)
        compare(window.pressedKeys, [Qt.Key_0])
        compare(window.releasedKeys, [])
        compare(window.control.pressedKeys, [])
        compare(window.control.releasedKeys, [])
        keyRelease(Qt.Key_0)
        compare(window.pressedKeys, [Qt.Key_0])
        compare(window.releasedKeys, [Qt.Key_0])
        compare(window.control.pressedKeys, [])
        compare(window.control.releasedKeys, [])

        var editor = findEditor(window.control)
        verify(editor)
        editor.forceActiveFocus()
        verify(editor.activeFocus)
        compare(editor.text, "0")

        editor.text = ""
        window.control.accept = false

        // check that editor's key events end up in the control, but not further.
        // when a control doesn't accept the event, the editor does handle it.
        keyPress(Qt.Key_1)
        compare(window.control.pressedKeys, [Qt.Key_1])
        compare(window.control.releasedKeys, [])
        compare(window.pressedKeys, [Qt.Key_0])
        compare(window.releasedKeys, [Qt.Key_0])
        keyRelease(Qt.Key_1)
        compare(window.control.pressedKeys, [Qt.Key_1])
        // compare(window.control.releasedKeys, [Qt.Key_1]) // QTBUG-38289
        compare(window.pressedKeys, [Qt.Key_0])
        // compare(window.releasedKeys, [Qt.Key_0]) // QTBUG-38289
        compare(editor.text, "1") // editor handled

        editor.text = ""
        window.control.accept = true

        // check that editor's key events end up in the control, but not further.
        // when a control accepts the event, the editor doesn't handle it.
        keyPress(Qt.Key_2)
        compare(window.control.pressedKeys, [Qt.Key_1, Qt.Key_2])
        // compare(window.control.releasedKeys, [Qt.Key_1]) // QTBUG-38289
        compare(window.pressedKeys, [Qt.Key_0])
        // compare(window.releasedKeys, [Qt.Key_0]) // QTBUG-38289
        keyRelease(Qt.Key_2)
        compare(window.control.pressedKeys, [Qt.Key_1, Qt.Key_2])
        // compare(window.control.releasedKeys, [Qt.Key_1, Qt.Key_2]) // QTBUG-38289
        compare(window.pressedKeys, [Qt.Key_0])
        // compare(window.releasedKeys, [Qt.Key_0]) // QTBUG-38289
        compare(editor.text, "") // editor didn't handle

        window.destroy()
    }

    function findEditor(parent) {
        for (var i = 0; i < parent.children.length; ++i) {
            var child = parent.children[i]
            var editor = findEditor(child)
            if (editor)
                return editor
        }
        if (parent.hasOwnProperty("text") && parent.hasOwnProperty("readOnly")
            && parent.hasOwnProperty("copy") && parent["copy"] instanceof Function
            && parent.hasOwnProperty("paste") && parent["paste"] instanceof Function)
            return parent
        return null
    }
}
