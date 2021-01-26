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

ParallelAnimation {
    id: root
    /*! The name of the animation that is running. Can be one of the following:
    \list
    \li 'PushTransition'
    \li 'PopTransition'
    \li 'ReplaceTransition'
    \endlist
    */
    property string name
    /*! The page that is transitioning in. */
    property Item enterItem
    /*! The page that is transitioning out */
    property Item exitItem
    /*! Set to \c true if the transition is told to
        fast-forward directly to its end-state */
    property bool immediate
}
