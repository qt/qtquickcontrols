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
import QtQuick.Controls 1.1 as Controls
import QtQuick.Controls.Styles 1.1

Column {
    anchors.left: parent.left
    anchors.right: parent.right

    Section {
        anchors.left: parent.left
        anchors.right: parent.right
        caption: qsTr("PieMenu")

        SectionLayout {
            Label {
                text: qsTr("Trigger Mode")
                tooltip: qsTr("Trigger Mode")
            }
            SecondColumnLayout {
                // Work around ComboBox string => int problem.
                Controls.ComboBox {
                    id: comboBox

                    property variant backendValue: backendValues.triggerMode

                    property color textColor: "white"
                    implicitWidth: 180
                    model:  ["TriggerOnPress", "TriggerOnRelease", "TriggerOnClick"]

                    QtObject {
                        property variant valueFromBackend: comboBox.backendValue
                        onValueFromBackendChanged: {
                            comboBox.currentIndex = comboBox.find(comboBox.backendValue.valueToString);
                        }
                    }

                    onCurrentTextChanged: {
                        if (backendValue === undefined)
                            return;

                        if (backendValue.value !== currentText)
                            backendValue.value = comboBox.currentIndex
                    }

                    style: CustomComboBoxStyle {
                        textColor: comboBox.textColor
                    }

                    ExtendedFunctionButton {
                        x: 2
                        y: 4
                        backendValue: comboBox.backendValue
                        visible: comboBox.enabled
                    }
                }
                ExpandingSpacer {
                }
            }
        }
    }
}

