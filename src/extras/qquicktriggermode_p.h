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

#ifndef TRIGGERMODE_P_H
#define TRIGGERMODE_P_H

#include <QtCore/qglobal.h>
#include <QtCore/qobjectdefs.h>

QT_BEGIN_NAMESPACE

// TODO: Remove with v2.0
class QQuickActivationMode
{
    Q_GADGET
    Q_ENUMS(ActivationMode)
public:
    enum ActivationMode {
        ActivateOnPress = 0,
        ActivateOnRelease = 1,
        ActivateOnClick = 2
    };
};

class QQuickTriggerMode
{
    Q_GADGET
    Q_ENUMS(TriggerMode)
public:
    enum TriggerMode {
        TriggerOnPress = 0,
        TriggerOnRelease = 1,
        TriggerOnClick = 2
    };
};

QT_END_NAMESPACE

#endif // TRIGGERMODE_P_H
