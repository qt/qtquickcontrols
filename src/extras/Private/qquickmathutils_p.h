/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Quick Extras module of the Qt Toolkit.
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

#ifndef QQUICKMATHUTILS_P
#define QQUICKMATHUTILS_P

#include <QObject>
#include <QPointF>

class QQuickMathUtils : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal pi2 READ pi2 CONSTANT)
public:
    QQuickMathUtils(QObject *parent = 0);

    qreal pi2() const;
    Q_INVOKABLE qreal degToRad(qreal degrees) const;
    Q_INVOKABLE qreal degToRadOffset(qreal degrees) const;
    Q_INVOKABLE qreal radToDeg(qreal radians) const;
    Q_INVOKABLE qreal radToDegOffset(qreal radians) const;
    Q_INVOKABLE QPointF centerAlongCircle(qreal xCenter, qreal yCenter,
        qreal width, qreal height, qreal angleOnCircle, qreal distanceAlongRadius) const;
    Q_INVOKABLE qreal roundEven(qreal number) const;
};

#endif // QQUICKMATHUTILS_P

