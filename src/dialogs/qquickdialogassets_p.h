/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Quick Dialogs module of the Qt Toolkit.
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

#ifndef QQUICKDIALOGASSETS_P_H
#define QQUICKDIALOGASSETS_P_H

#include <private/qtquickglobal_p.h>
#include <QtGui/qpa/qplatformdialoghelper.h>
#include "qquickabstractmessagedialog_p.h"

QT_BEGIN_NAMESPACE

class QQuickStandardButton
{
    Q_GADGET
    Q_ENUMS(QQuickAbstractDialog::StandardButton)
};

class QQuickStandardIcon
{
    Q_GADGET
    Q_ENUMS(QQuickAbstractMessageDialog::Icon)
};

QT_END_NAMESPACE

#endif // QQUICKDIALOGASSETS_P_H
