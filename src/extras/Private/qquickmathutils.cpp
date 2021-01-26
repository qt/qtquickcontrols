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

#include "qquickmathutils_p.h"

#include <qmath.h>

QQuickMathUtils::QQuickMathUtils(QObject *parent) :
    QObject(parent)
{
}

qreal QQuickMathUtils::pi2() const
{
    return M_PI * 2;
}

/*!
    Converts the angle \a degrees to radians.
*/
qreal QQuickMathUtils::degToRad(qreal degrees) const {
    return qDegreesToRadians(degrees);
}

/*!
    Converts the angle \a degrees to radians.

    This function assumes that the angle origin (0) is north, as this
    is the origin used by all of the Extras. The angle
    returned will have its angle origin (0) pointing east, in order to be
    consistent with standard angles used by \l {QtQuick::Canvas}{Canvas},
    for example.
*/
qreal QQuickMathUtils::degToRadOffset(qreal degrees) const {
    return qDegreesToRadians(degrees - 90);
}

/*!
    Converts the angle \a radians to degrees.
*/
qreal QQuickMathUtils::radToDeg(qreal radians) const {
    return qRadiansToDegrees(radians);
}

/*!
    Converts the angle \a radians to degrees.

    This function assumes that the angle origin (0) is east; as is standard for
    mathematical operations using radians (this origin is used by
    \l {QtQuick::Canvas}{Canvas}, for example). The angle returned in degrees
    will have its angle origin (0) pointing north, which is what the extras
    expect.
*/
qreal QQuickMathUtils::radToDegOffset(qreal radians) const {
    return qRadiansToDegrees(radians) + 90;
}

/*!
    Returns the top left position of the item if it were centered along
    a circle according to \a angleOnCircle and \a distanceAlongRadius.

    \a angleOnCircle is from 0.0 - M_PI2.
    \a distanceAlongRadius is the distance along the radius in M_PIxels.
*/
QPointF QQuickMathUtils::centerAlongCircle(qreal xCenter, qreal yCenter,
    qreal width, qreal height, qreal angleOnCircle, qreal distanceAlongRadius) const {
    return QPointF(
        (xCenter - width / 2) + (distanceAlongRadius * qCos(angleOnCircle)),
        (yCenter - height / 2) + (distanceAlongRadius * qSin(angleOnCircle)));
}

/*!
    Returns \a number rounded to the nearest even integer.
*/
qreal QQuickMathUtils::roundEven(qreal number) const {
    int rounded = qRound(number);
    return rounded % 2 == 0 ? rounded : rounded + 1;
}
