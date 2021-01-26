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

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles.Android 1.0

Style {
    readonly property StatusBar control: __control

    padding {
        left: 0
        right: 0
        top: AndroidStyle.styleDef.actionBarStyle.View_paddingTop
        bottom: AndroidStyle.styleDef.actionBarStyle.View_paddingBottom
    }

    property Component panel: Item {
        implicitWidth: AndroidStyle.styleDef.actionBarStyle.View_minWidth || 0
        implicitHeight: AndroidStyle.styleDef.actionButtonStyle.View_minHeight || 0
    }
}
