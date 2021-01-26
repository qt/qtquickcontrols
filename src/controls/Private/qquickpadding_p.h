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

#ifndef QQUICKPADDING_H
#define QQUICKPADDING_H

#include <QtCore/qobject.h>

QT_BEGIN_NAMESPACE

class QQuickPadding1 : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int left READ left WRITE setLeft NOTIFY leftChanged)
    Q_PROPERTY(int top READ top WRITE setTop NOTIFY topChanged)
    Q_PROPERTY(int right READ right WRITE setRight NOTIFY rightChanged)
    Q_PROPERTY(int bottom READ bottom WRITE setBottom NOTIFY bottomChanged)

    int m_left;
    int m_top;
    int m_right;
    int m_bottom;

public:
    QQuickPadding1(QObject *parent = 0) :
        QObject(parent),
        m_left(0),
        m_top(0),
        m_right(0),
        m_bottom(0) {}

    int left() const { return m_left; }
    int top() const { return m_top; }
    int right() const { return m_right; }
    int bottom() const { return m_bottom; }

public slots:
    void setLeft(int arg) { if (m_left != arg) {m_left = arg; emit leftChanged();}}
    void setTop(int arg) { if (m_top != arg) {m_top = arg; emit topChanged();}}
    void setRight(int arg) { if (m_right != arg) {m_right = arg; emit rightChanged();}}
    void setBottom(int arg) {if (m_bottom != arg) {m_bottom = arg; emit bottomChanged();}}

signals:
    void leftChanged();
    void topChanged();
    void rightChanged();
    void bottomChanged();
};

QT_END_NAMESPACE

#endif // QQUICKPADDING_H
