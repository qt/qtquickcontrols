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
    \qmltype ComboBox
    \inqmlmodule QtQuick.Controls 1.0
    \since QtQuick.Controls 1.0
    \ingroup controls
    \brief Provides a drop-down list functionality.

    Add items to the comboBox by assigning it a ListModel, or a list of strings to the \l model property.

    \qml
       ComboBox {
           width: 200
           model: [ "Banana", "Apple", "Coconut" ]
       }
    \endqml

    Example 2:

    \qml
       ComboBox {
           model: ListModel {
               id: cbItems
               ListElement { text: "Banana"; color: "Yellow" }
               ListElement { text: "Apple"; color: "Green" }
               ListElement { text: "Coconut"; color: "Brown" }
           }
           width: 200
           onCurrentIndexChanged: console.debug(currentText + ", " + cbItems.get(currentIndex).color)
       }
    \endqml

    You can create a custom appearance for a ComboBox by
    assigning a \l ComboBoxStyle.
*/

Control {
    id: comboBox

    /*! \qmlproperty model ComboBox::model
        The model to populate the ComboBox from. */
    property alias model: popupItems.model

    /*! The model role used for populating the ComboBox. */
    property string textRole: ""

    /*! \qmlproperty int ComboBox::currentIndex
        The index of the currently selected item in the ComboBox. */
    property alias currentIndex: popup.__selectedIndex

    /*! \qmlproperty string ComboBox::currentText
        The text of the currently selected item in the ComboBox. */
    readonly property alias currentText: popup.selectedText

    /*! This property specifies whether the combobox should gain active focus when pressed.
        The default value is \c false. */
    property bool activeFocusOnPress: false

    /*! \qmlproperty bool ComboBox::pressed

        This property holds whether the button is being pressed. */
    readonly property bool pressed: mouseArea.pressed && mouseArea.containsMouse || popup.__popupVisible

    /*! \qmlproperty bool ComboBox::hovered

        This property indicates whether the control is being hovered.
    */
    readonly property alias hovered: mouseArea.containsMouse

    /*! \internal */
    property var __popup: popup

    style: Qt.createComponent(Settings.style + "/ComboBoxStyle.qml", comboBox)

    activeFocusOnTab: true

    Accessible.role: Accessible.ComboBox

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onPressed: {
            if (comboBox.activeFocusOnPress)
                forceActiveFocus()
            popup.show()
        }
    }

    Component.onCompleted: {
        if (currentIndex === -1)
            currentIndex = 0

        popup.ready = true
        popup.resolveTextValue(textRole)
    }

    onTextRoleChanged: popup.resolveTextValue(textRole)

    Menu {
        id: popup
        objectName: "popup"

        style: isPopup ? __style.__popupStyle : __style.__dropDownStyle

        readonly property string selectedText: items[__selectedIndex] ? items[__selectedIndex].text : ""
        property string textRole: ""

        property bool ready: false
        property bool isPopup: __panel ? __panel.popup : false

        property int y: isPopup ? (comboBox.__panel.height - comboBox.__panel.implicitHeight) / 2.0 : comboBox.__panel.height
        __minimumWidth: comboBox.width
        __visualItem: comboBox

        property ExclusiveGroup eg: ExclusiveGroup { id: eg }

        property bool __modelIsArray: popupItems.model ? popupItems.model.constructor === Array : false

        Instantiator {
            id: popupItems
            active: false
            MenuItem {
                text: popup.textRole === '' ?
                        modelData :
                        ((popup.__modelIsArray ? modelData[popup.textRole] : model[popup.textRole]) || '')

                checkable: true
                exclusiveGroup: eg
            }
            onObjectAdded: popup.insertItem(index, object)
            onObjectRemoved: popup.removeItem(object)

        }

        function resolveTextValue(initialTextRole) {
            if (!ready || !model) {
                popupItems.active = false
                return;
            }

            var get = model['get'];
            if (!get && popup.__modelIsArray) {
                if (model[0].constructor !== String) // arrays of strings don't have textRole
                    get = function(i) { return model[i]; }
            }

            var modelMayHaveRoles = get !== undefined
            textRole = initialTextRole
            if (textRole === "" && modelMayHaveRoles && get(0)) {
                // No text role set, check whether model has a suitable role
                // If 'text' is found, or there's only one role, pick that.
                var listElement = get(0)
                var roleName = ""
                var roleCount = 0
                for (var role in listElement) {
                    if (role === "text") {
                        roleName = role
                        break
                    } else if (!roleName) {
                        roleName = role
                    }
                    ++roleCount
                }
                if (roleCount > 1 && roleName !== "text") {
                    console.warn("No suitable 'textRole' found for ComboBox.")
                } else {
                    textRole = roleName
                }
            }
            popupItems.active = true
        }

        function show() {
            if (items[__selectedIndex])
                items[__selectedIndex].checked = true
            __currentIndex = comboBox.currentIndex
            __popup(0, y, isPopup ? __selectedIndex : 0)
        }
    }

    // The key bindings below will only be in use when popup is
    // not visible. Otherwise, native popup key handling will take place:
    Keys.onSpacePressed: {
        if (!popup.popupVisible)
            popup.show()
    }
    Keys.onUpPressed: { if (currentIndex > 0) currentIndex-- }
    Keys.onDownPressed: { if (currentIndex < popupItems.count - 1) currentIndex++ }
}
