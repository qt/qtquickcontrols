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
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles.Android 1.0
import "drawables"

ScrollViewStyle {
    handleOverlap: 0
    transientScrollBars: true
    minimumHandleLength: AndroidStyle.styleDef.scrollViewStyle.View_scrollbarSize

    __scrollBarFadeDelay: AndroidStyle.styleDef.scrollViewStyle.View_scrollbarDefaultDelayBeforeFade || 300
    __scrollBarFadeDuration: AndroidStyle.styleDef.scrollViewStyle.View_scrollbarFadeDuration || 250

    padding { top: 0; left: 0; right: 0; bottom: 0 }

    corner: null
    incrementControl: null
    decrementControl: null

    frame: DrawableLoader {
        active: control.frameVisible
        visible: !!control["backgroundVisible"]
        styleDef: AndroidStyle.styleDef.scrollViewStyle.View_background
    }

    scrollBarBackground: Item {
        implicitWidth: Math.max(minimumHandleLength, track.implicitWidth)
        implicitHeight: Math.max(minimumHandleLength, track.implicitHeight)
        DrawableLoader {
            id: track
            styleDef: styleData.horizontal ? AndroidStyle.styleDef.scrollViewStyle.View_scrollbarTrackHorizontal
                                           : AndroidStyle.styleDef.scrollViewStyle.View_scrollbarTrackVertical
            focused: control.activeFocus
            window_focused: control.Window.active
        }
    }

    handle: DrawableLoader {
        styleDef: styleData.horizontal ? AndroidStyle.styleDef.scrollViewStyle.View_scrollbarThumbHorizontal
                                       : AndroidStyle.styleDef.scrollViewStyle.View_scrollbarThumbVertical
        pressed: styleData.pressed
        focused: control.activeFocus
        window_focused: control.Window.active
    }
}
