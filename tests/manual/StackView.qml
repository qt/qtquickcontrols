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
import QtQuick.Window 2.1
import QtQuick.Controls 1.2

Window {
    width: 480
    height: 640

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: itemComponent
    }

    property StackViewDelegate fadeTransition: StackViewDelegate {
        function transitionFinished(properties)
        {
            properties.exitItem.visible = false
            properties.exitItem.opacity = 1
        }

        property Component pushTransition: StackViewTransition {
            PropertyAnimation {
                target: enterItem
                property: "opacity"
                from: 0
                to: 1
            }
            PropertyAnimation {
                target: exitItem
                property: "opacity"
                from: 1
                to: 0
            }
        }
    }

    property StackViewDelegate rotateTransition: StackViewDelegate {
        function transitionFinished(properties)
        {
            properties.exitItem.x = 0
            properties.exitItem.rotation = 0
        }

        property Component pushTransition: StackViewTransition {
            SequentialAnimation {
                ScriptAction {
                    script: enterItem.rotation = 90
                }
                PropertyAnimation {
                    target: enterItem
                    property: "x"
                    from: enterItem.width
                    to: 0
                }
                PropertyAnimation {
                    target: enterItem
                    property: "rotation"
                    from: 90
                    to: 0
                }
            }
            PropertyAnimation {
                target: exitItem
                property: "x"
                from: 0
                to: -exitItem.width
            }
        }
    }

    property StackViewDelegate slideTransition: StackViewDelegate {
        function transitionFinished(properties)
        {
            properties.exitItem.x = 0
        }

        property Component pushTransition: StackViewTransition {
            PropertyAnimation {
                target: enterItem
                property: "x"
                from: enterItem.width
                to: 0
            }
            PropertyAnimation {
                target: exitItem
                property: "x"
                from: 0
                to: exitItem.width
            }
        }
    }

    Component {
        id: itemComponent
        Item {
            id: item
            width: parent.width
            height: parent.height
            Component.onDestruction: console.log("destroyed component item: " + Stack.index)
            property bool pushFromOnCompleted: false
            Component.onCompleted: if (pushFromOnCompleted) stackView.push(itemComponent)

            Rectangle {
                anchors.fill: parent
                color: item.Stack.index % 2 ? "green" : "yellow"

                Column {
                    Text {
                        text: "This is component item: " + item.Stack.index
                    }
                    Text {
                        text: "Current status: " + item.Stack.status
                    }
                    Text { text:" " }
                    Button {
                        text: "Push component item"
                        onClicked: stackView.push(itemComponent)
                    }
                    Button {
                        text: "Push inline item"
                        onClicked: stackView.push(itemInline)
                    }
                    Button {
                        text: "Push item as JS object"
                        onClicked: stackView.push({item:itemComponent})
                    }
                    Button {
                        text: "Push immediate"
                        onClicked: stackView.push({item:itemComponent, immediate:true})
                    }
                    Button {
                        text: "Push replace"
                        onClicked: stackView.push({item:itemComponent, replace:true})
                    }
                    Button {
                        text: "Push inline item with destroyOnPop == true"
                        onClicked: stackView.push({item:itemInline, destroyOnPop:true})
                    }
                    Button {
                        text: "Push component item with destroyOnPop == false"
                        onClicked: stackView.push({item:itemComponent, destroyOnPop:false})
                    }
                    Button {
                        text: "Push from item.onCompleted"
                        onClicked: stackView.push({item:itemComponent, properties:{pushFromOnCompleted:true}})
                    }
                    Button {
                        text: "Pop"
                        onClicked: stackView.pop()
                    }
                    Button {
                        text: "Pop(null)"
                        onClicked: stackView.pop(null)
                    }
                    Button {
                        text: "Search for item 3, and pop down to it"
                        onClicked: stackView.pop(stackView.find(function(item) { if (item.Stack.index === 3) return true }))
                    }
                    Button {
                        text: "Search for item 3, and pop down to it (dontLoad == true)"
                        onClicked: stackView.pop(stackView.find(function(item) { if (item.Stack.index === 3) return true }, true))
                    }
                    Button {
                        text: "Clear"
                        onClicked: stackView.clear()
                    }
                    Button {
                        text: "Push array of 100 items"
                        onClicked: {
                            var a = new Array
                            for (var i=0; i<100; ++i)
                                a.push(itemComponent)
                            stackView.push(a)
                        }
                    }
                    Button {
                        text: "Push 10 items one by one"
                        onClicked: {
                            for (var i=0; i<10; ++i)
                                stackView.push(itemComponent)
                        }
                    }
                    Button {
                        text: "Complete transition"
                        onClicked: stackView.completeTransition()
                    }
                }
            }
        }
    }

    Item {
        id: itemInline
        visible: false
        width: parent.width
        height: parent.height
        Component.onDestruction: console.log("destroyed inline item: " + Stack.index)

        Rectangle {
            anchors.fill: parent
            color: itemInline.Stack.index % 2 ? "green" : "yellow"

            Column {
                Text {
                    text: "This is inline item: " + itemInline.Stack.index
                }
                Text {
                    text: "Current status: " + itemInline.Stack.status
                }
                Button {
                    text: "Push component item"
                    onClicked: stackView.push(itemComponent)
                }
                Button {
                    text: "Push inline item"
                    onClicked: stackView.push(itemInline)
                }
                Button {
                    text: "Push item as JS object"
                    onClicked: stackView.push({item:itemComponent})
                }
                Button {
                    text: "Push immediate"
                    onClicked: stackView.push({item:itemComponent, immediate:true})
                }
                Button {
                    text: "Push inline item with destroyOnPop == true"
                    onClicked: stackView.push({item:itemInline, destroyOnPop:true})
                }
                Button {
                    text: "Push component item with destroyOnPop == false"
                    onClicked: stackView.push({item:itemComponent, destroyOnPop:false})
                }
                Button {
                    text: "Pop"
                    onClicked: stackView.pop()
                }
                Button {
                    text: "Pop(null)"
                    onClicked: stackView.pop(null)
                }
                Button {
                    text: "Search for item 3, and pop down to it"
                    onClicked: stackView.pop(stackView.find(function(item) { if (itemInline.Stack.index === 3) return true }))
                }
                Button {
                    text: "Search for item 3, and pop down to it (dontLoad == true)"
                    onClicked: stackView.pop(stackView.find(function(item) { if (itemInline.Stack.index === 3) return true }, true))
                }
                Button {
                    text: "Clear"
                    onClicked: stackView.clear()
                }
                Button {
                    text: "Push array of 100 items"
                    onClicked: {
                        var a = new Array
                        for (var i=0; i<100; ++i)
                            a.push(itemComponent)
                        stackView.push(a)
                    }
                }
                Button {
                    text: "Push 10 items one by one"
                    onClicked: {
                        for (var i=0; i<10; ++i)
                            stackView.push(itemComponent)
                    }
                }
                Button {
                    text: "Complete transition"
                    onClicked: stackView.completeTransition()
                }
            }
        }
    }
}
