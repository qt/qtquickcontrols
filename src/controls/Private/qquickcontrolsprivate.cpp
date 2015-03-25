/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
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

#include "qquickcontrolsprivate_p.h"
#include <qquickitem.h>
#include <qquickwindow.h>

QT_BEGIN_NAMESPACE

QQuickControlsPrivateAttached::QQuickControlsPrivateAttached(QObject *attachee)
    : m_attachee(qobject_cast<QQuickItem*>(attachee))
{
    if (m_attachee)
        connect(m_attachee, &QQuickItem::windowChanged, this, &QQuickControlsPrivateAttached::windowChanged);
}

QQuickWindow *QQuickControlsPrivateAttached::window() const
{
    return m_attachee ? m_attachee->window() : 0;
}

QObject *QQuickControlsPrivate::registerTooltipModule(QQmlEngine *engine, QJSEngine *jsEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(jsEngine);
    return new QQuickTooltip();
}

QObject *QQuickControlsPrivate::registerSettingsModule(QQmlEngine *engine, QJSEngine *jsEngine)
{
    Q_UNUSED(jsEngine);
    return new QQuickControlSettings(engine);
}

QQuickControlsPrivateAttached *QQuickControlsPrivate::qmlAttachedProperties(QObject *object)
{
    return new QQuickControlsPrivateAttached(object);
}

QT_END_NAMESPACE


