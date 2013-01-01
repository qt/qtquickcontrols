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
    property Component radiobutton:  RadioButton { text: "A RadioButton" }
    property Component textfield: TextField { }
    property Component textarea: TextArea { }
    property Component combobox: ComboBox { model: testDataModel }
    property Component spinbox: SpinBox { id: spinBox }
    property Component slider : Slider {
        function formatValue(v) {
            v = Math.round(v);
            var absV = Math.abs(v);
            if (sliderOptionTimeFormatted.checked) {
                var seconds = Math.floor(absV % 60);
                var minutes = Math.floor(absV / 60);

                if (seconds < 10) seconds = "0" + seconds;
                return (v < 0 ? "-" : "") + minutes + ":" + seconds
            }
            return v;
        }
    }

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
        ListElement { text: "1) Apple" }
        ListElement { text: "2) Banana" }
        ListElement { text: "3) Coconut" }
        ListElement { text: "4) Orange" }
        ListElement { text: "5) Kiwi" }
        ListElement { text: "6) Apple" }
        ListElement { text: "7) Banana" }
        ListElement { text: "8) Coconut" }
        ListElement { text: "9) Orange" }
        ListElement { text: "10) Kiwi" }
        ListElement { text: "11) Apple" }
        ListElement { text: "12) Banana" }
        ListElement { text: "13) Coconut" }
        ListElement { text: "14) Orange" }
        ListElement { text: "15) Kiwi" }
        ListElement { text: "16) Apple" }
        ListElement { text: "17) Banana" }
        ListElement { text: "18) Coconut" }
        ListElement { text: "19) Orange" }
        ListElement { text: "20) Kiwi" }
        ListElement { text: "21) Apple" }
        ListElement { text: "22) Banana" }
        ListElement { text: "23) Coconut" }
        ListElement { text: "24) Orange" }
        ListElement { text: "25) Kiwi" }
        ListElement { text: "26) Apple" }
        ListElement { text: "27) Banana" }
        ListElement { text: "28) Coconut" }
        ListElement { text: "29) Orange" }
        ListElement { text: "30) Kiwi" }
    }
}
