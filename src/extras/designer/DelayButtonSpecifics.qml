/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Quick Extras module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:COMM$
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** $QT_END_LICENSE$
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
****************************************************************************/

import QtQuick 2.1
import HelperWidgets 2.0
import QtQuick.Layouts 1.0

Column {
    anchors.left: parent.left
    anchors.right: parent.right

    Section {
        anchors.left: parent.left
        anchors.right: parent.right
        caption: qsTr("DelayButton")

        SectionLayout {
            Label {
                text: qsTr("Text")
                tooltip: qsTr("Text")
            }
            SecondColumnLayout {
                LineEdit {
                    backendValue: backendValues.text
                    showTranslateCheckBox: true
                    implicitWidth: 180
                }
                ExpandingSpacer {
                }
            }

//            Label {
//                text: qsTr("Disable Button")
//                tooltip: qsTr("Disable Button")
//            }
//            SecondColumnLayout {
//                CheckBox {
//                    backendValue: backendValues.disabled
//                    implicitWidth: 180
//                }
//                ExpandingSpacer {
//                }
//            }

            Label {
                text: qsTr("Delay")
                tooltip: qsTr("Delay")
            }
            SecondColumnLayout {
                SpinBox {
                    backendValue: backendValues.delay
                    minimumValue: 0
                    maximumValue: 60000
                }
                ExpandingSpacer {
                }
            }
        }
    }
}
