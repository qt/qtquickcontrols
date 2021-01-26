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
    \qmltype RadioButton
    \inqmlmodule QtQuick.Controls
    \since 5.1
    \ingroup controls
    \brief A radio button with a text label.

    \image radiobutton.png

    A RadioButton is an option button that can be switched on (checked) or off
    (unchecked). Radio buttons typically present the user with a "one of many"
    choices. In a group of radio buttons, only one radio button can be
    checked at a time; if the user selects another button, the previously
    selected button is switched off.

    \qml
    GroupBox {
        title: "Tab Position"

        RowLayout {
            ExclusiveGroup { id: tabPositionGroup }
            RadioButton {
                text: "Top"
                checked: true
                exclusiveGroup: tabPositionGroup
            }
            RadioButton {
                text: "Bottom"
                exclusiveGroup: tabPositionGroup
            }
        }
    }
    \endqml

    You can create a custom appearance for a RadioButton by
    assigning a \l {RadioButtonStyle}.
*/

AbstractCheckable {
    id: radioButton

    activeFocusOnTab: true

    Accessible.name: text
    Accessible.role: Accessible.RadioButton

    /*!
        The style that should be applied to the radio button. Custom style
        components can be created with:

        \codeline Qt.createComponent("path/to/style.qml", radioButtonId);
    */
    style: Settings.styleComponent(Settings.style, "RadioButtonStyle.qml", radioButton)

    __cycleStatesHandler: function() { checked = !checked; }
}
