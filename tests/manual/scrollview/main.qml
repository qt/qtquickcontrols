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
import QtQuick.Layouts 1.0

ApplicationWindow {
    title: "Component Gallery"

    width: 580
    height: 400
    property string loremIpsum:
        "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor "+
        "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor "+
        "incididunt ut labore et dolore magna aliqua.\n Ut enim ad minim veniam, quis nostrud "+
        "exercitation ullamco laboris nisi ut aliquip ex ea commodo cosnsequat. ";

    SystemPalette {id: syspal}
    color: syspal.window

    toolBar: ToolBar {
        RowLayout {
            anchors.fill: parent
            anchors.margins: 4
            CheckBox {
                id: frameCheck
                text: "Frame"
                checked: true
                implicitWidth: 80
            }
            SpinBox {
                id : widthSpinBox
                maximumValue: 2000
                value: 1000
                implicitWidth: 80
            }
            SpinBox {
                id : heightSpinBox
                maximumValue: 2000
                value: 1000
                implicitWidth: 80
            }
            CheckBox {
                id: largeCheck
                text: "Large"
                checked: false
                implicitWidth: 80
            }
            Item { Layout.fillWidth: true }
        }
    }

    TabView {
        id:frame
        anchors.fill: parent
        anchors.margins: 4
        frameVisible: frameCheck.checked
        Tab {
            title: "Rectangle"
            ScrollView {
                anchors.fill: parent
                anchors.margins:4
                frameVisible: frameCheck.checked
                Rectangle {
                    width: widthSpinBox.value
                    height: heightSpinBox.value
                }
            }
        }
        Tab {
            title: "Image"
            ScrollView {
                anchors.fill: parent
                anchors.margins:4
                frameVisible: frameCheck.checked
                Image {
                    width: widthSpinBox.value
                    height: heightSpinBox.value
                    fillMode: Image.Tile
                    source: "../../../examples/quick/controls/touch/images/button_pressed.png"
                }
            }
        }
        Tab {
            title: "Flickable"
            ScrollView{
                anchors.fill: parent
                anchors.margins:4
                frameVisible: frameCheck.checked
                Flickable {
                    contentWidth: widthSpinBox.value
                    contentHeight: heightSpinBox.value
                    Image {
                        width: widthSpinBox.value
                        height: heightSpinBox.value
                        fillMode: Image.Tile
                        source: "../../../examples/quick/controls/touch/images/button_pressed.png"
                    }
                }
            }
        }
        Tab {
            title: "TextArea"
            TextArea {
                id: area
                anchors.margins:4
                frameVisible: frameCheck.checked
                text: loremIpsum + loremIpsum + loremIpsum + loremIpsum
                anchors.fill: parent
                font.pixelSize: largeCheck.checked ? 26 : 13
            }
        }
        Tab {
            title: "ListView"
            ScrollView{
                anchors.fill: parent
                anchors.margins:4
                frameVisible: frameCheck.checked
                ListView {
                    width: 400
                    model: 30
                    delegate: Rectangle {
                        width: parent.width
                        height: largeCheck.checked ? 60 : 30
                        Text {
                            anchors.fill: parent
                            anchors.margins: 4
                            text: modelData
                        }
                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 1
                            color: "darkgray"
                        }
                    }
                }
            }
        }
        Tab {
            title: "TableView"
            TableView {
                id: view
                anchors.margins:4
                anchors.fill: parent
                model: 10
                frameVisible: frameCheck.checked

                rowDelegate: Rectangle {
                     width: parent.width
                     height: largeCheck.checked ? 60 : 30
                     Rectangle {
                         anchors.bottom: parent.bottom
                         width: parent.width
                         height: 1
                         color: "darkgray"
                     }
                 }

                TableViewColumn {title: "first"
                    width: view.viewport.width
                }
            }
        }
    }
}

