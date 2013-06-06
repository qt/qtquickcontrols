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
import QtQuick.Controls.Private 1.0

/*!
    \qmltype ComboBoxStyle
    \inqmlmodule QtQuick.Controls.Styles 1.0
    \since QtQuick.Controls.Styles 1.0
    \ingroup controlsstyling
    \brief Provides custom styling for ComboBox
*/

Style {

    /*! \internal */
    property var __syspal: SystemPalette {
        colorGroup: control.enabled ?
                        SystemPalette.Active : SystemPalette.Disabled
    }
    /*! The \l ComboBox attached to this style. */
    readonly property ComboBox control: __control

    /*! The padding between the background and the label components. */
    padding { top: 4 ; left: 6 ; right: 6 ; bottom:4 }

    /*! This defines the background of the button. */
    property Component background: Item {
        implicitWidth: 100
        implicitHeight: 25
        BorderImage {
            anchors.fill: parent
            source: control.pressed ? "images/button_down.png" : "images/button.png"
            border.top: 6
            border.bottom: 6
            border.left: 6
            border.right: 6
            anchors.bottomMargin: -1
            BorderImage {
                anchors.fill: parent
                anchors.margins: -1
                anchors.topMargin: -2
                anchors.rightMargin: 0
                anchors.bottomMargin: 1
                source: "images/focusframe.png"
                visible: control.activeFocus
                border.left: 4
                border.right: 4
                border.top: 4
                border.bottom: 4
            }
            Image {
                id: imageItem
                source: "images/arrow-down.png"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 8
                opacity: control.enabled ? 0.7 : 0.5
            }
        }
    }

    /*! This defines the label of the button. */
    property Component label: Item {
        implicitWidth: textitem.implicitWidth + 20
        Text {
            id: textitem
            anchors.left: parent.left
            anchors.leftMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            text: control.currentText
            renderType: Text.NativeRendering
            color: __syspal.text
        }
    }

    /*! \internal */
    property Component panel: Item {
        property bool popup: false
        anchors.centerIn: parent
        anchors.fill: parent
        implicitWidth: Math.max(labelLoader.implicitWidth + padding.left + padding.right, backgroundLoader.implicitWidth)
        implicitHeight: Math.max(labelLoader.implicitHeight + padding.top + padding.bottom, backgroundLoader.implicitHeight)

        Loader {
            id: backgroundLoader
            anchors.fill: parent
            sourceComponent: background
        }

        Loader {
            id: labelLoader
            sourceComponent: label
            anchors.fill: parent
            anchors.leftMargin: padding.left
            anchors.topMargin: padding.top
            anchors.rightMargin: padding.right
            anchors.bottomMargin: padding.bottom
        }
    }

    /*! \internal */
    property Component __dropDownStyle: MenuStyle {
        __menuItemType: "comboboxitem"
    }

    /*! \internal */
    property Component __popupStyle: Style {

        property Component frame: Rectangle {
            width: (parent ? parent.contentWidth : 0)
            height: (parent ? parent.contentHeight : 0) + 2
            border.color: "#777"
        }

        property Component menuItem: Rectangle {
            property string textRef: text
            implicitWidth: textItem.contentWidth
            implicitHeight: textItem.contentHeight
            border.color: "#777"
            Text {
                id: textItem
                visible: false
                text: textRef
            }
        }
    }
}
