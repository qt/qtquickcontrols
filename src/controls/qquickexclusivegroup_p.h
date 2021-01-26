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

#ifndef QQUICKEXCLUSIVEGROUP1_H
#define QQUICKEXCLUSIVEGROUP1_H

#include <QtCore/qobject.h>
#include <QtCore/qmetaobject.h>
#include <QtQml/qqmllist.h>

QT_BEGIN_NAMESPACE

class QQuickAction1;

class QQuickExclusiveGroup1 : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QObject *current READ current WRITE setCurrent NOTIFY currentChanged)
    Q_PROPERTY(QQmlListProperty<QQuickAction1> __actions READ actions)
    Q_CLASSINFO("DefaultProperty", "__actions")

public:
    explicit QQuickExclusiveGroup1(QObject *parent = 0);

    QObject *current() const { return m_current; }
    void setCurrent(QObject * o);

    QQmlListProperty<QQuickAction1> actions();

public Q_SLOTS:
    void bindCheckable(QObject *o);
    void unbindCheckable(QObject *o);

Q_SIGNALS:
    void currentChanged();

private Q_SLOTS:
    void updateCurrent();

private:
    static void append_actions(QQmlListProperty<QQuickAction1> *list, QQuickAction1 *action);

    QObject * m_current;
    QMetaMethod m_updateCurrentMethod;
};

QT_END_NAMESPACE

#endif // QQUICKEXCLUSIVEGROUP1_H
