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

Item {
    property Component button: Button { text: "Push me"}
    property Component checkbox: CheckBox { text: "A CheckBox" }
    property Component radiobutton: RadioButton { text: "A RadioButton" }
    property Component textfield: TextField { }
    property Component spinbox: SpinBox {}
    property Component slider : Slider {}
    property Component combobox: ComboBox { model: testDataModel }
    property Component textarea: TextArea { text: loremIpsum }
    property Component progressbar: ProgressBar {
        Timer {
            id: timer
            running: true
            repeat: true
            interval: 25
            onTriggered: {
                var next = parent.value + 0.01;
                parent.value = (next > parent.maximumValue) ? parent.minimumValue : next;
            }
        }
    }
    property var model: ListModel{
        id: testDataModel
        Component.onCompleted: {
            for (var i = 0 ; i < 10 ; ++i)
                testDataModel.append({text: "Value " + i});
        }
    }

    property string loremIpsum:
            "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor "+
            "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor "+
            "incididunt ut labore et dolore magna aliqua.\n Ut enim ad minim veniam, quis nostrud "+
            "exercitation ullamco laboris nisi ut aliquip ex ea commodo cosnsequat. ";

    property var componentModel: ListModel {
        Component.onCompleted: {
            append({ name: "Button",        component: button});
            append({ name: "CheckBox",      component: checkbox});
            append({ name: "RadioButton",   component: radiobutton});
            append({ name: "Slider",        component: slider});
            append({ name: "ProgressBar",   component: progressbar});
            append({ name: "TextField",     component: textfield});
            append({ name: "TextArea",      component: textarea});
            append({ name: "SpinBox",       component: spinbox});
        }
    }
}
