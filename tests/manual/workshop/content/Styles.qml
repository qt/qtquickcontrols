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
import QtQuick.Controls.Styles 1.1
import QtQuick.Particles 2.0
import QtQuick.Layouts 1.0

Item {
    id: root
    width: 300
    height: 200

    property int columnWidth: 120
    GridLayout {
        rowSpacing: 12
        columnSpacing: 30
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 30

        Button {
            text: "Push me"
            style: ButtonStyle { }
            implicitWidth: columnWidth
        }
        Button {
            text: "Push me"
            style: ButtonStyle {
                background: BorderImage {
                    source: control.pressed ? "../images/button-pressed.png" : "../images/button.png"
                    border.left: 4 ; border.right: 4 ; border.top: 4 ; border.bottom: 4
                }
            }
            implicitWidth: columnWidth
        }
        Button {
            text: "Push me"
            style: buttonStyle
            implicitWidth: columnWidth
        }

        TextField {
            Layout.row: 1
            style: TextFieldStyle { }
            implicitWidth: columnWidth
        }
        TextField {
            style: TextFieldStyle {
                background: BorderImage {
                    source: "../images/textfield.png"
                    border.left: 4 ; border.right: 4 ; border.top: 4 ; border.bottom: 4
                }
            }
            implicitWidth: columnWidth
        }
        TextField {
            style: textfieldStyle
            implicitWidth: columnWidth
        }

        Slider {
            id: slider1
            Layout.row: 2
            value: 0.5
            implicitWidth: columnWidth
            style: SliderStyle { }
        }
        Slider {
            id: slider2
            value: 0.5
            implicitWidth: columnWidth
            style: SliderStyle {
                groove: BorderImage {
                    height: 6
                    border.top: 1
                    border.bottom: 1
                    source: "../images/progress-background.png"
                    border.left: 6
                    border.right: 6
                    BorderImage {
                        anchors.verticalCenter: parent.verticalCenter
                        source: "../images/progress-fill.png"
                        border.left: 5 ; border.top: 1
                        border.right: 5 ; border.bottom: 1
                        width: styleData.handlePosition
                        height: parent.height
                    }
                }
                handle: Item {
                    width: 13
                    height: 13
                    Image {
                        anchors.centerIn: parent
                        source: "../images/slider-handle.png"
                    }
                }
            }
        }
        Slider {
            id: slider3
            value: 0.5
            implicitWidth: columnWidth
            style: sliderStyle
        }

        ProgressBar {
            Layout.row: 3
            value: slider1.value
            implicitWidth: columnWidth
            style: ProgressBarStyle{ }
        }
        ProgressBar {
            value: slider2.value
            implicitWidth: columnWidth
            style: progressBarStyle
        }
        ProgressBar {
            value: slider3.value
            implicitWidth: columnWidth
            style: progressBarStyle2
        }

        CheckBox {
            text: "CheckBox"
            style: CheckBoxStyle{}
            Layout.row: 4
            implicitWidth: columnWidth
        }
        RadioButton {
            style: RadioButtonStyle{}
            text: "RadioButton"
            implicitWidth: columnWidth
        }

        ComboBox {
            model: ["Paris", "Oslo", "New York"]
            style: ComboBoxStyle{}
            implicitWidth: columnWidth
        }

        TabView {
            Layout.row: 5
            Layout.columnSpan: 3
            Layout.fillWidth: true
            implicitHeight: 30
            Tab { title: "One" ; Item {}}
            Tab { title: "Two" ; Item {}}
            Tab { title: "Three" ; Item {}}
            Tab { title: "Four" ; Item {}}
            style: TabViewStyle {}
        }

        TabView {
            Layout.row: 6
            Layout.columnSpan: 3
            Layout.fillWidth: true
            implicitHeight: 30
            Tab { title: "One" ; Item {}}
            Tab { title: "Two" ; Item {}}
            Tab { title: "Three" ; Item {}}
            Tab { title: "Four" ; Item {}}
            style: tabViewStyle
        }
    }

    // Style delegates:

    property Component buttonStyle: ButtonStyle {
        background: Rectangle {
            implicitHeight: 22
            implicitWidth: columnWidth
            color: control.pressed ? "darkGray" : control.activeFocus ? "#cdd" : "#ccc"
            antialiasing: true
            border.color: "gray"
            radius: height/2
            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                color: "transparent"
                antialiasing: true
                visible: !control.pressed
                border.color: "#aaffffff"
                radius: height/2
            }
        }
    }

    property Component textfieldStyle: TextFieldStyle {
        background: Rectangle {
            implicitWidth: columnWidth
            implicitHeight: 22
            color: "#f0f0f0"
            antialiasing: true
            border.color: "gray"
            radius: height/2
            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                color: "transparent"
                antialiasing: true
                border.color: "#aaffffff"
                radius: height/2
            }
        }
    }

    property Component sliderStyle: SliderStyle {
        handle: Rectangle {
            width: 18
            height: 18
            color: control.pressed ? "darkGray" : "lightGray"
            border.color: "gray"
            antialiasing: true
            radius: height/2
            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                color: "transparent"
                antialiasing: true
                border.color: "#eee"
                radius: height/2
            }
        }

        groove: Rectangle {
            height: 8
            implicitWidth: columnWidth
            implicitHeight: 22

            antialiasing: true
            color: "#ccc"
            border.color: "#777"
            radius: height/2
            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                color: "transparent"
                antialiasing: true
                border.color: "#66ffffff"
                radius: height/2
            }
        }
    }

    property Component progressBarStyle: ProgressBarStyle {
        background: BorderImage {
            source: "../images/progress-background.png"
            border.left: 2 ; border.right: 2 ; border.top: 2 ; border.bottom: 2
        }
        progress: Item {
            clip: true
            BorderImage {
                anchors.fill: parent
                anchors.rightMargin: (control.value < control.maximumValue) ? -4 : 0
                source: "../images/progress-fill.png"
                border.left: 10 ; border.right: 10
                Rectangle {
                    width: 1
                    color: "#a70"
                    opacity: 0.8
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 1
                    anchors.right: parent.right
                    visible: control.value < control.maximumValue
                    anchors.rightMargin: -parent.anchors.rightMargin
                }
            }
            ParticleSystem{ id: bubbles; running: visible }
            ImageParticle{
                id: fireball
                system: bubbles
                source: "../images/bubble.png"
                opacity: 0.7
            }
            Emitter{
                system: bubbles
                anchors.bottom: parent.bottom
                anchors.margins: 4
                anchors.bottomMargin: -4
                anchors.left: parent.left
                anchors.right: parent.right
                size: 4
                sizeVariation: 4
                acceleration: PointDirection{ y: -6; xVariation: 3 }
                emitRate: 6 * control.value
                lifeSpan: 3000
            }
        }
    }

    property Component progressBarStyle2: ProgressBarStyle {
        background: Rectangle {
            implicitWidth: columnWidth
            implicitHeight: 24
            color: "#f0f0f0"
            border.color: "gray"
        }
        progress: Rectangle {
            color: "#ccc"
            border.color: "gray"
            Rectangle {
                color: "transparent"
                border.color: "#44ffffff"
                anchors.fill: parent
                anchors.margins: 1
            }
        }
    }

    property Component tabViewStyle: TabViewStyle {
        tabOverlap: 16
        frameOverlap: 4
        tabsMovable: true

        frame: Rectangle {
            gradient: Gradient{
                GradientStop { color: "#e5e5e5" ; position: 0 }
                GradientStop { color: "#e0e0e0" ; position: 1 }
            }
            border.color: "#898989"
            Rectangle { anchors.fill: parent ; anchors.margins: 1 ; border.color: "white" ; color: "transparent" }
        }
        tab: Item {
            property int totalOverlap: tabOverlap * (control.count - 1)
            implicitWidth: Math.min ((styleData.availableWidth + totalOverlap)/control.count - 4, image.sourceSize.width)
            implicitHeight: image.sourceSize.height
            BorderImage {
                id: image
                anchors.fill: parent
                source: styleData.selected ? "../images/tab_selected.png" : "../images/tab.png"
                border.left: 30
                smooth: false
                border.right: 30
            }
            Text {
                text: styleData.title
                anchors.centerIn: parent
            }
        }
        leftCorner: Item { implicitWidth: 12 }
    }
}
