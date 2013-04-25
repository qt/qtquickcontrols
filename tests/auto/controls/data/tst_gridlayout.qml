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
        name: "Tests_GridLayout"
        when: windowShown
        width: 200
        height: 200

        function itemRect(item)
        {
            return [item.x, item.y, item.width, item.height];
        }

        Component {
            id: layout_flow_Component
            GridLayout {
                columns: 4
                columnSpacing: 0
                rowSpacing: 0
                Repeater {
                    model: 6
                    Rectangle {
                        color: "red"
                        Layout.preferredWidth: 10
                        Layout.preferredHeight: 10
                        Text { text: index }
                    }
                }
            }
        }

        function test_flow()
        {
            var layout = layout_flow_Component.createObject(container);
            compare(itemRect(layout.children[0]), [ 0,  0, 10, 10])
            compare(itemRect(layout.children[1]), [10,  0, 10, 10])
            compare(itemRect(layout.children[2]), [20,  0, 10, 10])
            compare(itemRect(layout.children[3]), [30,  0, 10, 10])

            compare(itemRect(layout.children[4]), [ 0, 10, 10, 10])
            compare(itemRect(layout.children[5]), [10, 10, 10, 10])

            layout.rows = 4
            layout.flow = GridLayout.TopToBottom
            compare(itemRect(layout.children[0]), [ 0,  0, 10, 10])
            compare(itemRect(layout.children[1]), [ 0, 10, 10, 10])
            compare(itemRect(layout.children[2]), [ 0, 20, 10, 10])
            compare(itemRect(layout.children[3]), [ 0, 30, 10, 10])

            compare(itemRect(layout.children[4]), [10,  0, 10, 10])
            compare(itemRect(layout.children[5]), [10, 10, 10, 10])
        }

        Component {
            id: layout_flowLeftToRight_Component
            GridLayout {
                columns: 4
                columnSpacing: 0
                rowSpacing: 0
                // red rectangles are auto-positioned
                // black rectangles are explicitly positioned with row,column
                Rectangle {
                    // First one should auto position itself at (0,0)
                    id: r1
                    color: "red"
                    width: 20
                    height: 20
                }
                Rectangle {
                    // (1,1)
                    id: r2
                    color: "black"
                    width: 20
                    height: 20
                    Layout.row: 1
                    Layout.column: 1
                    Layout.rowSpan: 2
                    Layout.columnSpan: 2
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
                Rectangle {
                    // (0,1)
                    id: r3
                    color: "black"
                    width: 20
                    height: 20
                    Layout.row: 0
                    Layout.column: 1
                }
                Rectangle {
                    // This one won't fit on the left and right sides of the big black box
                    // inserted at (3,0)
                    id: r4
                    color: "red"
                    width: 20
                    height: 20
                    Layout.columnSpan: 2
                    Layout.rowSpan: 2
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
                Rectangle {
                    // continue flow from (0,2)
                    id: r5
                    color: "black"
                    width: 20
                    height: 20
                    Layout.row: 0
                    Layout.column: 2
                }
                Repeater {
                    // ...and let the rest of the items automatically fill in the empty cells
                    model: 8
                    Rectangle {
                        color: "red"
                        width: 20
                        height: 20
                        Text { text: index }
                    }
                }
            }
        }

        function test_flowLeftToRight() {
            var layout = layout_flowLeftToRight_Component.createObject(container);
            compare(layout.implicitWidth, 80);
            compare(layout.children[0].x, 0);
            compare(layout.children[0].y, 0);
            compare(layout.children[1].x, 20);
            compare(layout.children[1].y, 20);
            compare(layout.children[2].x, 20);
            compare(layout.children[2].y, 0);
            compare(layout.children[3].x, 0);
            compare(layout.children[3].y, 60);
            compare(layout.children[4].x, 40);
            compare(layout.children[4].y, 0);

            // assumes that the repeater is the last item among the items it creates
            compare(layout.children[5].x, 60);
            compare(layout.children[5].y, 00);
            compare(layout.children[6].x, 00);
            compare(layout.children[6].y, 20);
            compare(layout.children[7].x, 60);
            compare(layout.children[7].y, 20);
            compare(layout.children[8].x, 00);
            compare(layout.children[8].y, 40);
            compare(layout.children[9].x, 60);
            compare(layout.children[9].y, 40);
            compare(layout.children[10].x, 40);
            compare(layout.children[10].y, 60);
            compare(layout.children[11].x, 60);
            compare(layout.children[11].y, 60);
            compare(layout.children[12].x, 40);
            compare(layout.children[12].y, 80);

            layout.destroy();
        }


        Component {
            id: layout_flowLeftToRightDefaultPositions_Component
            GridLayout {
                columns: 2
                columnSpacing: 0
                rowSpacing: 0
                // red rectangles are auto-positioned
                // black rectangles are explicitly positioned with row,column
                // gray rectangles are items with just one row or just one column specified
                Rectangle {
                    // First one should auto position itself at (0,0)
                    id: r1
                    color: "red"
                    width: 20
                    height: 20
                }
                Rectangle {
                    // (1,0)
                    id: r2
                    color: "gray"
                    width: 20
                    height: 20
                    Layout.row: 1
                }
                Rectangle {
                    // (1,1)
                    id: r3
                    color: "black"
                    width: 20
                    height: 20
                    Layout.row: 1
                    Layout.column: 1
                }
                Rectangle {
                    // (1,0), warning emitted
                    id: r4
                    color: "gray"
                    width: 20
                    height: 20
                    Layout.row: 1
                }
            }
        }

        function test_flowLeftToRightDefaultPositions() {
            ignoreWarning("QGridLayoutEngine::addItem: Cell (1, 0) already taken");
            var layout = layout_flowLeftToRightDefaultPositions_Component.createObject(container);
            compare(layout.implicitWidth, 40);
            compare(layout.children[0].x, 0);
            compare(layout.children[0].y, 0);
            compare(layout.children[1].x, 0);
            compare(layout.children[1].y, 20);
            compare(layout.children[2].x, 20);
            compare(layout.children[2].y, 20);
            layout.destroy();
        }


        Component {
            id: layout_flowTopToBottom_Component
            GridLayout {
                rows: 4
                columnSpacing: 0
                rowSpacing: 0
                flow: GridLayout.TopToBottom
                // red rectangles are auto-positioned
                // black rectangles are explicitly positioned with row,column
                Rectangle {
                    // First one should auto position itself at (0,0)
                    id: r1
                    color: "red"
                    width: 20
                    height: 20
                }
                Rectangle {
                    // (1,1)
                    id: r2
                    color: "black"
                    width: 20
                    height: 20
                    Layout.row: 1
                    Layout.column: 1
                    Layout.rowSpan: 2
                    Layout.columnSpan: 2
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
                Rectangle {
                    // (2,0)
                    id: r3
                    color: "black"
                    width: 20
                    height: 20
                    Layout.row: 2
                    Layout.column: 0
                }
                Rectangle {
                    // This one won't fit on the left and right sides of the big black box
                    // inserted at (0,3)
                    id: r4
                    color: "red"
                    width: 20
                    height: 20
                    Layout.rowSpan: 2
                    Layout.fillHeight: true
                }
                Rectangle {
                    // continue flow from (1,0)
                    id: r5
                    color: "black"
                    width: 20
                    height: 20
                    Layout.row: 1
                    Layout.column: 0
                }
                Repeater {
                    // ...and let the rest of the items automatically fill in the empty cells
                    model: 8
                    Rectangle {
                        color: "red"
                        width: 20
                        height: 20
                        Text { text: index }
                    }
                }
            }
        }

        function test_flowTopToBottom() {
            var layout = layout_flowTopToBottom_Component.createObject(container);
            compare(layout.children[0].x, 0);
            compare(layout.children[0].y, 0);
            compare(layout.children[1].x, 20);
            compare(layout.children[1].y, 20);
            compare(layout.children[2].x, 0);
            compare(layout.children[2].y, 40);
            compare(layout.children[3].x, 60);
            compare(layout.children[3].y, 0);
            compare(layout.children[4].x, 0);
            compare(layout.children[4].y, 20);

            // The repeated items
            compare(layout.children[5].x, 0);
            compare(layout.children[5].y, 60);
            compare(layout.children[6].x, 20);
            compare(layout.children[6].y, 0);
            compare(layout.children[7].x, 20);
            compare(layout.children[7].y, 60);
            compare(layout.children[8].x, 40);
            compare(layout.children[8].y, 0);
            compare(layout.children[9].x, 40);
            compare(layout.children[9].y, 60);
            compare(layout.children[10].x, 60);
            compare(layout.children[10].y, 40);
            compare(layout.children[11].x, 60);
            compare(layout.children[11].y, 60);
            compare(layout.children[12].x, 80);
            compare(layout.children[12].y, 0);

            layout.destroy();
        }

        Component {
            id: layout_spanAcrossEmptyRows_Component
            /* This test has a large number of empty rows and columns, but there is one item
               that spans across some of these empty rows/columns.
               Do not modify (especially do not add items unless you understand what this is
               testing)
             */

            GridLayout {
                columnSpacing: 0
                rowSpacing: 0
                // black rectangles are explicitly positioned with row,column
                Rectangle {
                    // (0,0)
                    id: r0
                    color: "black"
                    Layout.row: 0
                    Layout.column: 0
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    Layout.maximumWidth: 40
                    Layout.maximumHeight: 40
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                Rectangle {
                    // (0,1)
                    id: r1
                    color: "black"
                    Layout.row: 0
                    Layout.column: 1
                    Layout.columnSpan: 2
                    Layout.rowSpan: 2
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    Layout.maximumWidth: 40
                    Layout.maximumHeight: 40
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                Rectangle {
                    // (0,99)
                    id: r2
                    color: "black"
                    Layout.row: 0
                    Layout.column: 99
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    Layout.maximumWidth: 40
                    Layout.maximumHeight: 40
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }

        function test_spanAcrossEmptyRows() {
            var layout = layout_spanAcrossEmptyRows_Component.createObject(container);
            compare(layout.children[0].x, 0);
            compare(layout.children[0].y, 0);
            compare(layout.children[1].x, 20);
            compare(layout.children[1].y, 0);
            compare(layout.children[2].x, 40);
            compare(layout.children[2].y, 0);

            compare(layout.implicitWidth, 60);
            compare(layout.Layout.maximumWidth, 120);

            layout.destroy();
        }


        function test_sizeHints() {
            var layout = layout_spanAcrossEmptyRows_Component.createObject(container);
            compare(layout.visible, true)

            var minWidth  = layout.Layout.minimumWidth
            var minHeight = layout.Layout.minimumHeight

            var prefWidth  = layout.implicitWidth
            var prefHeight = layout.implicitHeight

            var maxWidth  = layout.Layout.maximumWidth
            var maxHeight = layout.Layout.maximumHeight

            layout.visible = false
            compare(minWidth, layout.Layout.minimumWidth)
            compare(minHeight, layout.Layout.minimumHeight)
            compare(prefWidth, layout.implicitWidth)
            compare(prefHeight, layout.implicitHeight)
            compare(maxWidth, layout.Layout.maximumWidth)
            compare(maxHeight, layout.Layout.maximumHeight)

            layout.destroy();
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

    }
}
