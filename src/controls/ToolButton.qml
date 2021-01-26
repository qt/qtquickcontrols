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
import QtQuick.Controls.Private 1.0

/*!
    \qmltype ToolButton
    \inqmlmodule QtQuick.Controls
    \since 5.1
    \ingroup controls
    \brief Provides a button type that is typically used within a ToolBar.

    \image toolbar.png

    ToolButton is functionally similar to \l {QtQuick.Controls::}{Button}, but
    can provide a look that is more suitable within a \l ToolBar.

    \code
    ApplicationWindow {
        ...
        toolBar: ToolBar {
            RowLayout {
                ToolButton {
                    iconSource: "new.png"
                }
                ToolButton {
                    iconSource: "open.png"
                }
                ToolButton {
                    iconSource: "save-as.png"
                }
                Item { Layout.fillWidth: true }
                CheckBox {
                    text: "Enabled"
                    checked: true
                }
            }
        }
    }
    \endcode

    You can create a custom appearance for a ToolButton by
    assigning a \l {ButtonStyle}.
*/

Button {
    id: button
    style: Settings.styleComponent(Settings.style, "ToolButtonStyle.qml", button)
}
