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
import QtWebKit 1.0
import "content"

Rectangle {
    id:root
    width: 540
    height: 340

    property alias tabFrame: frame
    property alias address: addressField

    function addTab() {
        var component = Qt.createComponent("BrowserTab.qml")
        if (component.status == Component.Ready) {
            frame.addTab(component)
        }
    }

    function closeTab() {
        if (frame.count > 1)
            frame.removeTab(frame.current)
    }

    Window {
        id: settingsDialog
        width: 200
        height: 200
        modal: true

        Rectangle {
            anchors.centerIn: parent
            width: 150
            height: 150

            Component.onCompleted: {
                javaCheckBox.checked = tab.webView.settings.javaEnabled
                javascriptCheckBox.checked = tab.webView.settings.javascriptEnabled
                pluginsCheckBox.checked = tab.webView.settings.pluginsEnabled
            }

            CheckBox {
                id: javaCheckBox
                text: "Enable Java"
                anchors.margins: 10
                anchors.top: parent.top
                anchors.left: parent.left

                onCheckedChanged: {
                    for (var i=0; i<tabFrame.tabs.length; i++) {
                        tabFrame.tabs[i].webView.settings.javaEnabled = checked
                    }
                }
            }
            CheckBox {
                id: javascriptCheckBox
                text: "Enable Javascript"
                anchors.margins: 10
                anchors.top: javaCheckBox.bottom
                anchors.left: parent.left

                onCheckedChanged: {
                    for (var i=0; i<tabFrame.tabs.length; i++) {
                        tabFrame.tabs[i].webView.settings.javascriptEnabled = checked
                    }
                }
            }
            CheckBox {
                id: pluginsCheckBox
                text: "Enable Plugins"
                anchors.margins: 10
                anchors.top: javascriptCheckBox.bottom
                anchors.left: parent.left

                onCheckedChanged: {
                    for (var i=0; i<tabFrame.tabs.length; i++) {
                        tabFrame.tabs[i].webView.settings.pluginsEnabled = checked
                    }
                }
            }
        }

        Button {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            text: "okay"
            onClicked: {
                settingsDialog.visible = false
            }
        }
    }

    ToolBar{
        id:toolbar
        width:parent.width
        anchors.left: parent.left
        anchors.right: parent.right
        height:46

        ToolButton{
            id:back
            text:"Back"
            iconSource:"images/go-previous.png"
            anchors.verticalCenter:parent.verticalCenter
            enabled:  frame.tabs[frame.current].webView.back.enabled
            onClicked: frame.tabs[frame.current].webView.back.trigger()
        }

        ToolButton{
            id:forward
            text:"Forward"
            iconSource:"images/go-next.png"
            anchors.left: back.right
            anchors.verticalCenter:parent.verticalCenter
            enabled:  frame.tabs[frame.current].webView.forward.enabled
            onClicked: frame.tabs[frame.current].webView.forward.trigger()
        }

        ToolButton{
            id:reload
            anchors.left: forward.right
            text: frame.tabs[frame.current].webView.progress < 1 ? "Stop" : "Reload"
            iconSource: frame.tabs[frame.current].webView.progress < 1 ?  "images/process-stop.png" : "images/view-refresh.png"
            anchors.verticalCenter:parent.verticalCenter
            onClicked: {
                if(frame.tabs[frame.current].webView.progress < 1) frame.tabs[frame.current].webView.stop.trigger()
                else frame.tabs[frame.current].webView.reload.trigger()
            }
        }

        TextField{
            id:addressField;
            text: "http://osnews.com"
            anchors.left:  reload.right;
            anchors.right: settings.left
            anchors.rightMargin: 9
            anchors.leftMargin: 6
            anchors.verticalCenter:parent.verticalCenter

            Keys.onReturnPressed:  {
                if (addressField.text.substring(0, 7) != "http://")
                    addressField.text = "http://" + addressField.text;
                frame.tabs[frame.current].webView.url = addressField.text
            }
        }

        ProgressBar{
            id:progressbar
            anchors.left: settings.right
            anchors.rightMargin: 6
            anchors.verticalCenter:parent.verticalCenter
            value:tab.webView.progress
            width: value < 1.0 ? 200 : 0
            Behavior on width {NumberAnimation{duration:160; easing.type: Easing.OutCubic}}
        }

        ToolButton{
            id:settings
            anchors.right: parent.right
            text: "Settings"
            iconSource: "images/preferences-system.png"
            anchors.verticalCenter:parent.verticalCenter
            onClicked: {
                settingsDialog.visible = true
            }
        }
    }

    SystemPalette{id:syspal}
    color:syspal.window

    TabFrame {
        id:frame
        anchors.top:toolbar.bottom
        anchors.bottom:parent.bottom
        anchors.right:parent.right
        anchors.left:parent.left

        onCurrentChanged: {
            addressField.text = tabs[current].url
        }

        BrowserTab {
            id: tab
        }
    }
}
