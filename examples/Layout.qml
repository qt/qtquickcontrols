/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
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

import QtQuick 2.0
import QtDesktop 1.0

Item {
    width: 600
    height: 400

    property real defaultWidth: 30
    property real defaultHeight: 30

    TabFrame {
        id:frame
        anchors.fill: parent

        Tab {
            title: "Horizontal"

            Column {
                spacing: 4

                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: 10
                }

                // [1]
                RowLayout {
                    height: defaultHeight
                    anchors.left: parent.left
                    anchors.right: parent.right

                    Rectangle {
                        color: "red"
                        height: parent.height
                    }
                    Rectangle {
                        color: "green"
                        height: parent.height
                    }
                    Rectangle {
                        color: "blue"
                        height: parent.height
                    }
                }

                // [2]
                RowLayout {
                    height: defaultHeight
                    anchors.left: parent.left
                    anchors.right: parent.right

                    spacing: 5

                    Rectangle {
                        color: "red"
                        height: parent.height
                    }
                    Rectangle {
                        color: "green"
                        height: parent.height
                    }
                    Item {
                        implicitWidth: 10
                    }
                    Rectangle {
                        color: "blue"
                        height: parent.height
                    }
                }

                // [3]
                RowLayout {
                    height: defaultHeight
                    anchors.left: parent.left
                    anchors.right: parent.right

                    Rectangle {
                        color: "red"
                        height: parent.height
                        Layout.minimumWidth: 50
                        Layout.maximumWidth: 100
                        Layout.horizontalSizePolicy: Layout.Expanding
                    }
                    Rectangle {
                        color: "green"
                        height: parent.height
                        Layout.minimumWidth: 100
                        Layout.maximumWidth: 200
                        Layout.horizontalSizePolicy: Layout.Expanding
                    }
                    Rectangle {
                        color: "blue"
                        height: parent.height
                        Layout.minimumWidth: 200
                        Layout.maximumWidth: 400
                        Layout.horizontalSizePolicy: Layout.Expanding
                    }
                }

                // [4]
                RowLayout {
                    spacing: 100
                    height: defaultHeight
                    anchors.left: parent.left
                    anchors.right: parent.right

                    Rectangle {
                        color: "red"
                        height: parent.height
                        Layout.minimumWidth: 100
                        Layout.horizontalSizePolicy: Layout.Expanding
                    }
                    Rectangle {
                        color: "green"
                        height: parent.height
                        Layout.minimumWidth: 200
                        Layout.horizontalSizePolicy: Layout.Expanding
                    }
                    Rectangle {
                        color: "blue"
                        height: parent.height
                        Layout.minimumWidth: 300
                        Layout.horizontalSizePolicy: Layout.Expanding
                    }
                }

                // [5]
                RowLayout {
                    height: defaultHeight
                    anchors.left: parent.left
                    anchors.right: parent.right

                    Rectangle {
                        color: "red"
                        height: parent.height
                        Layout.minimumWidth: 200
                        Layout.maximumWidth: 500
                        Layout.horizontalSizePolicy: Layout.Expanding
                    }
                }

                // [6]
                RowLayout {
                    spacing: 40
                    height: defaultHeight
                    anchors.left: parent.left
                    anchors.right: parent.right

                    RowLayout {
                        spacing: 10
                        height: parent.height

                        Rectangle {
                            color: "red"
                            height: parent.height
                            Layout.minimumWidth: 100
                            Layout.horizontalSizePolicy: Layout.Expanding
                        }
                        Rectangle {
                            color: "blue"
                            height: parent.height
                            Layout.minimumWidth: 200
                            Layout.horizontalSizePolicy: Layout.Expanding
                        }
                    }

                    RowLayout {
                        spacing: 10
                        height: parent.height

                        Rectangle {
                            color: "green"
                            height: parent.height
                            Layout.maximumWidth: 300
                            Layout.horizontalSizePolicy: Layout.Expanding
                        }
                        Rectangle {
                            color: "red"
                            height: parent.height
                            Layout.minimumWidth: 40
                            Layout.maximumWidth: 100
                            Layout.horizontalSizePolicy: Layout.Expanding
                        }
                    }
                }
            }
        }


        Tab {
            title: "Vertical"

            Row {
                spacing: 4

                anchors {
                    top: parent.top
                    left: parent.left
                    bottom: parent.bottom
                    margins: 10
                }

                // [1]
                ColumnLayout {
                    width: defaultWidth
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    Rectangle {
                        color: "red"
                        width: parent.width
                    }
                    Rectangle {
                        color: "green"
                        width: parent.width
                    }
                    Rectangle {
                        color: "blue"
                        width: parent.width
                    }
                }

                // [2]
                ColumnLayout {
                    width: defaultWidth
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    spacing: 5

                    Rectangle {
                        color: "red"
                        width: parent.width
                    }
                    Rectangle {
                        color: "green"
                        width: parent.width
                    }
                    Item {
                        implicitWidth: 10
                    }
                    Rectangle {
                        color: "blue"
                        width: parent.width
                    }
                }

                // [3]
                ColumnLayout {
                    width: defaultWidth
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    Rectangle {
                        color: "red"
                        width: parent.width
                        Layout.minimumHeight: 50
                        Layout.maximumHeight: 100
                        Layout.verticalSizePolicy: Layout.Expanding
                    }
                    Rectangle {
                        color: "green"
                        width: parent.width
                        Layout.minimumHeight: 100
                        Layout.maximumHeight: 200
                        Layout.verticalSizePolicy: Layout.Expanding
                    }
                    Rectangle {
                        color: "blue"
                        width: parent.width
                        Layout.minimumHeight: 200
                        Layout.maximumHeight: 400
                        Layout.verticalSizePolicy: Layout.Expanding
                    }
                }

                // [4]
                ColumnLayout {
                    spacing: 100
                    width: defaultWidth
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    Rectangle {
                        color: "red"
                        width: parent.width
                        Layout.minimumHeight: 100
                        Layout.verticalSizePolicy: Layout.Expanding
                    }
                    Rectangle {
                        color: "green"
                        width: parent.width
                        Layout.minimumHeight: 200
                        Layout.verticalSizePolicy: Layout.Expanding
                    }
                    Rectangle {
                        color: "blue"
                        width: parent.width
                        Layout.minimumHeight: 300
                        Layout.verticalSizePolicy: Layout.Expanding
                    }
                }

                // [5]
                ColumnLayout {
                    width: defaultWidth
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    Rectangle {
                        color: "red"
                        width: parent.width
                        Layout.minimumHeight: 200
                        Layout.maximumHeight: 500
                        Layout.verticalSizePolicy: Layout.Expanding
                    }
                }

                // [6]
                ColumnLayout {
                    spacing: 40
                    width: defaultWidth
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    ColumnLayout {
                        spacing: 10
                        width: parent.width

                        Rectangle {
                            color: "red"
                            width: parent.width
                            Layout.minimumHeight: 100
                            Layout.verticalSizePolicy: Layout.Expanding
                        }
                        Rectangle {
                            color: "blue"
                            width: parent.width
                            Layout.minimumHeight: 200
                            Layout.verticalSizePolicy: Layout.Expanding
                        }
                    }

                    ColumnLayout {
                        spacing: 10
                        width: parent.width

                        Rectangle {
                            color: "green"
                            width: parent.width
                            Layout.maximumHeight: 300
                            Layout.verticalSizePolicy: Layout.Expanding
                        }
                        Rectangle {
                            color: "red"
                            width: parent.width
                            Layout.minimumHeight: 40
                            Layout.maximumHeight: 100
                            Layout.verticalSizePolicy: Layout.Expanding
                        }
                    }
                }
            }
        }


        Tab {
            title: "Horizontal and Vertical"

            ColumnLayout {
                anchors.fill: parent

                // [1]
                RowLayout {
                    height: defaultHeight
                    anchors.left: parent.left
                    anchors.right: parent.right

                    Layout.minimumHeight: 100

                    Rectangle {
                        color: "red"
                        height: parent.height
                        Layout.horizontalSizePolicy: Layout.Expanding
                    }
                    Rectangle {
                        color: "green"
                        height: parent.height
                        implicitWidth: 100
                    }
                    Rectangle {
                        color: "blue"
                        height: parent.height
                        Layout.horizontalSizePolicy: Layout.Expanding
                    }
                }

                // [2]
                Rectangle {
                    color: "yellow"
                    height: parent.height
                    anchors.left: parent.left
                    anchors.right: parent.right
                    Layout.minimumHeight: 10
                    Layout.maximumHeight: 30
                    Layout.horizontalSizePolicy: Layout.Expanding
                    Layout.verticalSizePolicy: Layout.Expanding
                }

                // [3]
                RowLayout {
                    height: defaultHeight
                    anchors.left: parent.left
                    anchors.right: parent.right

                    Rectangle {
                        color: "red"
                        height: parent.height
                        Layout.maximumHeight: 200
                        Layout.horizontalSizePolicy: Layout.Expanding
                    }
                    Rectangle {
                        color: "blue"
                        height: parent.height

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 10
                            opacity: 0.6

                            Rectangle {
                                color: "darkRed"
                                height: parent.height
                                anchors.left: parent.left
                                anchors.right: parent.right
                                Layout.minimumHeight: 100
                                Layout.maximumHeight: 200
                                Layout.verticalSizePolicy: Layout.Expanding
                            }

                            Rectangle {
                                color: "darkGreen"
                                height: parent.height
                                anchors.left: parent.left
                                anchors.right: parent.right
                                Layout.verticalSizePolicy: Layout.Expanding
                            }
                        }
                    }
                }
            }
        }
    }
}
