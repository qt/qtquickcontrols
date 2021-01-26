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

#ifndef QQUICKSELECTIONMODE_P_H
#define QQUICKSELECTIONMODE_P_H

#include <QtQuick/qquickitem.h>

QT_BEGIN_NAMESPACE

class QQuickSelectionMode1
{
    Q_GADGET
    Q_ENUMS(SelectionMode)
public:
    enum SelectionMode {
        NoSelection = 0,
        SingleSelection = 1,
        ExtendedSelection = 2,
        MultiSelection = 3,
        ContiguousSelection = 4
    };
};

QT_END_NAMESPACE

#endif // QQUICKSELECTIONMODE_P_H
