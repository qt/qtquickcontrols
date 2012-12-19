/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Components project.
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

/*!
    \qmltype ContextMenu
    \inqmlmodule QtDesktop 1.0
    \brief ContextMenu is doing bla...bla...
*/

Menu {
    id: root
    property string selectedText: itemTextAt(selectedIndex)
    property string hoveredText: itemTextAt(hoveredIndex)
    property string textRole

    // 'centerSelectedText' means that the menu will be positioned
    //  so that the selected text' top left corner will be at x, y.
    property bool centerSelectedText: true

    visible: false
    onMenuClosed: visible = false
    onModelChanged: if (Component.status === Component.Ready && model !== undefined) rebuildMenu()

    Component.onCompleted: if (model !== undefined) rebuildMenu()

    onHoveredIndexChanged: {
        if (hoveredIndex < menuItems.length)
            menuItems[hoveredIndex].hovered()
    }

    onSelectedIndexChanged: {
        if (hoveredIndex < menuItems.length)
            menuItems[hoveredIndex].selected()
    }

    onVisibleChanged: {
        if (visible) {
            var globalPos = mapToItem(null, x, y)
            showPopup(globalPos.x, globalPos.y, centerSelectedText ? selectedIndex : 0)
        } else {
            hidePopup()
        }
    }

    function rebuildMenu()
    {
        clearMenuItems();

        for (var i=0; i<menuItems.length; ++i)
            addMenuItem(menuItems[i].text)

        var nativeModel = root.hasNativeModel()

        if (model !== undefined) {
            var modelCount = nativeModel ? root.modelCount() : model.count;
            for (var j = 0 ; j < modelCount; ++j) {
                var textValue
                if (nativeModel) {
                    textValue = root.modelTextAt(j);
                } else {
                    if (textRole !== "")
                        textValue = model.get(j)[textRole]
                    else if (model.count > 0 && root.model.get && root.model.get(0)) {
                        // ListModel with one role
                        var listElement = root.model.get(0)
                        var oneRole = true
                        var roleName = ""
                        var roleCount = 0
                        for (var role in listElement) {
                            if (!roleName || role === "text")
                                roleName = role
                            ++roleCount
                        }
                        if (roleCount > 1 && roleName !== "text") {
                            oneRole = false
                            console.log("Warning: No textRole set for ComboBox.")
                            break
                        }

                        if (oneRole) {
                            root.textRole = roleName
                            textValue = root.model.get(j)[textRole]
                        }
                    }
                }
                addMenuItem(textValue)
            }
        }
    }
}
