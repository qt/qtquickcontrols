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
        caption: qsTr("CircularGauge")

        SectionLayout {
            Label {
                text: qsTr("Value")
                tooltip: qsTr("Value")
            }
            SecondColumnLayout {
                SpinBox {
                    backendValue: backendValues.value
                    minimumValue: backendValues.minimumValue.value
                    maximumValue: backendValues.maximumValue.value
                }
                ExpandingSpacer {
                }
            }

            Label {
                text: qsTr("Minimum Value")
                tooltip: qsTr("Minimum Value")
            }
            SecondColumnLayout {
                SpinBox {
                    id: minimumValueSpinBox
                    backendValue: backendValues.minimumValue
                    minimumValue: 0
                    maximumValue: backendValues.maximumValue.value
                }
                ExpandingSpacer {
                }
            }

            Label {
                text: qsTr("Maximum Value")
                tooltip: qsTr("Maximum Value")
            }
            SecondColumnLayout {
                SpinBox {
                    id: maximumValueSpinBox
                    backendValue: backendValues.maximumValue
                    minimumValue: backendValues.minimumValue.value
                    maximumValue: 1000
                }
                ExpandingSpacer {
                }
            }

            Label {
                text: qsTr("Step Size")
                tooltip: qsTr("Step Size")
            }
            SecondColumnLayout {
                SpinBox {
                    backendValue: backendValues.stepSize
                    minimumValue: 0
                    maximumValue: backendValues.maximumValue.value
                }
                ExpandingSpacer {
                }
            }
        }
    }
}

