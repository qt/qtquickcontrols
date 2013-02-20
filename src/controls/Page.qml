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
import QtQuick.Controls 1.0

/*!
    \qmltype Page
    \inqmlmodule QtQuick.Controls 1.0
    \ingroup navigation
    \brief A Page is an Item you can push on a PageStack

    A \a Page is the main Item pushed onto a \l PageStack. It normally contains a discrete
    set of information and interaction elements meant for the user to solve a specific task, and
    contains properties to use when working with a PageStack.
    See \l PageStack for more information.

    \qml
    \endqml
*/

Item {
    id: root

    /*! \readonly
         The status of the page. It can have one of the following values:
         \list
         \li \c PageStatus.Inactive: the page is not visible
         \li \c PageStatus.Activating: the page is transitioning into becoming an active page on the stack
         \li \c PageStatus.Active: the page is on top of the stack
         \li \c PageStatus.Deactivating: the page is transitioning into becoming inactive
         \endlist */
    readonly property alias status: root.__status
    /*! \readonly
         This property contains the PageStack the page is in. If the page is not inside
         a PageStack, \a pageStack will be \c null. */
    readonly property alias pageStack: root.__pageStack
    /*! \readonly
         This property contains the index of the page inside \l{pageStack}{PageStack}, so
         that \l{PageStack::get()}{pageStack.get(index)} will
         return the page itself. If \l{Page::pageStack}{pageStack} is \c null, \a index
         will be \c -1. */
    readonly property alias index: root.__index
    /*! This property can be set to override the default animations used
         during a page transition. To better understand how to use this
         property, refer to the \l{PageStack#Transitions}{transition documentation} in PageStack.
         \sa {PageStack::animations}{PageStack.animations} */
    property PageTransition pageTransition

    visible: false // PageStack will show/hide the page as needed
    width: parent.width
    height: parent.height

    // ********** PRIVATE API **********

    /*! \internal */
    property int __status: PageStatus.Inactive
    /*! \internal */
    property PageStack __pageStack: null
    /*! \internal */
    property int __index: -1
}
