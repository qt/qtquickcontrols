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

import QtQuick 2.1
import QtTest 1.0
import QtQuick.Layouts 1.0

Item {
    id: container
    width: 200
    height: 200
    TestCase {
        id: testCase
        name: "Tests_RowLayout"
        when: windowShown
        width: 200
        height: 200

        function test_fixedAndExpanding() {
            var test_layoutStr =
               'import QtQuick 2.1;                     \
                import QtQuick.Layouts 1.0;             \
                RowLayout {                             \
                    id: row;                            \
                    width: 15;                          \
                    spacing: 0;                         \
                    property alias r1: _r1;             \
                    Rectangle {                         \
                        id: _r1;                        \
                        width: 5;                       \
                        height: 10;                     \
                        color: "#8080ff";               \
                        Layout.fillWidth: false         \
                    }                                   \
                    property alias r2: _r2;             \
                    Rectangle {                         \
                        id: _r2;                        \
                        width: 10;                      \
                        height: 20;                     \
                        color: "#c0c0ff";               \
                        Layout.fillWidth: true          \
                    }                                   \
                }                                       '

            var lay = Qt.createQmlObject(test_layoutStr, container, '');
            tryCompare(lay, 'implicitWidth', 15);
            compare(lay.implicitHeight, 20);
            compare(lay.height, 20);
            lay.width = 30
            compare(lay.r1.x, 0);
            compare(lay.r1.width, 5);
            compare(lay.r2.x, 5);
            compare(lay.r2.width, 25);
            lay.destroy()
        }

        function test_allExpanding() {
            var test_layoutStr =
               'import QtQuick 2.1;                     \
                import QtQuick.Layouts 1.0;             \
                RowLayout {                             \
                    id: row;                            \
                    width: 15;                          \
                    spacing: 0;                         \
                    property alias r1: _r1;             \
                    Rectangle {                         \
                        id: _r1;                        \
                        width: 5;                       \
                        height: 10;                     \
                        color: "#8080ff";               \
                        Layout.fillWidth: true          \
                    }                                   \
                    property alias r2: _r2;             \
                    Rectangle {                         \
                        id: _r2;                        \
                        width: 10;                      \
                        height: 20;                     \
                        color: "#c0c0ff";               \
                        Layout.fillWidth: true          \
                    }                                   \
                }                                       '

            var tmp = Qt.createQmlObject(test_layoutStr, container, '');
            tryCompare(tmp, 'implicitWidth', 15);
            compare(tmp.implicitHeight, 20);
            compare(tmp.height, 20);
            tmp.width = 30
            compare(tmp.r1.width, 10);
            compare(tmp.r2.width, 20);
            tmp.destroy()
        }

        function test_initialNestedLayouts() {
            var test_layoutStr =
               'import QtQuick 2.1;                             \
                import QtQuick.Layouts 1.0;                     \
                ColumnLayout {                                  \
                    id : col;                                   \
                    property alias row: _row;                   \
                    objectName: "col";                          \
                    anchors.fill: parent;                       \
                    RowLayout {                                 \
                        id : _row;                              \
                        property alias r1: _r1;                 \
                        property alias r2: _r2;                 \
                        objectName: "row";                      \
                        spacing: 0;                             \
                        Rectangle {                             \
                            id: _r1;                            \
                            color: "red";                       \
                            implicitWidth: 50;                  \
                            implicitHeight: 20;                 \
                        }                                       \
                        Rectangle {                             \
                            id: _r2;                            \
                            color: "green";                     \
                            implicitWidth: 50;                  \
                            implicitHeight: 20;                 \
                            Layout.fillWidth: true;             \
                        }                                       \
                    }                                           \
                }                                               '
            var col = Qt.createQmlObject(test_layoutStr, container, '');
            tryCompare(col, 'width', 200);
            tryCompare(col.row, 'width', 200);
            tryCompare(col.row.r1, 'width', 50);
            tryCompare(col.row.r2, 'width', 150);
            col.destroy()
        }

        function test_implicitSize() {
            var test_layoutStr =
               'import QtQuick 2.1;                             \
                import QtQuick.Layouts 1.0;                     \
                RowLayout {                                     \
                    id: row;                                    \
                    objectName: "row";                          \
                    spacing: 0;                                 \
                    height: 30;                                 \
                    anchors.left: parent.left;                  \
                    anchors.right: parent.right;                \
                    Rectangle {                                 \
                        color: "red";                           \
                        height: 2;                              \
                        Layout.minimumWidth: 50;                \
                    }                                           \
                    Rectangle {                                 \
                        color: "green";                         \
                        width: 10;                              \
                        Layout.minimumHeight: 4;                \
                    }                                           \
                    Rectangle {                                 \
                        implicitWidth: 1000;                    \
                        Layout.maximumWidth: 40;                \
                        implicitHeight: 6                       \
                    }                                           \
                }                                               '
            var row = Qt.createQmlObject(test_layoutStr, container, '');
            compare(row.implicitWidth, 50 + 10 + 40);
            compare(row.implicitHeight, 6);
            row.destroy()
        }

        function test_countGeometryChanges() {
            var test_layoutStr =
               'import QtQuick 2.1;                             \
                import QtQuick.Layouts 1.0;                     \
                ColumnLayout {                                  \
                    id : col;                                   \
                    property alias row: _row;                   \
                    objectName: "col";                          \
                    anchors.fill: parent;                       \
                    RowLayout {                                 \
                        id : _row;                              \
                        property alias r1: _r1;                 \
                        property alias r2: _r2;                 \
                        objectName: "row";                      \
                        spacing: 0;                             \
                        property int counter : 0;               \
                        onWidthChanged: { ++counter; }          \
                        Rectangle {                             \
                            id: _r1;                            \
                            color: "red";                       \
                            implicitWidth: 50;                  \
                            implicitHeight: 20;                 \
                            property int counter : 0;           \
                            onWidthChanged: { ++counter; }      \
                            Layout.fillWidth: true;             \
                        }                                       \
                        Rectangle {                             \
                            id: _r2;                            \
                            color: "green";                     \
                            implicitWidth: 50;                  \
                            implicitHeight: 20;                 \
                            property int counter : 0;           \
                            onWidthChanged: { ++counter; }      \
                            Layout.fillWidth: true;             \
                        }                                       \
                    }                                           \
                }                                               '
            var col = Qt.createQmlObject(test_layoutStr, container, '');
            compare(col.width, 200);
            compare(col.row.width, 200);
            compare(col.row.r1.width, 100);
            compare(col.row.r2.width, 100);
            compare(col.row.r1.counter, 1);
            compare(col.row.r2.counter, 1);
            verify(col.row.counter <= 2);
            col.destroy()
        }

        Component {
            id: layout_alignment_Component
            GridLayout {
                columns: 2
                columnSpacing: 0
                rowSpacing: 0
                Rectangle {
                    // First one should auto position itself at (0,0)
                    color: "red"
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                Rectangle {
                    // (0,1)
                    color: "red"
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    Layout.alignment: Qt.AlignBottom
                }
                Rectangle {
                    // (1,0)
                    color: "red"
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    Layout.alignment: Qt.AlignRight
                }
                Rectangle {
                    // (1,1)
                    color: "red"
                    Layout.preferredWidth: 10
                    Layout.preferredHeight: 10
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                }
                Rectangle {
                    // (2,0)
                    color: "red"
                    Layout.preferredWidth: 30
                    Layout.preferredHeight: 30
                    Layout.alignment: Qt.AlignRight
                    Layout.columnSpan: 2
                }
            }
        }

        function itemRect(item)
        {
            return [item.x, item.y, item.width, item.height];
        }

        function test_alignment()
        {
            var layout = layout_alignment_Component.createObject(container);
            layout.width = 60;
            layout.height = 90;

            compare(itemRect(layout.children[0]), [ 0,  0, 40, 40]);
            compare(itemRect(layout.children[1]), [40, 20, 20, 20]);
            compare(itemRect(layout.children[2]), [20, 40, 20, 20]);
            compare(itemRect(layout.children[3]), [45, 40, 10, 10]);
            compare(itemRect(layout.children[4]), [30, 60, 30, 30]);
            layout.destroy();
        }

        Component {
            id: layout_sizeHintNormalization_Component
            GridLayout {
                columnSpacing: 0
                rowSpacing: 0
                Rectangle {
                    id: r1
                    color: "red"
                    Layout.minimumWidth: 1
                    Layout.preferredWidth: 2
                    Layout.maximumWidth: 3

                    Layout.minimumHeight: 20
                    Layout.preferredHeight: 20
                    Layout.maximumHeight: 20
                    Layout.fillWidth: true
                }
            }
        }

        function test_sizeHintNormalization_data() {
            return [
                    { tag: "fallbackValues",  widthHints: [-1, -1, -1], expected:[0,42,1000000000], implicitWidth: 42},
                    { tag: "acceptZeroWidths",  widthHints: [0, 0, 0], expected:[0,0,0], implicitWidth: 42},
                    { tag: "123",  widthHints: [1,2,3],  expected:[1,2,3]},
                    { tag: "132",  widthHints: [1,3,2],  expected:[1,2,2]},
                    { tag: "213",  widthHints: [2,1,3],  expected:[2,2,3]},
                    { tag: "231",  widthHints: [2,3,1],  expected:[1,1,1]},
                    { tag: "321",  widthHints: [3,2,1],  expected:[1,1,1]},
                    { tag: "312",  widthHints: [3,1,2],  expected:[2,2,2]},

                    { tag: "1i3",  widthHints: [1,-1,3],  expected:[1,2,3], implicitWidth: 2},
                    { tag: "1i2",  widthHints: [1,-1,2],  expected:[1,2,2], implicitWidth: 3},
                    { tag: "2i3",  widthHints: [2,-1,3],  expected:[2,2,3], implicitWidth: 1},
                    { tag: "2i1",  widthHints: [2,-1,1],  expected:[1,1,1], implicitWidth: 3},
                    { tag: "3i1",  widthHints: [3,-1,1],  expected:[1,1,1], implicitWidth: 2},
                    { tag: "3i2",  widthHints: [3,-1,2],  expected:[2,2,2], implicitWidth: 1},
                    ];
        }

        function test_sizeHintNormalization(data) {
            var layout = layout_sizeHintNormalization_Component.createObject(container);
            if (data.implicitWidth !== undefined) {
                layout.children[0].implicitWidth = data.implicitWidth
            }
            layout.children[0].Layout.minimumWidth = data.widthHints[0];
            layout.children[0].Layout.preferredWidth = data.widthHints[1];
            layout.children[0].Layout.maximumWidth = data.widthHints[2];
            wait(0);    // Trigger processEvents() (allow LayoutRequest to be processed)
            var normalizedResult = [layout.Layout.minimumWidth, layout.implicitWidth, layout.Layout.maximumWidth]
            compare(normalizedResult, data.expected);
            layout.destroy();
        }
    }
}
