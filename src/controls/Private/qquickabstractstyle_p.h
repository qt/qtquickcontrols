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

#ifndef QQUICKABSTRACTSTYLE_H
#define QQUICKABSTRACTSTYLE_H

#include <QtCore/qobject.h>
#include <QtQml/qqmllist.h>
#include "qquickpadding_p.h"

QT_BEGIN_NAMESPACE

class QQuickAbstractStyle1 : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QQuickPadding1* padding READ padding CONSTANT)
    Q_PROPERTY(QQmlListProperty<QObject> data READ data DESIGNABLE false)
    Q_CLASSINFO("DefaultProperty", "data")

public:
    QQuickAbstractStyle1(QObject *parent = 0);

    QQuickPadding1* padding() { return &m_padding; }

    QQmlListProperty<QObject> data();

private:
    static void data_append(QQmlListProperty<QObject> *list, QObject *object);
    static int data_count(QQmlListProperty<QObject> *list);
    static QObject *data_at(QQmlListProperty<QObject> *list, int index);
    static void data_clear(QQmlListProperty<QObject> *list);

    QQuickPadding1 m_padding;
    QList<QObject *> m_data;
};

QT_END_NAMESPACE

#endif // QQUICKABSTRACTSTYLE_H
