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
import "private"
import "Styles/Settings.js" as Settings

/*!
     \qmltype Button
     \inqmlmodule QtDesktop 1.0
     \brief A normal button

     A normal command button. Similar to the QPushButton widget.

     The push button is perhaps the most commonly used widget in any graphical user interface.
     Push (click) a button to command the computer to perform some action, or to answer a question.
     Typical buttons are OK, Apply, Cancel, Close, Yes, No and Help.

 */
BasicButton {
    id: button
    /*! This property holds whether the push button is the default button.
        Default buttons decide what happens when the user presses enter in a dialog without giving a button explicit focus.
        Note : This property is currently ignored by Dialog
    */
    property bool defaultbutton: false

    /*! This property holds the style hints. Style hints are special properties that only affect specific themes or styles
      An example of a styleHint can be: styleHints: "small" */
    property var styleHints: []

    /*! This property holds the text shown on the button.
        If the button has no text, the \l text property will be an empty string. */
    property string text

    /*! This property holds the icon shown on the button.
        If the button has no icon, the \l iconSource property will be an empty string. */
    property url iconSource

    Accessible.name: text
    style: Qt.createComponent(Settings.THEME_PATH + "/ButtonStyle.qml")

}

