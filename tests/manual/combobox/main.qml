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
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Window 2.1

ApplicationWindow {
    width: 640
    height: 480
    minimumWidth: 400
    minimumHeight: 300


    ListModel {
        id: listModel
        ListElement { text: "Norway"}
        ListElement { text: "North Korea"}
        ListElement { text: "Noruag"}
        ListElement { text: "Noman"}
        ListElement { text: "Nothing"}
        ListElement { text: "Nargl"}
        ListElement { text: "Argldaf"}
    }
    ColumnLayout {
        anchors.centerIn: parent
        RowLayout {
            Label { text: "validated model" ; Layout.fillWidth: true }
            ComboBox {
                editable: true
                validator: IntValidator { bottom: 0 ; top: 100 }
                model: [1, 2, 3, 4, 5]
            }
        }
        RowLayout {
            Label { text: "Array" ; Layout.fillWidth: true}
            ComboBox {
                width: 200
                model: ['Banana', 'Coco', 'Coconut', 'Apple', 'Cocomuffin' ]
                style: ComboBoxStyle {}
            }
            ComboBox {
                width: 200
                editable: true
                model: ['Banana', 'Coco', 'Coconut', 'Apple', 'Cocomuffin' ]
                style: ComboBoxStyle {}
            }
        }
        RowLayout {
            Label { text: "StandardItemModel" ; Layout.fillWidth: true}
            ComboBox {
                width: 200
                textRole: "display"
                model: standardmodel
                style: ComboBoxStyle {}
            }
            ComboBox {
                width: 200
                textRole: "display"
                editable: true
                model: standardmodel
                style: ComboBoxStyle {}
            }
        }
        RowLayout {
            Label { text: "ListModel" ; Layout.fillWidth: true}
            ComboBox {
                width: 200
                textRole: "text"
                model: listModel
            }
            ComboBox {
                width: 200
                textRole: "text"
                editable: true
                model: listModel
            }
        }
        RowLayout {
            Label { text: "QStringList" ; Layout.fillWidth: true}
            ComboBox {
                width: 200
                model: stringmodel
            }
            ComboBox {
                width: 200
                editable: true
                model: stringmodel
            }
        }
    }
}
