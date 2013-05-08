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
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0

/*!
    \qmltype GroupBox
    \inqmlmodule QtQuick.Controls 1.0
    \since QtQuick.Controls 1.0
    \ingroup controls
    \brief GroupBox provides a group box frame with a title.

    A group box provides a frame, a title on top and displays various other controls inside itself. Group boxes can also be checkable.

    Child controls in checkable group boxes are enabled or disabled depending on whether or not the group box is checked.

    You can minimize the space consumption of a group box by enabling the flat property.
    In most styles, enabling this property results in the removal of the left, right and bottom edges of the frame.

    GroupBox doesn't automatically lay out the child controls (which are often \l{CheckBox}{CheckBoxes} or \l{RadioButton}{RadioButtons} but can be any controls).
    The following example shows how we can set up a GroupBox with a column:

    \qml
        GroupBox {
            title: qsTr("Package selection")
            Column {
                CheckBox {
                    text: qsTr("Update system")
                }
                CheckBox {
                    text: qsTr("Update applications")
                }
                CheckBox {
                    text: qsTr("Update documentation")
                }
            }
        }
    \endqml

    \note The default size of the GroupBox is calculated based on the size of its children. If you need to use anchors
    inside a GroupBox, it is recommended to specify a width and height to the GroupBox or to add an intermediate Item
    inside the GroupBox.
*/

Item {
    id: groupbox

    /*!
        This property holds the group box title text.

        There is no default title text.
    */
    property string title

    /*!
        This property holds whether the group box is painted flat or has a frame.

        A group box usually consists of a surrounding frame with a title at the top.
        If this property is enabled, only the top part of the frame is drawn in most styles;
        otherwise, the whole frame is drawn.

        By default, this property is disabled, so group boxes are not flat unless explicitly specified.

        \note In some styles, flat and non-flat group boxes have similar representations and may not be as
              distinguishable as they are in other styles.
    */
    property bool flat: false

    /*!
        This property holds whether the group box has a checkbox in its title.

        If this property is true, the group box displays its title using a checkbox in place of an ordinary label.
        If the checkbox is checked, the group box's children are enabled; otherwise, they are disabled and inaccessible.

        By default, group boxes are not checkable.
    */
    property bool checkable: false

    /*!
        \qmlproperty bool GroupBox::checked

        This property holds whether the group box is checked.

        If the group box is checkable, it is displayed with a check box. If the check box is checked, the group
        box's children are enabled; otherwise, the children are disabled and are inaccessible to the user.

        By default, checkable group boxes are also checked.
    */
    property alias checked: check.checked

    /*!
        This property holds the width of the content.
    */
    property real contentWidth: content.childrenRect.width

    /*!
        This property holds the height of the content.
    */
    property real contentHeight: content.childrenRect.height

    /*! \internal */
    property Component style: Qt.createComponent(Settings.theme() + "/GroupBoxStyle.qml", groupbox)

    /*! \internal */
    default property alias data: content.data

    /*! \internal */
    property alias __checkbox: check

    implicitWidth: Math.max(200, (loader.item ? loader.item.implicitWidth: 0) )
    implicitHeight: (loader.item ? loader.item.implicitHeight : 0)

    Layout.minimumWidth: implicitWidth
    Layout.minimumHeight: implicitHeight

    Accessible.role: Accessible.Grouping
    Accessible.name: title

    activeFocusOnTab: false

    Loader {
        id: loader
        anchors.fill: parent
        property int topMargin: (title.length > 0 || checkable ? 16 : 0) + content.margin
        property int bottomMargin: 4
        property int leftMargin: 4
        property int rightMargin: 4
        sourceComponent: styleLoader.item ? styleLoader.item.panel : null
        onLoaded: item.z = -1
        Loader {
            id: styleLoader
            property alias __control: groupbox
            sourceComponent: groupbox.style
        }
    }

    CheckBox {
        id: check
        checked: true
        text: groupbox.title
        visible: checkable
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: loader.topMargin
        style: CheckBoxStyle { panel: Item{} }
    }

    Item {
        id:content
        z: 1
        focus: true
        property int margin: styleLoader.item ? styleLoader.item.margin : 0
        anchors.topMargin: loader.topMargin
        anchors.leftMargin: margin
        anchors.rightMargin: margin
        anchors.bottomMargin: margin
        anchors.fill: parent
        enabled: (!groupbox.checkable || groupbox.checked)
    }
}
