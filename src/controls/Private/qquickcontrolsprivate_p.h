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

#ifndef QQUICKCONTROLSPRIVATE_P_H
#define QQUICKCONTROLSPRIVATE_P_H

#include "qqml.h"
#include "qquicktooltip_p.h"
#include "qquickcontrolsettings_p.h"

QT_BEGIN_NAMESPACE

class QQuickWindow;

class QQuickControlsPrivate1Attached : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQuickWindow* window READ window NOTIFY windowChanged)

public:
    QQuickControlsPrivate1Attached(QObject* attachee);

    QQuickWindow *window() const;

Q_SIGNALS:
    void windowChanged();

private:
    QQuickItem* m_attachee;
};

class QQuickControlsPrivate1 : public QObject
{
    Q_OBJECT

public:
    static QObject *registerTooltipModule(QQmlEngine *engine, QJSEngine *jsEngine);
    static QObject *registerSettingsModule(QQmlEngine *engine, QJSEngine *jsEngine);

    static QQuickControlsPrivate1Attached *qmlAttachedProperties(QObject *object);
};

QT_END_NAMESPACE

QML_DECLARE_TYPEINFO(QQuickControlsPrivate1, QML_HAS_ATTACHED_PROPERTIES)

#endif // QQUICKCONTROLSPRIVATE_P_H
