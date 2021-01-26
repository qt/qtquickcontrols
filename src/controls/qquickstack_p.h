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

#ifndef QQUICKSTACK_P_H
#define QQUICKSTACK_P_H

#include <QtQuick/qquickitem.h>

QT_BEGIN_NAMESPACE

class QQuickStack1 : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int index READ index NOTIFY indexChanged)
    Q_PROPERTY(int __index READ index WRITE setIndex NOTIFY indexChanged)
    Q_PROPERTY(Status status READ status NOTIFY statusChanged)
    Q_PROPERTY(Status __status READ status WRITE setStatus NOTIFY statusChanged)
    Q_PROPERTY(QQuickItem* view READ view NOTIFY viewChanged)
    Q_PROPERTY(QQuickItem* __view READ view WRITE setView NOTIFY viewChanged)
    Q_ENUMS(Status)

public:
    QQuickStack1(QObject *object = 0);

    static QQuickStack1 *qmlAttachedProperties(QObject *object);

    int index() const;
    void setIndex(int index);

    enum Status {
        Inactive = 0,
        Deactivating = 1,
        Activating = 2,
        Active = 3
    };

    Status status() const;
    void setStatus(Status status);

    QQuickItem *view() const;
    void setView(QQuickItem *view);

signals:
    void statusChanged();
    void viewChanged();
    void indexChanged();

private:
    int m_index;
    Status m_status;
    QQuickItem *m_view;
};

QT_END_NAMESPACE

QML_DECLARE_TYPE(QQuickStack1)
QML_DECLARE_TYPEINFO(QQuickStack1, QML_HAS_ATTACHED_PROPERTIES)

#endif // QQUICKSTACK_P_H
