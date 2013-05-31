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
import QtQuick.Layouts 1.0
import "content"

ApplicationWindow {
    width: 950
    height: 600

    signal propertyChanged
    property bool ignoreUpdate: false
    onPropertyChanged: container.resetSize()

    property var propertyMap: []

    property SpinBox widthControl
    property SpinBox heightControl

    color: "lightgray"

    Components{ id: components }
    SystemPalette { id: syspal }

    toolBar: ToolBar {
        width: parent.width
        RowLayout {
            id: alwaysVisible
            anchors.left: parent.left
            anchors.leftMargin: 8
            height: parent.height
            ComboBox {
                id: selector
                Layout.preferredWidth: 140
                model: components.componentModel
                textRole: "name"
            }
            CheckBox {
                id: patternCheckBox
                checked: false
                text: "Background"
            }
            CheckBox {
                id: customStyle
                visible: components.customStyles.get(selector.currentIndex).component !== undefined
                checked: false
                text: !checked ? "Load Custom Style" : "Custom Style loaded"
                onCheckedChanged: {
                    if (checked) {
                        loader.item.style = components.customStyles.get(selector.currentIndex).component
                        enabled = false
                    }
                }
            }
        }

        CheckBox {
            id: startStopAnim
            anchors.left: alwaysVisible.right
            anchors.verticalCenter: parent.verticalCenter
            text: "Stop Animation"
            checked: true
            visible: false
            onCheckedChanged: if (visible) loader.item.___isRunning = checked
        }
    }
    statusBar: StatusBar {
        Row {
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5
            Label { text: "X: " + topLeftHandle.x; width: 70 }
            Label { text: "Y: " + topLeftHandle.y; width: 70 }
            Label { text: "Width: " + container.width; width: 80 }
            Label { text: "Height: "+container.height; width: 80 }
        }
    }

    SplitView {
        anchors.fill: parent
        Flickable {
            id: testBenchRect
            clip: true
            Layout.fillWidth: true

            Image {
                anchors.fill: parent
                source: "../images/checkered.png"
                fillMode: Image.Tile
                opacity: patternCheckBox.checked ? 0.12 : 0
                Behavior on opacity { NumberAnimation { duration: 100 } }
            }

            Rectangle {
                id: container

                property bool pressed: topLeftHandle.pressed || bottomRightHandle.pressed

                function resetSize() {
                    topLeftHandle.x = (testBenchRect.width - loader.item.implicitWidth) / 2 - topLeftHandle.width;
                    topLeftHandle.y = (testBenchRect.height - loader.item.implicitHeight) / 2 - topLeftHandle.height;
                    bottomRightHandle.x = topLeftHandle.x + loader.item.implicitWidth;
                    bottomRightHandle.y = topLeftHandle.y + loader.item.implicitHeight;
                }

                function updateSize() {
                    ignoreUpdate = true
                    if (widthControl)
                        widthControl.value = loader.item.width
                    if (heightControl)
                        heightControl.value = loader.item.height
                    ignoreUpdate = false
                }

                onHeightChanged: updateSize()
                onWidthChanged: updateSize()

                y: Math.floor(topLeftHandle.y + topLeftHandle.height - topLeftHandle.width/2)
                x: Math.floor(topLeftHandle.x + topLeftHandle.width - topLeftHandle.height/2)
                width: Math.floor(bottomRightHandle.x - topLeftHandle.x )
                height: Math.floor(bottomRightHandle.y - topLeftHandle.y)
                color: "transparent"
                border.color: pressed ? "darkgray" : "transparent"

                Loader {
                    id: loader
                    focus: true
                    sourceComponent: selector.model.get(selector.currentIndex).component
                    anchors.fill: parent
                    PropertyLayouts{ id: layouts }
                    onStatusChanged: {

                        startStopAnim.visible = false
                        customStyle.enabled = true
                        customStyle.checked = false

                        if (status == Loader.Ready) {
                            propertyMap = []
                            var arr = new Array

                            for (var prop in item) {

                                if (prop.toString() === "___isRunning") {
                                    startStopAnim.visible = true
                                    continue;
                                }

                                if (!prop.indexOf("on")) { // look only for properties
                                    if (prop.indexOf("Changed") !== (prop.length - 7))
                                        continue;
                                    var substr = prop.slice(2, prop.length - 7)
                                    if (!substr.indexOf("__")) // filter private
                                        continue;

                                    var typeName = "None";
                                    var layout
                                    var enumModelData
                                    var isColor = false
                                    switch (substr) {

                                    case "ActiveFocusOnPress":
                                    case "ActiveFocusOnTab":
                                    case "Enabled":
                                    case "Visible":
                                    case "Checkable":
                                    case "Checked":
                                    case "FrameVisible":
                                    case "AdjustToContentSize":
                                    case "Flat":
                                    case "SelectByMouse":
                                    case "SelectByKeyboard":
                                    case "ReadOnly":
                                    case "Indeterminate":
                                    case "UpdateValueWhileDragging":
                                    case "TickmarksEnabled":
                                    case "SortIndicatorVisible":
                                    case "IsDefault":
                                    case "PartiallyCheckedEnabled":
                                    case "AlternatingRowColors":
                                        layout = layouts.boolLayout
                                        typeName = "Boolean";
                                        break

                                    case "MaximumValue":
                                    case "MinimumValue":
                                    case "Decimals":
                                    case "CurrentIndex":
                                    case "SortIndicatorColumn":
                                        layout = layouts.intLayout
                                        typeName = "Int"
                                        break;

                                    case "Scale":
                                    case "Height":
                                    case "Width":
                                    case "StepSize":
                                    case "Value":
                                    case "Opacity":
                                        layout = layouts.realLayout
                                        typeName = "Real";
                                        break;

                                    case "ImplicitHeight":
                                    case "ActiveFocus":
                                    case "ImplicitWidth":
                                    case "Pressed":
                                    case "CurrentText":
                                        layout = layouts.readonlyLayout
                                        typeName = "ReadOnly"
                                        break;

                                    case "Prefix":
                                    case "Suffix":
                                    case "Text":
                                    case "Title":
                                    case "Tooltip":
                                    case "IconSource":
                                        layout = layouts.stringLayout
                                        typeName = "String";
                                        break;

                                    case "HorizontalAlignment":
                                        layout = layouts.enumLayout
                                        enumModelData = Qt.createQmlObject('import QtQuick 2.1; import QtQuick.Controls 1.0; ListModel {}', layout, '');
                                        typeName = "Enum";
                                        enumModelData.append({ text: "TextEdit.AlignLeft",    value: TextEdit.AlignLeft});
                                        enumModelData.append({ text: "TextEdit.AlignRight",   value: TextEdit.AlignRight});
                                        enumModelData.append({ text: "TextEdit.AlignHCenter", value: TextEdit.AlignHCenter});
                                        break;

                                    case "VerticalAlignment":
                                        layout = layouts.enumLayout
                                        enumModelData = Qt.createQmlObject('import QtQuick 2.1; import QtQuick.Controls 1.0; ListModel {}', layout, '');
                                        typeName = "Enum";
                                        enumModelData.append({ text: "TextEdit.AlignTop",      value: TextEdit.AlignTop});
                                        enumModelData.append({ text: "TextEdit.AlignBottom",   value: TextEdit.AlignBottom});
                                        enumModelData.append({ text: "TextEdit.AlignVCenter",  value: TextEdit.AlignVCenter});
                                        break;

                                    case "InputMethodHints":
                                        layout = layouts.enumLayout
                                        enumModelData = Qt.createQmlObject('import QtQuick 2.1; import QtQuick.Controls 1.0; ListModel {}', layout, '');
                                        typeName = "Enum";
                                        enumModelData.append({ text: "Qt.ImhNone",                  value: Qt.ImhNone});
                                        enumModelData.append({ text: "Qt.ImhHiddenText",            value: Qt.ImhHiddenText});
                                        enumModelData.append({ text: "Qt.ImhSensitiveData",         value: Qt.ImhSensitiveData});
                                        enumModelData.append({ text: "Qt.ImhNoAutoUppercase",       value: Qt.ImhNoAutoUppercase});
                                        enumModelData.append({ text: "Qt.ImhPreferNumbers",         value: Qt.ImhPreferNumbers});
                                        enumModelData.append({ text: "Qt.ImhPreferUppercase",       value: Qt.ImhPreferUppercase});
                                        enumModelData.append({ text: "Qt.ImhPreferLowercase",       value: Qt.ImhPreferLowercase});
                                        enumModelData.append({ text: "Qt.ImhNoPredictiveText",      value: Qt.ImhNoPredictiveText});
                                        enumModelData.append({ text: "Qt.ImhDate",                  value: Qt.ImhDate});
                                        enumModelData.append({ text: "Qt.ImhTime",                  value: Qt.ImhTime});
                                        enumModelData.append({ text: "Qt.ImhDigitsOnly",            value: Qt.ImhDigitsOnly});
                                        enumModelData.append({ text: "Qt.ImhFormattedNumbersOnly",  value: Qt.ImhFormattedNumbersOnly});
                                        enumModelData.append({ text: "Qt.ImhUppercaseOnly",         value: Qt.ImhUppercaseOnly});
                                        enumModelData.append({ text: "Qt.ImhLowercaseOnly",         value: Qt.ImhLowercaseOnly});
                                        enumModelData.append({ text: "Qt.ImhDialableCharactersOnly",value: Qt.ImhDialableCharactersOnly});
                                        enumModelData.append({ text: "Qt.ImhEmailCharactersOnly",   value: Qt.ImhEmailCharactersOnly});
                                        enumModelData.append({ text: "Qt.ImhUrlCharactersOnly",     value: Qt.ImhUrlCharactersOnly});
                                        break;

                                    case "Orientation":
                                        layout = layouts.enumLayout
                                        enumModelData = Qt.createQmlObject('import QtQuick 2.1; import QtQuick.Controls 1.0; ListModel {}', layout, '');
                                        typeName = "Enum";
                                        enumModelData.append({ text: "Qt.Horizontal",    value: Qt.Horizontal});
                                        enumModelData.append({ text: "Qt.Vertical",      value: Qt.Vertical});
                                        break;

                                    case "EchoMode":
                                        layout = layouts.enumLayout
                                        enumModelData = Qt.createQmlObject('import QtQuick 2.1; import QtQuick.Controls 1.0; ListModel {}', layout, '');
                                        typeName = "Enum";
                                        enumModelData.append({ text: "TextInput.Normal",            value: TextInput.Normal});
                                        enumModelData.append({ text: "TextInput.Password",          value: TextInput.Password});
                                        enumModelData.append({ text: "TextInput.NoEcho",            value: TextInput.NoEcho});
                                        enumModelData.append({ text: "TextInput.PasswordEchoOnEdit",value: TextInput.PasswordEchoOnEdit});
                                        break;

                                    case "BackgroundColor":
                                    case "TextColor":
                                        isColor = true
                                        layout = layouts.enumLayout
                                        enumModelData = Qt.createQmlObject('import QtQuick 2.1; import QtQuick.Controls 1.0; ListModel {}', layout, '');
                                        typeName = "Enum";
                                        enumModelData.append({ text: "Amber",       value: "#FF7E00"});
                                        enumModelData.append({ text: "Azure",       value: "#007FFF"});
                                        enumModelData.append({ text: "Carmine red", value: "#FF0038"});
                                        break;

                                    case "SortIndicatorOrder":
                                        layout = layouts.enumLayout
                                        enumModelData = Qt.createQmlObject('import QtQuick 2.1; import QtQuick.Controls 1.0; ListModel {}', layout, '');
                                        typeName = "Enum";
                                        enumModelData.append({ text: "Qt.AscendingOrder",    value: Qt.AscendingOrder});
                                        enumModelData.append({ text: "Qt.DescendingOrder",   value: Qt.DescendingOrder});
                                        break;

                                    case "CheckedState":
                                        layout = layouts.enumLayout
                                        enumModelData = Qt.createQmlObject('import QtQuick 2.1; import QtQuick.Controls 1.0; ListModel {}', layout, '');
                                        typeName = "Enum";
                                        enumModelData.append({ text: "Qt.Checked",          value: Qt.Checked});
                                        enumModelData.append({ text: "Qt.Unchecked",        value: Qt.Unchecked});
                                        enumModelData.append({ text: "Qt.PartiallyChecked", value: Qt.PartiallyChecked});
                                        break;


                                    default:
                                        break;
                                    }

                                    if (substr.length > 1)
                                        substr = substr[0].toLowerCase() + substr.substring(1)
                                    else
                                        substr = substr.toLowerCase()

                                    var val = item[substr] + "" // All model properties must be the same type

                                    if (typeName != "None" && val !== undefined) {
                                        if (isColor)
                                            enumModelData.append({ text: "Default",    value: val})

                                        if (arr[typeName] === undefined)
                                            arr[typeName] = []
                                        arr[typeName].push({name: substr , result: val, typeString: typeName, layoutComponent: layout, enumModel: enumModelData})
                                    }
                                }
                                propertyMap = arr;
                                container.resetSize();
                            }
                        }
                    }

                    Rectangle {
                        id: marginsRect
                        color: "transparent"
                        // opacity: container.pressed && loader.item.styling && loader.item.styling.topMargin != undefined ? 1 : 0
                        border.color: Qt.rgba(0, 0, 0, 0.2)
                        anchors.fill: parent
                        z: 2
                        Connections {
                            target: loader
                            onItemChanged: {
                                if (!loader.item || !loader.item.styling) return;
                                marginsRect.anchors.leftMargin = Math.max(loader.item.styling.leftMargin, 0);
                                marginsRect.anchors.rightMargin = Math.max(loader.item.styling.rightMargin, 0);
                                marginsRect.anchors.topMargin = Math.max(loader.item.styling.topMargin, 0);
                                marginsRect.anchors.bottomMargin = Math.max(loader.item.styling.bottomMargin, 0);
                            }
                        }
                    }
                }
            }

            MouseArea {
                id: topLeftHandle
                width: 10
                height: 10

                drag.target: topLeftHandle
                drag.minimumX: 0; drag.minimumY: 0
                drag.maximumX: bottomRightHandle.x - width
                drag.maximumY: bottomRightHandle.y - height
                Rectangle {
                    anchors.fill: parent
                    color: "lightsteelblue"
                    border.color: "steelblue"
                }
            }

            MouseArea {
                id: bottomRightHandle
                width: 10
                height: 10

                drag.target: bottomRightHandle
                drag.minimumX: topLeftHandle.x + width
                drag.minimumY: topLeftHandle.y + height
                drag.maximumX: testBenchRect.width - width;
                drag.maximumY: testBenchRect.height - height

                Rectangle {
                    anchors.fill: parent
                    color: "lightsteelblue"
                    border.color: "steelblue"
                }
            }
        }
        Rectangle {
            id: sidebar
            color : syspal.window
            width: 200
            ScrollView {
                id: scrollView
                anchors.fill: parent
                flickableItem.flickableDirection: Flickable.VerticalFlick
                Column {
                    id: properties
                    anchors.left: parent ? parent.left : undefined
                    anchors.top: parent ? parent.top : undefined
                    anchors.margins: 10
                    width: scrollView.viewport.width - 20
                    spacing: 8
                    Repeater {
                        model: ["Boolean", "String","Int", "Real", "ReadOnly", "Enum"]
                        Repeater {
                            model: propertyMap[modelData]
                            Loader {
                                width: properties.width
                                sourceComponent: modelData.layoutComponent
                                property string name: modelData.name
                                property var value: modelData.value
                                property var result: modelData.result
                                property var enumModel: modelData.enumModel
                            }
                        }
                    }
                }
            }
        }
    }
}
