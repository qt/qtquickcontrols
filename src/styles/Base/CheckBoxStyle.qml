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
import QtQuick.Controls.Private 1.0

/*!
    \qmltype CheckBoxStyle
    \inqmlmodule QtQuick.Controls.Styles 1.0
    \since QtQuick.Controls.Styles 1.0
    \ingroup controlsstyling
    \brief Provides custom styling for CheckBox

    Example:
    \qml
    CheckBox {
        text: "Check Box"
        style: CheckBoxStyle {
            indicator: Rectangle {
                    implicitWidth: 16
                    implicitHeight: 16
                    radius: 3
                    border.color: control.activeFocus ? "darkblue" : "gray"
                    border.width: 1
                    Rectangle {
                        visible: control.checked
                        color: "#555"
                        border.color: "#333"
                        radius: 1
                        anchors.margins: 4
                        anchors.fill: parent
                    }
            }
        }
    }
    \endqml
*/
Style {
    id: checkboxStyle

    /*! The \l CheckBox attached to this style. */
    readonly property CheckBox control: __control
    /*! \internal */
    property var __syspal: SystemPalette {
        colorGroup: control.enabled ?
                        SystemPalette.Active : SystemPalette.Disabled
    }

    /*! This defines the text label. */
    property Component label: Text {
        text: control.text
        color: __syspal.text
        renderType: Text.NativeRendering
        verticalAlignment: Text.AlignVCenter
    }

    /*! The content padding. */
    padding {
        top: 0
        left: 0
        right: 4
        bottom: 0
    }

    /*! The spacing between indicator and label. */
    property int spacing: 4

    /*! This defines the indicator button. */
    property Component indicator:  Item {
        implicitWidth: 18
        implicitHeight: 18
        BorderImage {
            anchors.fill: parent
            source: "images/editbox.png"
            border.top: 6
            border.bottom: 6
            border.left: 6
            border.right: 6
        }
        Rectangle {
            height: 16
            width: 16
            antialiasing: true
            visible: control.checked
            color: "#666"
            radius: 1
            anchors.margins: 4
            anchors.fill: parent
            anchors.topMargin: 3
            anchors.bottomMargin: 5
            border.color: "#222"
            opacity: control.enabled ? 1 : 0.5
            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                color: "transparent"
                border.color: "#33ffffff"
            }
        }
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
    }

    /*! \internal */
    property Component panel: Item {
        implicitWidth: Math.round(row.width + padding.left + padding.right)
        implicitHeight: Math.max(indicatorLoader.implicitHeight, labelLoader.implicitHeight) + padding.top + padding.bottom

        Row {
            id: row
            y: padding.top
            x: padding.left
            spacing: checkboxStyle.spacing
            Loader {
                id: indicatorLoader
                sourceComponent: indicator
                anchors.verticalCenter: parent.verticalCenter
            }
            Loader {
                id: labelLoader
                sourceComponent: label
                anchors.top: parent.top
                anchors.bottom: parent.bottom
            }
        }
    }
}
