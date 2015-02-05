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
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0

QtObject {
    property Component boolLayout: CheckBox {
        checked: visible ? (result == "true") : false
        text: name
        onCheckedChanged: {
            if (!ignoreUpdate) {
                loader.item[name] = checked
                propertyChanged()
            }
        }
    }

    property Component intLayout: RowLayout {
        spacing: 4
        Label {
            text: name + ":"
            Layout.minimumWidth: 100
        }
        SpinBox {
            value: result
            maximumValue: 9999
            minimumValue: -9999
            Layout.fillWidth: true
            onValueChanged: {
                if (!ignoreUpdate) {
                    loader.item[name] = value
                    propertyChanged()
                }
            }
        }
    }

    property Component realLayout: RowLayout {
        spacing: 4
        Label {
            text: name + ":"
            Layout.minimumWidth: 100
        }
        SpinBox {
            id: spinbox
            value: result
            decimals: 1
            stepSize: 0.5
            maximumValue: 9999
            minimumValue: -9999
            Layout.fillWidth: true
            onValueChanged: {
                if (!ignoreUpdate) {
                    loader.item[name] = value
                    if (name != "width" && name != "height") // We don't want to reset size when size changes
                        propertyChanged()
                }
            }

            Component.onCompleted: {
                if (name == "width")
                    widthControl = spinbox
                else if (name == "height")
                    heightControl = spinbox
            }
        }
    }

    property Component stringLayout: RowLayout {
        spacing: 4
        Label {
            text: name + ":"
            width: 100
        }
        TextField {
            id: tf
            text: result
            Layout.fillWidth: true
            onTextChanged: {
                if (!ignoreUpdate) {
                    loader.item[name] = tf.text
                    propertyChanged()
                }
            }
        }
    }

    property Component readonlyLayout: RowLayout {
        height: 20
        Label {
            id: text
            height: 20
            text: name + ":"
        }
        Label {
            height: 20
            anchors.right: parent.right
            Layout.fillWidth: true
            text: loader.item[name] !== undefined ? loader.item[name] : ""
        }
    }

    property Component enumLayout: Column {
        id: enumLayout
        spacing: 4

        Label { text: name + ":" }

        ComboBox {
            height: 20
            width: parent.width
            model: enumModel
            onCurrentIndexChanged: {
                if (!ignoreUpdate) {
                    loader.item[name] = model.get(currentIndex).value
                    propertyChanged()
                }
            }
            Component.onCompleted: currentIndex = getDefaultIndex()
            function getDefaultIndex() {
                for (var index = 0 ; index < model.count ; ++index) {
                    if ( model.get(index).value === result )
                        return index
                }
                return 0;
            }

        }
    }
}
