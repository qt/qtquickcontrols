/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Dialogs module of the Qt Toolkit.
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
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import "qml"

AbstractDialog {
    id: root
    default property alias data: defaultContentItem.data
    onVisibilityChanged: if (visible && contentItem) contentItem.forceActiveFocus()

    Rectangle {
        id: content
        property real spacing: 6
        property real outerSpacing: 12
        property real buttonsRowImplicitWidth: minimumWidth
        property bool buttonsInSingleRow: defaultContentItem.width >= buttonsRowImplicitWidth
        property real minimumHeight: implicitHeight
        property real minimumWidth: Screen.pixelDensity * 50
        implicitHeight: defaultContentItem.implicitHeight + spacing + outerSpacing * 2 + buttonsRight.implicitHeight
        implicitWidth: Math.min(root.__maximumDimension, Math.max(
            defaultContentItem.implicitWidth, buttonsRowImplicitWidth, Screen.pixelDensity * 50) + outerSpacing * 2);
        color: palette.window
        Keys.onPressed: {
            event.accepted = true
            switch (event.key) {
                case Qt.Key_Escape:
                case Qt.Key_Back:
                    reject()
                    break
                case Qt.Key_Enter:
                case Qt.Key_Return:
                    accept()
                    break
                default:
                    event.accepted = false
            }
        }

        SystemPalette { id: palette }

        Item {
            id: defaultContentItem
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: content.outerSpacing
            }
            implicitHeight: childrenRect.height
        }

        Flow {
            id: buttonsLeft
            spacing: content.spacing
            anchors {
                left: parent.left
                bottom: content.buttonsInSingleRow ? parent.bottom : buttonsRight.top
                margins: content.outerSpacing
            }

            Repeater {
                id: buttonsLeftRepeater
                Button {
                    text: (buttonsLeftRepeater.model && buttonsLeftRepeater.model[index] ? buttonsLeftRepeater.model[index].text : index)
                    onClicked: root.click(buttonsLeftRepeater.model[index].standardButton)
                }
            }

            Button {
                id: moreButton
                text: qsTr("Show Details...")
                visible: false
            }
        }

        Flow {
            id: buttonsRight
            spacing: content.spacing
            layoutDirection: Qt.RightToLeft
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: content.outerSpacing
            }

            Repeater {
                id: buttonsRightRepeater
                // TODO maybe: insert gaps if the button requires it (destructive buttons only)
                Button {
                    text: (buttonsRightRepeater.model && buttonsRightRepeater.model[index] ? buttonsRightRepeater.model[index].text : index)
                    onClicked: root.click(buttonsRightRepeater.model[index].standardButton)
                }
            }
        }
    }
    function setupButtons() {
        buttonsLeftRepeater.model = root.__standardButtonsLeftModel()
        buttonsRightRepeater.model = root.__standardButtonsRightModel()
        if (!buttonsRightRepeater.model || buttonsRightRepeater.model.length < 2)
            return;
        var calcWidth = 0;

        function calculateForButton(i, b) {
            var buttonWidth = b.implicitWidth;
            if (buttonWidth > 0) {
                if (i > 0)
                    buttonWidth += content.spacing
                calcWidth += buttonWidth
            }
        }

        for (var i = 0; i < buttonsRight.visibleChildren.length; ++i)
            calculateForButton(i, buttonsRight.visibleChildren[i])
        content.minimumWidth = calcWidth + content.outerSpacing * 2
        for (i = 0; i < buttonsLeft.visibleChildren.length; ++i)
            calculateForButton(i, buttonsLeft.visibleChildren[i])
        content.buttonsRowImplicitWidth = calcWidth + content.spacing
    }
    onStandardButtonsChanged: setupButtons()
    Component.onCompleted: setupButtons()
}
