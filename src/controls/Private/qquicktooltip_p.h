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

#ifndef QQUICKTOOLTIP_P_H
#define QQUICKTOOLTIP_P_H

#include <QtCore/qobject.h>

QT_BEGIN_NAMESPACE

class QPointF;
class QQuickItem;

class QQuickTooltip1 : public QObject
{
    Q_OBJECT

public:
    QQuickTooltip1(QObject *parent = 0);

    Q_INVOKABLE void showText(QQuickItem *item, const QPointF &pos, const QString &text);
    Q_INVOKABLE void hideText();
};

QT_END_NAMESPACE

#endif // QQUICKTOOLTIP_P_H
