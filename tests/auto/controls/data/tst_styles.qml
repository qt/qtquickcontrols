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

Item {
    id: container
    width: 400
    height: 400

    TestCase {
        id: testCase
        name: "Tests_Styles"
        when:windowShown
        width:400
        height:400

        function test_createButtonStyle() {
            var control = Qt.createQmlObject(
                        'import QtQuick 2.2; import QtQuick.Controls 1.2; import QtQuick.Controls.Styles 1.1; \
                    Rectangle { width: 50; height: 50;  property Component style: ButtonStyle {}}'
                        , container, '')
        }

        function test_createToolButtonStyle() {
            var control = Qt.createQmlObject(
                        'import QtQuick 2.2; import QtQuick.Controls 1.2; import QtQuick.Controls.Private 1.0; \
                    Rectangle { width: 50; height: 50;  property Component style: ToolButtonStyle {}}'
                        , container, '')
        }

        function test_createCheckBoxStyle() {
            var control = Qt.createQmlObject(
                        'import QtQuick 2.2; import QtQuick.Controls 1.2; import QtQuick.Controls.Styles 1.1; \
                    Rectangle { width: 50; height: 50;  property Component style: CheckBoxStyle {}}'
                        , container, '')
        }

        function test_createComboBoxStyle() {
            var control = Qt.createQmlObject(
                        'import QtQuick 2.2; import QtQuick.Controls 1.2; import QtQuick.Controls.Styles 1.1; \
                    Rectangle { width: 50; height: 50;  property Component style: ComboBoxStyle {}}'
                        , container, '')
        }

        function test_createRadioButtonStyle() {
            var control = Qt.createQmlObject(
                        'import QtQuick 2.2; import QtQuick.Controls 1.2; import QtQuick.Controls.Styles 1.1; \
                    Rectangle { width: 50; height: 50;  property Component style: RadioButtonStyle {}}'
                        , container, '')
        }

        function test_createProgressBarStyle() {
            var control = Qt.createQmlObject(
                        'import QtQuick 2.2; import QtQuick.Controls 1.2; import QtQuick.Controls.Styles 1.1; \
                    Rectangle { width: 50; height: 50;  property Component style: ProgressBarStyle {}}'
                        , container, '')
        }

        function test_createSliderStyle() {
            var control = Qt.createQmlObject(
                        'import QtQuick 2.2; import QtQuick.Controls 1.2; import QtQuick.Controls.Styles 1.1; \
                    Rectangle { width: 50; height: 50;  property Component style: SliderStyle {}}'
                        , container, '')
        }

        function test_createTextFieldStyle() {
            var control = Qt.createQmlObject(
                        'import QtQuick 2.2; import QtQuick.Controls 1.2; import QtQuick.Controls.Styles 1.1; \
                    Rectangle { width: 50; height: 50;  property Component style: TextFieldStyle {}}'
                        , container, '')
        }

        function test_createSpinBoxStyle() {
            var control = Qt.createQmlObject(
                        'import QtQuick 2.2; import QtQuick.Controls 1.2; import QtQuick.Controls.Styles 1.1; \
                    Rectangle { width: 50; height: 50;  property Component style: SpinBoxStyle {}}'
                        , container, '')
        }

        function test_createToolBarStyle() {
            var control = Qt.createQmlObject(
                        'import QtQuick 2.2; import QtQuick.Controls 1.2; import QtQuick.Controls.Styles 1.1; \
                    Rectangle { width: 50; height: 50;  property Component style: ToolBarStyle {}}'
                        , container, '')
        }

        function test_createStatusBarStyle() {
            var control = Qt.createQmlObject(
                        'import QtQuick 2.2; import QtQuick.Controls 1.2; import QtQuick.Controls.Styles 1.1; \
                    Rectangle { width: 50; height: 50;  property Component style: StatusBarStyle {}}'
                        , container, '')
        }

        function test_createTableViewStyle() {
            var control = Qt.createQmlObject(
                        'import QtQuick 2.2; import QtQuick.Controls 1.2; import QtQuick.Controls.Styles 1.1; \
                    Rectangle { width: 50; height: 50;  property Component style: TableViewStyle {}}'
                        , container, '')
        }

        function test_createScrollViewStyle() {
            var control = Qt.createQmlObject(
                        'import QtQuick 2.2; import QtQuick.Controls 1.2; import QtQuick.Controls.Styles 1.1; \
                    Rectangle { width: 50; height: 50;  property Component style: ScrollViewStyle {}}'
                        , container, '')
        }

        function test_createGroupBoxStyle() {
            var control = Qt.createQmlObject(
                        'import QtQuick 2.2; import QtQuick.Controls 1.2; import QtQuick.Controls.Private 1.0; \
                    Rectangle { width: 50; height: 50;  property Component style: GroupBoxStyle {}}'
                        , container, '')
        }

        function test_createTabViewStyle() {
            var control = Qt.createQmlObject(
                        'import QtQuick 2.2; import QtQuick.Controls 1.2; import QtQuick.Controls.Styles 1.1; \
                    Rectangle { width: 50; height: 50;  property Component style: TabViewStyle {}}'
                        , container, '')
        }

        function test_createTextAreaStyle() {
            var control = Qt.createQmlObject(
                        'import QtQuick 2.2; import QtQuick.Controls 1.2; import QtQuick.Controls.Styles 1.1; \
                    Rectangle { width: 50; height: 50;  property Component style: TextAreaStyle {}}'
                        , container, '')
        }
    }
}
