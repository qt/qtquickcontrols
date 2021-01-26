/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
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

//
//  W A R N I N G
//  -------------
//
// This file is not part of the Qt API.  It exists purely as an
// implementation detail.  This file may change from version to
// version without notice, or even be removed.
//
// We mean it.
//

import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

/*!
    \qmltype TableViewItemDelegateLoader
    \internal
    \qmlabstract
    \inqmlmodule QtQuick.Controls.Private
*/

Loader {
    id: itemDelegateLoader

    width: __column ? __column.width : 0
    height: parent ? parent.height : 0
    visible: __column ? __column.visible : false

    property bool isValid: false
    sourceComponent: (__model === undefined || !isValid) ? null
                     : __column && __column.delegate ? __column.delegate : __itemDelegate

    // All these properties are internal
    property int __index: index
    property Item __rowItem: null
    property var __model: __rowItem ? __rowItem.itemModel : undefined
    property var __modelData: __rowItem ? __rowItem.itemModelData : undefined
    property TableViewColumn __column: null
    property Component __itemDelegate: null
    property var __mouseArea: null
    property var __style: null

    // These properties are exposed to the item delegate
    readonly property var model: __model
    readonly property var modelData: __modelData

    property QtObject styleData: QtObject {
        readonly property int row: __rowItem ? __rowItem.rowIndex : -1
        readonly property int column: __index
        readonly property int elideMode: __column ? __column.elideMode : Text.ElideLeft
        readonly property int textAlignment: __column ? __column.horizontalAlignment : Text.AlignLeft
        readonly property bool selected: __rowItem ? __rowItem.itemSelected : false
        readonly property bool hasActiveFocus: __rowItem ? __rowItem.activeFocus : false
        readonly property bool pressed: __mouseArea && row === __mouseArea.pressedRow && column === __mouseArea.pressedColumn
        readonly property color textColor: __rowItem ? __rowItem.itemTextColor : "black"
        readonly property string role: __column ? __column.role : ""
        readonly property var value: model && model.hasOwnProperty(role) ? model[role] // Qml ListModel and QAbstractItemModel
                                     : modelData && modelData.hasOwnProperty(role) ? modelData[role] // QObjectList / QObject
                                     : modelData != undefined ? modelData : "" // Models without role
        onRowChanged: if (row !== -1) itemDelegateLoader.isValid = true
    }
}
