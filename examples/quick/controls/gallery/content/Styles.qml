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
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Dialogs 1.0

Item {
    id: root
    width: 300
    height: 200

    ColorDialog {
        id: colorDialog
        color: "#afe"
        property color last: "#afe"
        onRejected: color = last
        onVisibleChanged: if (visible) last = color
    }

    Column {
        anchors.margins: 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        spacing: 20

        Row {
            spacing: 8
            Button {
                text: "Set color…"
                style: ButtonStyle { }
                onClicked: colorDialog.open()
            }
            Button {
                text: "Push me"
                style: ButtonStyle { }
            }
            Button {
                text: "Push me"
                style: buttonStyle
            }
        }
        Row {
            spacing: 8
            TextField {
                style: TextFieldStyle { }
            }
            TextField {
                style: TextFieldStyle { }
            }
            TextField {
                style: textfieldStyle
            }
        }

        Row {
            spacing: 8
            Slider {
                value: 50
                maximumValue: 100
                width: 100
                style: SliderStyle { }
            }
            Slider {
                value: 50
                maximumValue: 100
                width: 100
                style: SliderStyle { }
            }
            Slider {
                value: 50
                maximumValue: 100
                width: 100
                style: sliderStyle
            }
        }

        Row {
            spacing: 8
            ProgressBar {
                value: 50
                maximumValue: 100
                width: 100
                style: ProgressBarStyle{ }
            }
            ProgressBar {
                value: 50
                maximumValue: 100
                width: 100
                style: ProgressBarStyle{ }
            }
            ProgressBar {
                value: 50
                maximumValue: 100
                width: 100
                style: progressbarStyle
            }
        }

        Row {
            spacing: 8
            CheckBox {
                text: "CheckBox"
                style: CheckBoxStyle{}
            }
            RadioButton {
                style: RadioButtonStyle{}
                text: "RadioButton"
            }

            ComboBox {
                model: ["Paris", "Oslo", "New York"]
                style: ComboBoxStyle{}
            }
        }

        Row {
            TabView {
                width: 400
                height: 30
                Tab { title: "One" ; Item {}}
                Tab { title: "Two" ; Item {}}
                Tab { title: "Three" ; Item {}}
                Tab { title: "Four" ; Item {}}
                style: tabViewStyle
            }
        }
    }

    // Style delegates:

    property Component buttonStyle: ButtonStyle {
        panel: Rectangle {
            implicitHeight: 20
            implicitWidth: 100
            color: control.pressed ? "darkGray" : "lightGray"
            antialiasing: true
            border.color: "gray"
            radius: height/2
            Text {
                anchors.centerIn: parent
                text: control.text
            }
        }
    }

    property Component textfieldStyle: TextFieldStyle {
        background: Rectangle {
            implicitWidth: 100
            implicitHeight: 20
            color: "#f0f0f0"
            antialiasing: true
            border.color: "gray"
            radius: height/2
        }
    }

    property Component sliderStyle: SliderStyle {
        handle: Rectangle {
            width: 14
            height: 14
            color: control.pressed ? "darkGray" : "lightGray"
            border.color: "gray"
            antialiasing: true
            radius: height/2
        }

        groove: Rectangle {
            height: 8
            implicitWidth: 100
            implicitHeight: 20

            antialiasing: true
            color: "darkGray"
            border.color: "gray"
            radius: height/2
        }
    }

    property Component progressbarStyle: ProgressBarStyle {
        panel: Rectangle {
            implicitWidth: 100
            implicitHeight: 20
            color: "#f0f0f0"
            border.color: "gray"
            antialiasing: true
            radius: height/2
            Rectangle {
                implicitWidth: 100
                implicitHeight: 20
                color: "#f0f0f0"
                border.color: "gray"
                antialiasing: true
                radius: height/2
            }
        }
    }

    property Component tabViewStyle: TabViewStyle {
        tabOverlap: 16
        tabsLeftPadding: 12
        frameOverlap: 4

        frame: Rectangle {
            gradient: Gradient{
                GradientStop { color: "#e5e5e5" ; position: 0 }
                GradientStop { color: "#e0e0e0" ; position: 1 }
            }
            border.color: "#898989"
            Rectangle { anchors.fill: parent ; anchors.margins: 1 ; border.color: "white" ; color: "transparent" }

        }
        tab: Item {
            implicitWidth: image.sourceSize.width
            implicitHeight: image.sourceSize.height
            BorderImage {
                id: image
                anchors.fill: parent
                source: tab.selected ? "../images/tab_selected.png" : "../images/tab.png"
                border.left: 50
                smooth: false
                border.right: 50
            }
            Text {
                text: tab.title
                anchors.centerIn: parent
            }
        }
    }
}

