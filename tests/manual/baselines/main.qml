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
import QtQuick.Layouts 1.1

ApplicationWindow {
    id: window
    property variant defaultAlignment: Qt.AlignBaseline
    title: "Layouts with baselines"
    property int margin: 11
    width: mainLayout.implicitWidth + 2 * margin
    height: mainLayout.implicitHeight + 2 * margin
    minimumWidth: mainLayout.Layout.minimumWidth + 2 * margin
    minimumHeight: mainLayout.Layout.minimumHeight + 2 * margin

    Component {
        id: visualBaselineComponent
        Rectangle {
            height: 1
            width: 1
            color: 'red'
        }
    }

    Item {
        id: visualBaselinesContainer
        width: parent.width
        z: 1
        opacity: 0.5

        function setBaselinesVisible(showBaselines) {
            for (var i = 0; i < visualBaselinesContainer.children.length; ++i) {
                visualBaselinesContainer.children[i].destroy();
            }
            if (showBaselines) {
                // assumes mainLayout/GroupBox/Layout/<child_items> hierarchy
                // Iterates over all <child_items> and gathers their baseline positions,
                var map_baselines = {}
                for (var i = 0; i < mainLayout.children.length; ++i) {
                    var grp = mainLayout.children[i]
                    var lay = grp.contentItem.children[0]
                    var y = mainLayout.y + grp.y + grp.contentItem.y + lay.y
                    var x = mainLayout.x + grp.x + grp.contentItem.x + lay.x
                    var w = lay.width
                    for (var j = 0; j < lay.children.length; ++j) {
                        var child = lay.children[j];
                        if (child.visible && child.baselineOffset > 0) {
                            var baseline = y + child.y + child.baselineOffset
                            map_baselines[baseline] = {x: x, width: w};
                        }
                    }
                }

                for (var key in map_baselines) {
                    var o = map_baselines[key];
                    var visualBaseline = visualBaselineComponent.createObject(visualBaselinesContainer, o);
                    visualBaseline.y = key;
                }
            }
        }
        Timer {
            // This is a kludge to wait until the layout has been rearranged, since that won't
            // happen until we get a polish event.
            // This will wait minimum of one full vertical scan (17 milliseconds), which
            // should usually be enough
            id: refreshBaselinesTimer
            running: false
            interval: 17
            onTriggered: {
                visualBaselinesContainer.setBaselinesVisible(ckShowBaselines.checked);
            }
        }
    }

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: margin

        GroupBox {
            id: rowBoxTools
            title: "Developer tools"
            Layout.fillWidth: true
            RowLayout {
                anchors.fill: parent
                CheckBox {
                    id: ckShowBaselines
                    text: "Show baselines"
                    checked: false
                    onCheckedChanged: {
                        visualBaselinesContainer.setBaselinesVisible(checked);
                    }
                }
                Label {
                    text: "Alignment:"
                }
                ComboBox {
                    model: ListModel {
                        id: cbItems
                        ListElement { text: "Default"; value: 0 }
                        ListElement { text: "Align Left"; value: Qt.AlignLeft }
                        ListElement { text: "Align Right"; value: Qt.AlignRight }
                        ListElement { text: "Align HCenter"; value: Qt.AlignHCenter }
                        ListElement { text: "Align Baseline"; value: Qt.AlignBaseline }
                        ListElement { text: "Align Top"; value: Qt.AlignTop }
                        ListElement { text: "Align Bottom"; value: Qt.AlignBottom }
                        ListElement { text: "Align VCenter"; value: Qt.AlignVCenter }
                    }
                    Component.onCompleted: {
                        for (var i = 0; i < cbItems.count; ++i) {
                            var v = cbItems.get(i).value;
                            if (v == defaultAlignment) {
                                currentIndex = i;
                                break;
                            }
                        }
                    }
                    onCurrentIndexChanged: {
                        // assumes mainLayout/GroupBox/Layout/<child_items> hierarchy
                        // Iterates over all <child_items> and modifies their baseline alignment
                        for (var i = 0; i < mainLayout.children.length; ++i) {
                            var grp = mainLayout.children[i]
                            var lay = grp.contentItem.children[0]
                            for (var j = 0; j < lay.children.length; ++j) {
                                var child = lay.children[j];
                                child.Layout.alignment = cbItems.get(currentIndex).value
                            }
                        }
                        refreshBaselinesTimer.start();
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }
        GroupBox {
            id: rowBox
            title: "Row layout"
            Layout.fillWidth: true

            RowLayout {
                id: rowLayout
                anchors.fill: parent
                Repeater {
                    model: 3
                    Text {
                        text: "Typography"
                        font.pixelSize: 10 + 4*index
                        Layout.alignment: defaultAlignment
                        Layout.fillWidth: index == 2
                    }
                }
            }
        }

        GroupBox {
            id: gridBox
            title: "Grid layout"
            Layout.fillWidth: true

            GridLayout {
                id: gridLayout
                anchors.fill: parent
                rows: 2
                flow: GridLayout.TopToBottom
                Repeater {
                    model: 6
                    Text {
                        text: "Typography"
                        font.pixelSize: 8 + 4*index
                        Layout.alignment: defaultAlignment
                    }
                }
            }
        }


        GroupBox {
            id: rowBoxWithControls
            title: "Row layout with Controls"
            Layout.fillWidth: true

            RowLayout {
                id: rowLayoutWithControls
                anchors.fill: parent
                Label {
                    id: rowlabel
                    text: "Typo"
                    Layout.alignment: defaultAlignment
                }
                Button {
                    text: "Typo"
                    Layout.alignment: defaultAlignment
                }
                CheckBox {
                    text: "Typo"
                    Layout.alignment: defaultAlignment
                }
                ComboBox {
                    model: ["Typo"]
                    currentIndex: 0
                    Layout.alignment: defaultAlignment
                }
                RadioButton {
                    text: "Typo"
                    Layout.alignment: defaultAlignment
                }
                SpinBox {
                    value: 42
                    Layout.alignment: defaultAlignment
                }
                TextField {
                    text: "Typo"
                    Layout.alignment: defaultAlignment
                    Layout.maximumWidth: 40
                }
            }

        }

        GroupBox {
            id: gridBoxWithControls
            title: "Grid layout with Controls"
            Layout.fillWidth: true

            GridLayout {
                id: gridLayoutWithControls
                columns: 3
                flow: GridLayout.LeftToRight
                anchors.fill: parent
                Label {
                    text: "Typography"
                    Layout.alignment: defaultAlignment
                }
                Button {
                    text: "Typography"
                    Layout.alignment: defaultAlignment
                }
                CheckBox {
                    text: "Typography"
                    Layout.alignment: defaultAlignment
                }
                ComboBox {
                    model: ["Typography"]
                    currentIndex: 0
                    Layout.alignment: defaultAlignment
                }
                RadioButton {
                    text: "Typography"
                    Layout.alignment: defaultAlignment
                }
                SpinBox {
                    value: 42
                    Layout.alignment: defaultAlignment
                }
                TextField {
                    id: gridTextField
                    text: "Typography"
                    Layout.alignment: defaultAlignment
                }
            }
        }
    }
}
