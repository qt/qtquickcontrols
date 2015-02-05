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
import QtQuick.Controls 1.2

Item {
    id: main
    objectName: "main"
    width: 400
    height: 800
    focus: true
    Component.onCompleted: button1.focus = true
    Column {
        anchors.fill: parent
        id: column
        objectName: "column"
        Button {
            id: button1
            objectName: "button1"
            text: "button 1"
        }
        Button {
            id: button2
            objectName: "button2"
            text: "button 2"
        }
        Label {
            id: label
            objectName: "label"
            text: "label"
        }
        ToolButton {
            id: toolbutton
            objectName: "toolbutton"
            iconSource: "images/testIcon.png"
            tooltip: "Test Icon"
        }
        ListModel {
            id: choices
            ListElement { text: "Banana" }
            ListElement { text: "Orange" }
            ListElement { text: "Apple" }
            ListElement { text: "Coconut" }
        }
        ComboBox {
            id: combobox;
            objectName: "combobox"
            model: choices;
        }
        ComboBox {
            id: editable_combobox;
            objectName: "editable_combobox"
            model: choices;
            editable: true;
        }
        GroupBox {
            id: group1
            objectName: "group1"
            title: "GroupBox 1"
            checkable: true
            __checkbox.objectName: "group1_checkbox"
            Row {
                CheckBox {
                    id: checkbox1
                    objectName: "checkbox1"
                    text: "Text frame"
                    checked: true
                }
                CheckBox {
                    id: checkbox2
                    objectName: "checkbox2"
                    text: "Tickmarks"
                    checked: false
                }
            }
        }
        GroupBox {
            id: group2
            objectName: "group2"
            title: "GroupBox 2"
            Row {
                RadioButton {
                    id: radiobutton1
                    objectName: "radiobutton1"
                    text: "North"
                    checked: true
                }
                RadioButton {
                    id: radiobutton2
                    objectName: "radiobutton2"
                    text: "South"
                }
            }
        }
        //Page
        //ProgressBar maybe not need
        ProgressBar {
            id: progressbar
            objectName: "progressbar"
            indeterminate: true
        }
        //ScrollArea
        Slider {
            id: slider
            objectName: "slider"
            value: 0.5
        }
        SpinBox {
            id: spinbox
            objectName: "spinbox"
            width: 70
            minimumValue: 0
            maximumValue: 100
            value: 50
        }
        //SplitterColumn and SplitterRow false
        //StatusBar false
        TabView {
            id: tabview
            objectName: "tabview"
            width: 200
            Tab {
                id: tab1
                objectName: "tab1"
                title: "Tab1"
                Column {
                    id: column_in_tab1
                    objectName: "column_in_tab1"
                    anchors.fill: parent
                    Button {
                        id: tab1_btn1
                        objectName: "tab1_btn1"
                        text: "button 1 in Tab1"
                    }
                    Button {
                        id: tab1_btn2
                        objectName: "tab1_btn2"
                        text: "button 2 in Tab1"
                    }
                }
            }
            Tab {
                id: tab2
                objectName: "tab2"
                title: "Tab2"
                Column {
                    id: column_in_tab2
                    objectName: "column_in_tab2"
                    anchors.fill: parent
                    Button {
                        id: tab2_btn1
                        objectName: "tab2_btn1"
                        text: "button 1 in Tab2"
                    }
                    Button {
                        id: tab2_btn2
                        objectName: "tab2_btn2"
                        text: "button 2 in Tab2"
                    }
                }
            }
        }
        TextField {
            id: textfield
            objectName: "textfield"
            text: "abc"
        }
        TableView {
            id: tableview
            objectName: "tableview"
        }
        TextArea {
            id: textarea
            objectName: "textarea"
            text: "abc"
        }
    }
}
