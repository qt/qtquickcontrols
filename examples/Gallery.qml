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
import "content"

ApplicationWindow {
    title: "Component Gallery"

    width: 580
    height: 400
    minimumHeight: 400
    minimumWidth: 340
    property string loremIpsum:
            "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor "+
            "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor "+
            "incididunt ut labore et dolore magna aliqua.\n Ut enim ad minim veniam, quis nostrud "+
            "exercitation ullamco laboris nisi ut aliquip ex ea commodo cosnsequat. ";

    ToolBar {
        id: toolbar
        width: parent.width
        height: 40
        RowLayout {
            spacing: 2
            anchors.verticalCenter: parent.verticalCenter
            ToolButton {
                iconName: "window-new"
                iconSource: "images/window-new.png"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: window1.visible = !window1.visible
                Accessible.name: "New window"
                tooltip: "Toggle visibility of the second window"
            }
            ToolButton {
                iconName: "document-open"
                iconSource: "images/document-open.png"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: fileDialogLoad.open()
                tooltip: "(Pretend to) open a file"
            }
            ToolButton {
                iconName: "document-save-as"
                iconSource: "images/document-save-as.png"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: fileDialogSave.open()
                tooltip: "(Pretend to) save as..."
            }
        }

        FileDialog {
            id: fileDialogLoad
            folder: "/tmp"
            title: "Choose a file to open"
            selectMultiple: true
            nameFilters: [ "Image files (*.png *.jpg)", "All files (*)" ]

            onAccepted: { console.log("Accepted: " + filePaths) }
        }

        FileDialog {
            id: fileDialogSave
            folder: "/tmp"
            title: "Save as..."
            modal: true
            selectExisting: false

            onAccepted: { console.log("Accepted: " + filePath) }
        }

        ChildWindow { id: window1 }

        ContextMenu {
            id: editmenu
            MenuItem { text: "Copy" ;  iconName: "edit-copy" }
            MenuItem { text: "Cut" ;   iconName: "edit-cut" }
            MenuItem { text: "Paste" ; iconName: "edit-paste" }
        }
        MouseArea {
            anchors.fill:  parent
            acceptedButtons: Qt.RightButton
            onPressed: editmenu.showPopup(mouseX, mouseY)
        }

        CheckBox {
            id: enabledCheck
            text: "Enabled"
            checked: true
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    menuBar: MenuBar {
        Menu {
            text: "File"
            MenuItem {
                text: "Open"
                shortcut: "Ctrl+O"
                onTriggered: fileDialogLoad.open();
            }
            MenuItem {
                text: "Close"
                shortcut: "Ctrl+Q"
                onTriggered: Qt.quit()
            }
        }
        Menu {
            text: "Edit"
            MenuItem {
                text: "Copy"
            }
            MenuItem {
                text: "Paste"
            }
        }
    }


    SystemPalette {id: syspal}
    StyleItem{ id: styleitem}
    color: syspal.window
    ListModel {
        id: choices
        ListElement { text: "Banana" }
        ListElement { text: "Orange" }
        ListElement { text: "Apple" }
        ListElement { text: "Coconut" }
    }

    TabFrame {
        id:frame
        enabled: enabledCheck.checked
        position: controlPage.tabPosition
        anchors.top: toolbar.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.margins: styleitem.style == "mac" ? 12 : 0
        Tab {
            title: "Control"
            Controls { id: controlPage }
        }
        Tab {
            id:mytab
            title: "Itemviews"
            ModelView { }
        }
        Tab {
            title: "Range"
            RangeTab { }
        }
        Tab {
            title: "Styles"
            Styles { anchors.fill: parent}
        }
        Tab {
            title: "Sidebar"
            Panel { anchors.fill:parent }
        }
    }
}

