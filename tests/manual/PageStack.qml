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
import QtQuick.Window 2.0
import QtQuick.Controls 1.0

Window {
    width: 480
    height: 640

    PageStack {
        id: pageStack
        anchors.fill: parent
        initialPage: pageComponent
    }

    property PageTransition fadeTransition:  PageTransition {
        function cleanupAnimation(properties)
        {
            properties.exitPage.visible = false
            properties.exitPage.opacity = 1
        }

        property Component pushAnimation: PageAnimation {
            PropertyAnimation {
                target: enterPage
                property: "opacity"
                from: 0
                to: 1
            }
            PropertyAnimation {
                target: exitPage
                property: "opacity"
                from: 1
                to: 0
            }
        }
    }

    property PageTransition rotateTransition:  PageTransition {
        function cleanupAnimation(properties)
        {
            properties.exitPage.x = 0
            properties.exitPage.rotation = 0
        }

        property Component pushAnimation: PageAnimation {
            SequentialAnimation {
                ScriptAction {
                    script: enterPage.rotation = 90
                }
                PropertyAnimation {
                    target: enterPage
                    property: "x"
                    from: enterPage.width
                    to: 0
                }
                PropertyAnimation {
                    target: enterPage
                    property: "rotation"
                    from: 90
                    to: 0
                }
            }
            PropertyAnimation {
                target: exitPage
                property: "x"
                from: 0
                to: -exitPage.width
            }
        }
    }

    property PageTransition slideTransition:  PageTransition {
        function cleanupAnimation(properties)
        {
            properties.exitPage.x = 0
        }

        property Component pushAnimation: PageAnimation {
            PropertyAnimation {
                target: enterPage
                property: "x"
                from: enterPage.width
                to: 0
            }
            PropertyAnimation {
                target: exitPage
                property: "x"
                from: 0
                to: exitPage.width
            }
        }
    }

    Component {
        id: pageComponent
        Page {
            id: page
            Component.onDestruction: console.log("destroyed component page: " + index)
            property bool pushFromOnCompleted: false
            Component.onCompleted: if (pushFromOnCompleted) pageStack.push(pageComponent)
            //pageTransition: rotateTransition

            Rectangle {
                anchors.fill: parent
                color: index % 2 ? "green" : "yellow"

                Column {
                    Text {
                        text: "This is component page: " + page.index
                    }
                    Text {
                        text: "Current status: " + page.status
                    }
                    Text { text:" " }
                    Button {
                        text: "Push component page"
                        onClicked: pageStack.push(pageComponent)
                    }
                    Button {
                        text: "Push inline page"
                        onClicked: pageStack.push(pageInline)
                    }
                    Button {
                        text: "Push page as JS object"
                        onClicked: pageStack.push({page:pageComponent})
                    }
                    Button {
                        text: "Push immediate"
                        onClicked: pageStack.push({page:pageComponent, immediate:true})
                    }
                    Button {
                        text: "Push replace"
                        onClicked: pageStack.push({page:pageComponent, replace:true})
                    }
                    Button {
                        text: "Push inline page with destroyOnPop == true"
                        onClicked: pageStack.push({page:pageInline, destroyOnPop:true})
                    }
                    Button {
                        text: "Push component page with destroyOnPop == false"
                        onClicked: pageStack.push({page:pageComponent, destroyOnPop:false})
                    }
                    Button {
                        text: "Push from Page.onCompleted"
                        onClicked: pageStack.push({page:pageComponent, properties:{pushFromOnCompleted:true}})
                    }
                    Button {
                        text: "Pop"
                        onClicked: pageStack.pop()
                    }
                    Button {
                        text: "Pop(null)"
                        onClicked: pageStack.pop(null)
                    }
                    Button {
                        text: "Search for page 3, and pop down to it"
                        onClicked: pageStack.pop(pageStack.find(function(page) { if (page.index === 3) return true }))
                    }
                    Button {
                        text: "Search for page 3, and pop down to it (dontLoad == true)"
                        onClicked: pageStack.pop(pageStack.find(function(page) { if (page.index === 3) return true }, true))
                    }
                    Button {
                        text: "Clear"
                        onClicked: pageStack.clear()
                    }
                    Button {
                        text: "Push array of 100 pages"
                        onClicked: {
                            var a = new Array
                            for (var i=0; i<100; ++i)
                                a.push(pageComponent)
                            pageStack.push(a)
                        }
                    }
                    Button {
                        text: "Push 10 pages one by one"
                        onClicked: {
                            for (var i=0; i<10; ++i)
                                pageStack.push(pageComponent)
                        }
                    }
                    Button {
                        text: "Complete transition"
                        onClicked: pageStack.completeTransition()
                    }
                }
            }
        }
    }

    Page {
        id: pageInline
        Component.onDestruction: console.log("destroyed inline page: " + index)

        pageTransition: rotateTransition

        Rectangle {
            anchors.fill: parent
            color: pageInline.index % 2 ? "green" : "yellow"

            Column {
                Text {
                    text: "This is inline page: " + pageInline.index
                }
                Text {
                    text: "Current status: " + pageInline.status
                }
                Button {
                    text: "Push component page"
                    onClicked: pageStack.push(pageComponent)
                }
                Button {
                    text: "Push inline page"
                    onClicked: pageStack.push(pageInline)
                }
                Button {
                    text: "Push page as JS object"
                    onClicked: pageStack.push({page:pageComponent})
                }
                Button {
                    text: "Push immediate"
                    onClicked: pageStack.push({page:pageComponent, immediate:true})
                }
                Button {
                    text: "Push inline page with destroyOnPop == true"
                    onClicked: pageStack.push({page:pageInline, destroyOnPop:true})
                }
                Button {
                    text: "Push component page with destroyOnPop == false"
                    onClicked: pageStack.push({page:pageComponent, destroyOnPop:false})
                }
                Button {
                    text: "Pop"
                    onClicked: pageStack.pop()
                }
                Button {
                    text: "Pop(null)"
                    onClicked: pageStack.pop(null)
                }
                Button {
                    text: "Search for page 3, and pop down to it"
                    onClicked: pageStack.pop(pageStack.find(function(page) { if (page.index === 3) return true }))
                }
                Button {
                    text: "Search for page 3, and pop down to it (dontLoad == true)"
                    onClicked: pageStack.pop(pageStack.find(function(page) { if (page.index === 3) return true }, true))
                }
                Button {
                    text: "Clear"
                    onClicked: pageStack.clear()
                }
                Button {
                    text: "Push array of 100 pages"
                    onClicked: {
                        var a = new Array
                        for (var i=0; i<100; ++i)
                            a.push(pageComponent)
                        pageStack.push(a)
                    }
                }
                Button {
                    text: "Push 10 pages one by one"
                    onClicked: {
                        for (var i=0; i<10; ++i)
                            pageStack.push(pageComponent)
                    }
                }
                Button {
                    text: "Complete transition"
                    onClicked: pageStack.completeTransition()
                }
            }
        }
    }
}
