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

#include "qquickcontrolsprivate_p.h"
#include <qquickitem.h>
#include <qquickwindow.h>

QT_BEGIN_NAMESPACE

QQuickControlsPrivate1Attached::QQuickControlsPrivate1Attached(QObject *attachee)
    : m_attachee(qobject_cast<QQuickItem*>(attachee))
{
    if (m_attachee)
        connect(m_attachee, &QQuickItem::windowChanged, this, &QQuickControlsPrivate1Attached::windowChanged);
}

QQuickWindow *QQuickControlsPrivate1Attached::window() const
{
    return m_attachee ? m_attachee->window() : 0;
}

QObject *QQuickControlsPrivate1::registerTooltipModule(QQmlEngine *engine, QJSEngine *jsEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(jsEngine);
    return new QQuickTooltip1();
}

QObject *QQuickControlsPrivate1::registerSettingsModule(QQmlEngine *engine, QJSEngine *jsEngine)
{
    Q_UNUSED(jsEngine);
    return new QQuickControlSettings1(engine);
}

QQuickControlsPrivate1Attached *QQuickControlsPrivate1::qmlAttachedProperties(QObject *object)
{
    return new QQuickControlsPrivate1Attached(object);
}

QT_END_NAMESPACE


